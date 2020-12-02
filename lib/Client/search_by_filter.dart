import 'package:alif_pet/Apis/client_apis.dart';
import 'package:alif_pet/Client/searched_doctor.dart';
import 'package:alif_pet/Common/app_background.dart';
import 'package:alif_pet/Common/my_loader.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/Utils/string_utils.dart';
import 'package:alif_pet/Utils/toast_utils.dart';
import 'package:alif_pet/models/country.dart';
import 'package:alif_pet/models/profile.dart';
import 'package:alif_pet/models/speciality.dart';
import 'package:alif_pet/models/state.dart' as myState;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'doctor_profile_for_client.dart';

class SearchFilter extends StatefulWidget {
  final bool fromBrowse;
  const SearchFilter({Key key, this.fromBrowse}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SearchFilterState();
  }
}

class SearchFilterState extends State<SearchFilter> {
  var byName = false,
      bySpecialty = false,
      byState = false,
      isLoading = true,
      isSearching = false,
      isInternet = true;
  List<Profile> searchedDoctors = List();
  List<myState.State> states = [];
  List<Speciality> specialities = [];
  List<Country> countries = [];
  myState.State selectedState;
  Speciality selectedSpeciality;
  String selectedName;
  final nameController = TextEditingController();
  List<DropdownMenuItem<myState.State>> stateItems = List();
  List<DropdownMenuItem<Speciality>> specialityItems = List();
  Map<String, dynamic> searchMap = Map();
  @override
  void initState() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        ClientApis().getCountriesAndSpecialities().then((result) {
          if (result is String) {
            //ToastUtils.showCustomToast(context, result, Colors.white , MyColors.primaryColor);
          } else {
            countries = result[0];
            specialities = result[1];
            for (int i = 0; i < countries.length; i++) {
              states.addAll(countries[i].states);
            }
            isLoading = false;
            isInternet = true;
            setUpDropDowns();
            if (mounted) {
              setState(() {});
            }
          }
        });
      } else {
        setState(() {
          isInternet = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setUpDropDowns() {
    specialityItems = specialities
        .asMap()
        .values
        .map((value) => DropdownMenuItem<Speciality>(
            value: value,
            child: Container(
              margin: EdgeInsets.only(left: 1.5 * SizeConfig.widthMultiplier),
              child: Text(
                value.name,
                style: TextStyle(
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  fontFamily: FontUtils.ceraProMedium,
                  color: MyColors.primaryColor,
                ),
              ),
            )))
        .toList();
    stateItems = states
        .asMap()
        .values
        .map((stateValue) => DropdownMenuItem<myState.State>(
            value: stateValue,
            child: Container(
              margin: EdgeInsets.only(left: 1.5 * SizeConfig.widthMultiplier),
              child: Text(
                stateValue.name,
                style: TextStyle(
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  fontFamily: FontUtils.ceraProMedium,
                  color: MyColors.primaryColor,
                ),
              ),
            )))
        .toList();
    selectedState = states[0];
    selectedSpeciality = specialities[0];
  }

  void searchDoctors() {
    searchMap.clear();
    if (byName && nameController.text.length > 0) {
      searchMap.putIfAbsent("name", () => nameController.text);
    }
    if (byState) {
      searchMap.putIfAbsent("state", () => selectedState.id);
    }
    if (bySpecialty) {
      searchMap.putIfAbsent("speciality", () => selectedState.id);
    }
    CommonUtils.checkInternet().then((value) {
      if (value) {
        isSearching = true;
        isLoading = true;
        setState(() {});
        ClientApis().getDoctorsBySearch(searchMap).then((result) {
          if (result is String) {
            //ToastUtils.showCustomToast(context, result, Colors.white , MyColors.primaryColor);
          } else {
            searchedDoctors = result;
            isSearching = false;
            isLoading = false;
            setState(() {});
          }
        });
      } else {
        ToastUtils.showCustomToast(context, StringUtils.noInternet,
            Colors.white, MyColors.primaryColor);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            AppBackground(),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                height: 7.5 * SizeConfig.heightMultiplier,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.keyboard_backspace,
                          color: MyColors.primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 13 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 13 * SizeConfig.widthMultiplier),
                      child: Hero(
                        tag: "logo",
                        child: Material(
                          color: Colors.transparent,
                          child: Image.asset(
                            ImageUtils.logo,
                            width: 8.5 * SizeConfig.imageSizeMultiplier,
                            height: 8.5 * SizeConfig.imageSizeMultiplier,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 25 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 25 * SizeConfig.widthMultiplier),
                      child: Text(
                        CommonUtils.translate(context, "search"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProBold,
                            fontSize: 2.9 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                      ),
                    ),
                    Align(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin:
                                CommonUtils.getLanguage(context) == "english"
                                    ? EdgeInsets.only(
                                        right: 2 * SizeConfig.widthMultiplier)
                                    : EdgeInsets.only(
                                        left: 2 * SizeConfig.widthMultiplier),
                            child: Icon(Icons.notifications,
                                color: MyColors.primaryColor),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20 * SizeConfig.heightMultiplier),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (byName) {
                          byName = false;
                        } else {
                          byName = true;
                        }
                      });
                    },
                    child: Container(
                      width: ScreenUtil.getInstance().width.toDouble(),
                      margin: EdgeInsets.symmetric(
                          horizontal: 1.5 * SizeConfig.widthMultiplier),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.5),
                                blurRadius: .1 * SizeConfig.imageSizeMultiplier,
                                spreadRadius: .6,
                                offset: Offset(0, 1)),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(
                              .7 * SizeConfig.imageSizeMultiplier))),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 7 * SizeConfig.heightMultiplier,
                              color: MyColors.primaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Stack(
                                      children: <Widget>[
                                        Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  right: 1.5 *
                                                      SizeConfig
                                                          .widthMultiplier),
                                              height: 3.5 *
                                                  SizeConfig
                                                      .imageSizeMultiplier,
                                              width: 3.5 *
                                                  SizeConfig
                                                      .imageSizeMultiplier,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                      color: MyColors.red,
                                                      width: 1)),
                                              child: Container(
                                                height: 3.5 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                                width: 3.5 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: Colors.white,
                                                ),
                                                child: byName
                                                    ? Container(
                                                        margin: EdgeInsets.all(.6 *
                                                            SizeConfig
                                                                .imageSizeMultiplier),
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                color: MyColors
                                                                    .red),
                                                      )
                                                    : Container(),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Text(
                                      CommonUtils.translate(
                                          context, "search_by_name"),
                                      style: TextStyle(
                                          fontFamily: FontUtils.ceraProBold,
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 7 * SizeConfig.heightMultiplier,
                              color: MyColors.grey,
                              child: TextFormField(
                                controller: nameController,
                                cursorColor: MyColors.primaryColor,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textAlign: TextAlign.start,
                                autofocus: false,
                                style: TextStyle(
                                  fontSize: 3 * SizeConfig.textMultiplier,
                                  fontFamily: FontUtils.ceraProMedium,
                                  color: MyColors.primaryColor,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 1 * SizeConfig.heightMultiplier,
                                      horizontal:
                                          1 * SizeConfig.widthMultiplier),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (bySpecialty) {
                          bySpecialty = false;
                        } else {
                          bySpecialty = true;
                        }
                      });
                    },
                    child: Container(
                      width: ScreenUtil.getInstance().width.toDouble(),
                      margin: EdgeInsets.symmetric(
                          horizontal: 1.5 * SizeConfig.widthMultiplier,
                          vertical: 1.5 * SizeConfig.heightMultiplier),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.5),
                                blurRadius: .1 * SizeConfig.imageSizeMultiplier,
                                spreadRadius: .6,
                                offset: Offset(0, 1)),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(
                              .7 * SizeConfig.imageSizeMultiplier))),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 7 * SizeConfig.heightMultiplier,
                              color: MyColors.primaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Stack(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: 1.5 *
                                                    SizeConfig.widthMultiplier),
                                            height: 3.5 *
                                                SizeConfig.imageSizeMultiplier,
                                            width: 3.5 *
                                                SizeConfig.imageSizeMultiplier,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                    color: MyColors.red,
                                                    width: 1)),
                                            child: Container(
                                              height: 3.5 *
                                                  SizeConfig
                                                      .imageSizeMultiplier,
                                              width: 3.5 *
                                                  SizeConfig
                                                      .imageSizeMultiplier,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: Colors.white,
                                              ),
                                              child: bySpecialty
                                                  ? Container(
                                                      margin: EdgeInsets.all(.6 *
                                                          SizeConfig
                                                              .imageSizeMultiplier),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          color: MyColors.red),
                                                    )
                                                  : Container(),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Text(
                                      CommonUtils.translate(
                                          context, "search_by_specialty"),
                                      style: TextStyle(
                                          fontFamily: FontUtils.ceraProBold,
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 7 * SizeConfig.heightMultiplier,
                              color: MyColors.grey,
                              child: DropdownButton<Speciality>(
                                onChanged: (data) {
                                  setState(() {
                                    selectedSpeciality = data;
                                  });
                                },
                                items: specialityItems.length > 0
                                    ? specialityItems
                                    : null,
                                value: selectedSpeciality != null
                                    ? selectedSpeciality
                                    : null,
                                isExpanded: true,
                                underline: Container(),
                                icon: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 6 * SizeConfig.imageSizeMultiplier,
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (byState) {
                          byState = false;
                        } else {
                          byState = true;
                        }
                      });
                    },
                    child: Container(
                      width: ScreenUtil.getInstance().width.toDouble(),
                      margin: EdgeInsets.only(
                          top: 1.5 * SizeConfig.widthMultiplier,
                          right: 1.5 * SizeConfig.widthMultiplier,
                          left: 1.5 * SizeConfig.widthMultiplier),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.5),
                                blurRadius: .1 * SizeConfig.imageSizeMultiplier,
                                spreadRadius: .6,
                                offset: Offset(0, 1)),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(
                              .7 * SizeConfig.imageSizeMultiplier))),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 7 * SizeConfig.heightMultiplier,
                              color: MyColors.primaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: Stack(
                                        children: <Widget>[
                                          Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: 1.5 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                height: 3.5 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                                width: 3.5 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all(
                                                        color: MyColors.red,
                                                        width: 1)),
                                                child: Container(
                                                  height: 3.5 *
                                                      SizeConfig
                                                          .imageSizeMultiplier,
                                                  width: 3.5 *
                                                      SizeConfig
                                                          .imageSizeMultiplier,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Colors.white,
                                                  ),
                                                  child: byState
                                                      ? Container(
                                                          margin: EdgeInsets
                                                              .all(.6 *
                                                                  SizeConfig
                                                                      .imageSizeMultiplier),
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  color:
                                                                      MyColors
                                                                          .red),
                                                        )
                                                      : Container(),
                                                ),
                                              ))
                                        ],
                                      )),
                                  Expanded(
                                    flex: 8,
                                    child: Text(
                                      CommonUtils.translate(
                                          context, "search_by_state"),
                                      style: TextStyle(
                                          fontFamily: FontUtils.ceraProBold,
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 7 * SizeConfig.heightMultiplier,
                              color: MyColors.grey,
                              child: DropdownButton<myState.State>(
                                onChanged: (data) {
                                  setState(() {
                                    selectedState = data;
                                  });
                                },
                                items:
                                    stateItems.length > 0 ? stateItems : null,
                                value: selectedState != null
                                    ? selectedState
                                    : null,
                                isExpanded: true,
                                underline: Container(),
                                icon: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 6 * SizeConfig.imageSizeMultiplier,
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: 4 * SizeConfig.heightMultiplier),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                right: CommonUtils.getLanguage(context) !=
                                        "english"
                                    ? 6.5 * SizeConfig.widthMultiplier
                                    : 3.5 * SizeConfig.widthMultiplier,
                                left: CommonUtils.getLanguage(context) !=
                                        "english"
                                    ? 3.5 * SizeConfig.widthMultiplier
                                    : 6.5 * SizeConfig.widthMultiplier),
                            child: MaterialButton(
                              child: Text(
                                  CommonUtils.translate(context, "search"),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 2.3 * SizeConfig.textMultiplier,
                                      fontFamily: FontUtils.ceraProRegular)),
                              onPressed: (isLoading ||
                                      (!byName && !bySpecialty && !byState))
                                  ? null
                                  : searchDoctors,
                              height: 5 * SizeConfig.heightMultiplier,
                              minWidth: double.infinity,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2.8 *
                                          SizeConfig.imageSizeMultiplier))),
                              color: MyColors.primaryColor,
                              elevation: 0.0,
                              highlightElevation: 0.0,
                              disabledColor:
                                  MyColors.primaryColor.withOpacity(.8),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                right: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? 6.5 * SizeConfig.widthMultiplier
                                    : 3.5 * SizeConfig.widthMultiplier,
                                left: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? 3.5 * SizeConfig.widthMultiplier
                                    : 6.5 * SizeConfig.widthMultiplier),
                            child: MaterialButton(
                              child: Text(
                                  CommonUtils.translate(context, "cancel"),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 2.3 * SizeConfig.textMultiplier,
                                      fontFamily: FontUtils.ceraProRegular)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              height: 5 * SizeConfig.heightMultiplier,
                              minWidth: double.infinity,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2.8 *
                                          SizeConfig.imageSizeMultiplier))),
                              color: MyColors.primaryColor,
                              elevation: 0.0,
                              highlightElevation: 0.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 57 * SizeConfig.heightMultiplier,
                  right: 2 * SizeConfig.widthMultiplier,
                  left: 2 * SizeConfig.widthMultiplier),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            left: 2.5 * SizeConfig.widthMultiplier)
                        : EdgeInsets.only(
                            right: 2.5 * SizeConfig.widthMultiplier),
                    child: Text(
                      CommonUtils.translate(context, 'searched_doctors'),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProMedium,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: ScreenUtil.getInstance().height.toDouble(),
              width: ScreenUtil.getInstance().width.toDouble(),
              margin: EdgeInsets.only(
                  top: 61 * SizeConfig.heightMultiplier,
                  right: 2 * SizeConfig.widthMultiplier,
                  left: 2 * SizeConfig.widthMultiplier,
                  bottom: 2 * SizeConfig.heightMultiplier),
              child: isSearching
                  ? MyLoader()
                  : GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: ScreenUtil.getInstance()
                                      .width
                                      .toDouble() /
                                  (ScreenUtil.getInstance().height.toDouble() -
                                      16 * SizeConfig.heightMultiplier),
                              mainAxisSpacing: 1 * SizeConfig.heightMultiplier),
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: DoctorProfileForClient(
                                        doctor: searchedDoctors[index],
                                      )));
                            },
                            child: SearchedDoctor(
                              doctor: searchedDoctors[index],
                            ));
                      },
                      itemCount: searchedDoctors.length),
            )
          ],
        ),
      ),
    );
  }
}
