import 'package:alif_pet/Apis/client_apis.dart';
import 'package:alif_pet/Client/doctor_profile_for_client.dart';
import 'package:alif_pet/Client/searched_doctor.dart';
import 'package:alif_pet/Common/app_background.dart';
import 'package:alif_pet/Common/my_loader.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/models/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class BrowseDoctors extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BrowseDoctorsState();
  }
}

class BrowseDoctorsState extends State<BrowseDoctors> {
  double searchWidth = 0, searchHeight = 0;
  final searchController = TextEditingController();
  bool isLoading = true;
  bool isSearchClosed = true;
  bool isInternet = false;
  bool isSearchOpen = false;
  var searchType;
  List<Profile> doctors = List();
  List<Profile> searchedDoctors = List();
  void openSearch() {
    searchWidth = ScreenUtil.getInstance().width.toDouble();
    searchHeight = 8 * SizeConfig.heightMultiplier;
    isSearchOpen = true;
    isSearchClosed = false;
    setState(() {});
  }

  void closeSearch() {
    searchWidth = 0;
    searchHeight = 0;
    isSearchOpen = false;
    setState(() {});
    Future.delayed(Duration(milliseconds: 550), () {
      setState(() {
        if (!isSearchOpen) {
          isSearchClosed = true;
        }
      });
    });
  }

  @override
  void initState() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        ClientApis().getDoctors().then((result) {
          if (result is String) {
            //ToastUtils.showCustomToast(context, result, Colors.white , MyColors.primaryColor);
          } else {
            doctors = result;
            isLoading = false;
            setState(() {});
          }
        });
      } else {
        setState(() {
          isInternet = false;
        });
      }
    });
    searchController.addListener(() {
      searchedDoctors = searchType == "byname"
          ? doctors
              .where((doc) => doc.name
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
              .toList()
          : doctors
              .where((doc) => doc.speciality.name
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
              .toList();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
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
                        alignment: CommonUtils.getLanguage(context) == "english"
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        margin: CommonUtils.getLanguage(context) == "english"
                            ? EdgeInsets.only(
                                left: 25 * SizeConfig.widthMultiplier)
                            : EdgeInsets.only(
                                right: 25 * SizeConfig.widthMultiplier),
                        child: Text(
                          CommonUtils.translate(context, 'browse_doctors'),
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProMedium,
                              fontSize: 2.9 * SizeConfig.textMultiplier,
                              color: MyColors.primaryColor),
                        ),
                      ),
                      Container(
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          margin: CommonUtils.getLanguage(context) == "english"
                              ? EdgeInsets.only(
                                  right: 9 * SizeConfig.widthMultiplier)
                              : EdgeInsets.only(
                                  left: 9 * SizeConfig.widthMultiplier),
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: ImageIcon(
                                AssetImage(ImageUtils.filterIcon),
                                color: MyColors.primaryColor,
                                size: 5 * SizeConfig.imageSizeMultiplier,
                              ))),
                      Align(
                        alignment: CommonUtils.getLanguage(context) == "english"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.notifications,
                                color: MyColors.primaryColor)),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 11 * SizeConfig.heightMultiplier,
                    right: 2 * SizeConfig.widthMultiplier,
                    left: 2 * SizeConfig.widthMultiplier),
                height: 9 * SizeConfig.heightMultiplier,
                child: Card(
                  color: MyColors.grey,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              1.5 * SizeConfig.imageSizeMultiplier),
                          bottomLeft: Radius.circular(
                              1.5 * SizeConfig.imageSizeMultiplier),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(0))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (searchType == null ||
                                  searchType == "byspecialty") {
                                // ignore: unnecessary_statements
                                searchType == null ? openSearch() : null;
                                searchType = "byname";
                              } else {
                                searchType = null;
                                closeSearch();
                              }
                            });
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              color: searchType == "byname"
                                  ? MyColors.primaryColor
                                  : Colors.transparent,
                              shape: CommonUtils.getLanguage(context) ==
                                      "english"
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(1.5 *
                                              SizeConfig.imageSizeMultiplier),
                                          bottomLeft: Radius.circular(1.5 *
                                              SizeConfig.imageSizeMultiplier),
                                          topRight: Radius.circular(0),
                                          bottomRight: Radius.circular(0)))
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(1.5 *
                                              SizeConfig.imageSizeMultiplier),
                                          bottomRight: Radius.circular(1.5 *
                                              SizeConfig.imageSizeMultiplier))),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    CommonUtils.translate(
                                        context, 'search_by_name'),
                                    style: TextStyle(
                                        fontFamily: FontUtils.ceraProMedium,
                                        fontSize:
                                            2.5 * SizeConfig.textMultiplier,
                                        color: searchType == "byname"
                                            ? Colors.white
                                            : MyColors.primaryColor),
                                  ),
                                ),
                                Align(
                                  alignment: CommonUtils.getLanguage(context) ==
                                          "english"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    color: Colors.grey.withOpacity(.2),
                                    height: ScreenUtil.getInstance()
                                        .width
                                        .toDouble(),
                                    width: 1,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            if (searchType == null || searchType == "byname") {
                              // ignore: unnecessary_statements
                              searchType == null ? openSearch() : null;
                              searchType = "byspecialty";
                              openSearch();
                            } else {
                              searchType = null;
                              closeSearch();
                            }
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              color: searchType == "byspecialty"
                                  ? MyColors.primaryColor
                                  : Colors.transparent,
                              shape: CommonUtils.getLanguage(context) ==
                                      "arabic"
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(1.5 *
                                              SizeConfig.imageSizeMultiplier),
                                          bottomLeft: Radius.circular(1.5 *
                                              SizeConfig.imageSizeMultiplier)))
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(1.5 *
                                              SizeConfig.imageSizeMultiplier),
                                          bottomRight: Radius.circular(1.5 *
                                              SizeConfig.imageSizeMultiplier))),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                CommonUtils.translate(
                                    context, 'search_by_specialty'),
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProMedium,
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                    color: searchType == "byspecialty"
                                        ? Colors.white
                                        : MyColors.primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                alignment: Alignment.center,
                duration: Duration(milliseconds: 550),
                curve: Curves.easeOut,
                margin: EdgeInsets.only(
                    top: 21 * SizeConfig.heightMultiplier,
                    right: 2 * SizeConfig.widthMultiplier,
                    left: 2 * SizeConfig.widthMultiplier),
                width: searchWidth,
                height: searchHeight,
                onEnd: () {},
                child: isSearchClosed
                    ? Container()
                    : Container(
                        alignment: Alignment.center,
                        height: 6 * SizeConfig.heightMultiplier,
                        margin: EdgeInsets.only(
                            left: 6.5 * SizeConfig.widthMultiplier,
                            right: 6.5 * SizeConfig.widthMultiplier),
                        child: TextFormField(
                          controller: searchController,
                          cursorColor: MyColors.primaryColor,
                          textAlign: TextAlign.start,
                          autofocus: false,
                          style: TextStyle(
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontFamily: FontUtils.ceraProMedium,
                            color: MyColors.primaryColor,
                          ),
                          decoration: InputDecoration(
                            hintText: searchType == "byname"
                                ? CommonUtils.translate(
                                    context, "search_by_doctor_name")
                                : CommonUtils.translate(
                                    context, "search_by_specialty_name"),
                            hintStyle: TextStyle(
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                              fontFamily: FontUtils.ceraProMedium,
                              color: MyColors.primaryColor.withOpacity(.5),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 1.0 * SizeConfig.heightMultiplier,
                                horizontal: 3.0 * SizeConfig.widthMultiplier),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: MyColors.red),
                              borderRadius: BorderRadius.circular(
                                  2.8 * SizeConfig.imageSizeMultiplier),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: MyColors.red),
                              borderRadius: BorderRadius.circular(
                                  2.8 * SizeConfig.imageSizeMultiplier),
                            ),
                          ),
                        ),
                      ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 550),
                curve: Curves.easeOut,
                margin: EdgeInsets.only(
                    top: isSearchOpen
                        ? 29 * SizeConfig.heightMultiplier
                        : 22 * SizeConfig.heightMultiplier,
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
                        CommonUtils.translate(context, 'all_doctors'),
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
              AnimatedContainer(
                curve: Curves.easeOut,
                duration: Duration(milliseconds: 550),
                height: ScreenUtil.getInstance().height.toDouble(),
                width: ScreenUtil.getInstance().width.toDouble(),
                margin: EdgeInsets.only(
                    top: isSearchOpen
                        ? 34 * SizeConfig.heightMultiplier
                        : 27 * SizeConfig.heightMultiplier,
                    right: 2 * SizeConfig.widthMultiplier,
                    left: 2 * SizeConfig.widthMultiplier,
                    bottom: 2 * SizeConfig.heightMultiplier),
                child: isLoading
                    ? MyLoader()
                    : GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio:
                                    ScreenUtil.getInstance().width.toDouble() /
                                        (ScreenUtil.getInstance()
                                                .height
                                                .toDouble() -
                                            14 * SizeConfig.heightMultiplier),
                                mainAxisSpacing:
                                    1 * SizeConfig.heightMultiplier),
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: DoctorProfileForClient(
                                            doctor: isSearchOpen &&
                                                    searchController
                                                            .text.length >
                                                        0
                                                ? searchedDoctors[index]
                                                : doctors[index])));
                              },
                              child: SearchedDoctor(
                                doctor: isSearchOpen &&
                                        searchController.text.length > 0
                                    ? searchedDoctors[index]
                                    : doctors[index],
                              ));
                        },
                        itemCount:
                            isSearchOpen && searchController.text.length > 0
                                ? searchedDoctors.length
                                : doctors.length),
              )
            ],
          ),
        ));
  }
}
