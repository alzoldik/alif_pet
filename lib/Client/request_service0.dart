import 'package:alif_pet/Apis/client_apis.dart';
import 'package:alif_pet/Client/request_service.dart';
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
import 'package:alif_pet/models/service_of_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RequestService0 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RequestService0State();
  }
}

class RequestService0State extends State<RequestService0> {
  final searchController = TextEditingController();
  bool isLoading = true;
  List<DropdownMenuItem<Service_of_request>> serviceItems = List();
  bool isInternet = false;
  var searchType;
  List<Profile> doctors = List();
  List<Profile> searchedDoctors = List();
  List<Service_of_request> services = List();
  Service_of_request selectedService;
  bool isEnglish;
  void setUpDropDowns() {
    serviceItems = services
        .asMap()
        .values
        .map((value) => DropdownMenuItem<Service_of_request>(
            value: value,
            child: Container(
              margin: EdgeInsets.only(left: 1.5 * SizeConfig.widthMultiplier),
              child: Text(
                isEnglish ? value.name : value.nameAr,
                style: TextStyle(
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  fontFamily: FontUtils.ceraProMedium,
                  color: MyColors.primaryColor,
                ),
              ),
            )))
        .toList();
  }

  @override
  void initState() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        ClientApis().getDoctorsAndServices().then((result) {
          if (result is String) {
            //ToastUtils.showCustomToast(context, result, Colors.white , MyColors.primaryColor);
          } else {
            doctors = result[0];
            services = result[1];
            isLoading = false;
            setUpDropDowns();
            selectedService = services[0];
            for (int i = 0; i < doctors.length; i++) {
              if (doctors[i].services != null &&
                  doctors[i].services.length > 0) {
                for (int j = 0; j < doctors[i].services.length; j++) {
                  if (doctors[i].services[j].id == selectedService.id) {
                    searchedDoctors.add(doctors[i]);
                    break;
                  }
                }
              }
            }
            setState(() {});
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
  void didChangeDependencies() {
    isEnglish = CommonUtils.getLanguage(context) == "english";
    super.didChangeDependencies();
  }

  @override
  void dispose() {
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
                        alignment: CommonUtils.getLanguage(context) == "english"
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        margin: CommonUtils.getLanguage(context) == "english"
                            ? EdgeInsets.only(
                                left: 25 * SizeConfig.widthMultiplier)
                            : EdgeInsets.only(
                                right: 25 * SizeConfig.widthMultiplier),
                        child: Text(
                          CommonUtils.translate(context, "request_service"),
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProBold,
                              fontSize: 2.9 * SizeConfig.textMultiplier,
                              color: MyColors.primaryColor),
                        ),
                      ),
                      /*       Container(
                          alignment: CommonUtils.getLanguage(context)=="english"?Alignment.centerRight:Alignment.centerLeft,
                          margin: CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(right: 11.5*SizeConfig.widthMultiplier) : EdgeInsets.only(left: 11.5*SizeConfig.widthMultiplier),
                          child: InkWell(onTap:(){
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SearchFilter()));
                          },child: ImageIcon(AssetImage(ImageUtils.filter_icon),color: MyColors.primaryColor,size: 5*SizeConfig.imageSizeMultiplier,))
                      ),*/
                      Align(
                        alignment: CommonUtils.getLanguage(context) == "english"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: InkWell(
                            onTap: () {
                              // Navigator.pop(context);
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
                  margin: EdgeInsets.only(
                      top: 11 * SizeConfig.heightMultiplier,
                      right: 2 * SizeConfig.widthMultiplier,
                      left: 2 * SizeConfig.widthMultiplier),
                  height: 9 * SizeConfig.heightMultiplier,
                  child: Container(
                    width: ScreenUtil.getInstance().width.toDouble(),
                    margin: EdgeInsets.symmetric(
                        horizontal: 1.5 * SizeConfig.widthMultiplier),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(
                            .7 * SizeConfig.imageSizeMultiplier))),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                              height: 7 * SizeConfig.heightMultiplier,
                              color: MyColors.primaryColor,
                              child: Center(
                                child: Text(
                                  CommonUtils.translate(
                                      context, "select_by_service"),
                                  style: TextStyle(
                                      fontFamily: FontUtils.ceraProBold,
                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                      color: Colors.white),
                                ),
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            height: 7 * SizeConfig.heightMultiplier,
                            color: MyColors.grey,
                            child: DropdownButton<Service_of_request>(
                              onChanged: (data) {
                                setState(() {
                                  searchedDoctors.clear();
                                  selectedService = data;
                                  for (int i = 0; i < doctors.length; i++) {
                                    if (doctors[i].services != null &&
                                        doctors[i].services.length > 0) {
                                      for (int j = 0;
                                          j < doctors[i].services.length;
                                          j++) {
                                        if (doctors[i].services[j].id ==
                                            selectedService.id) {
                                          searchedDoctors.add(doctors[i]);
                                          break;
                                        }
                                      }
                                    }
                                  }
                                });
                              },
                              items:
                                  serviceItems.length > 0 ? serviceItems : null,
                              value: selectedService != null
                                  ? selectedService
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
                  )),
              Container(
                margin: EdgeInsets.only(
                    top: 22 * SizeConfig.heightMultiplier,
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
              Container(
                height: ScreenUtil.getInstance().height.toDouble(),
                width: ScreenUtil.getInstance().width.toDouble(),
                margin: EdgeInsets.only(
                    top: 27 * SizeConfig.heightMultiplier,
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
                                        child: RequestService(
                                          doctor: selectedService != null
                                              ? searchedDoctors[index]
                                              : doctors[index],
                                          serviceId: selectedService.id,
                                          method: selectedService.method,
                                        )));
                              },
                              child: SearchedDoctor(
                                doctor: selectedService != null
                                    ? searchedDoctors[index]
                                    : doctors[index],
                              ));
                        },
                        itemCount: selectedService != null
                            ? searchedDoctors.length
                            : doctors.length),
              )
            ],
          ),
        ));
  }
}
