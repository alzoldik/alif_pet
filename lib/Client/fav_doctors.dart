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
import 'package:alif_pet/models/fav_doc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class FavDoctors extends StatefulWidget {
  @override
  _FavDoctorsState createState() => _FavDoctorsState();
}

class _FavDoctorsState extends State<FavDoctors> {
  bool isLoading = true;
  bool isEnglish = true;
  List<FavDoc> doctors = [];
  @override
  void initState() {
    loadFavDoctors();
    super.initState();
  }

  void loadFavDoctors() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        ClientApis().getFavDoctors(isEnglish).then((result) {
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
          //  isInternet = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    isEnglish = CommonUtils.getLanguage(context) == "english";
    super.didChangeDependencies();
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
                          CommonUtils.translate(context, 'my_fav_doctors'),
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProMedium,
                              fontSize: 2.9 * SizeConfig.textMultiplier,
                              color: MyColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: ScreenUtil.getInstance().height.toDouble(),
                width: ScreenUtil.getInstance().width.toDouble(),
                margin: EdgeInsets.only(
                    top: 11.5 * SizeConfig.heightMultiplier,
                    right: 2 * SizeConfig.widthMultiplier,
                    left: 2 * SizeConfig.widthMultiplier,
                    bottom: 2 * SizeConfig.heightMultiplier),
                child: isLoading
                    ? MyLoader()
                    : doctors.length == 0
                        ? Center(
                            child: Text(
                              CommonUtils.translate(context, "no_doctor_found"),
                              style: TextStyle(
                                  fontFamily: FontUtils.ceraProMedium,
                                  fontSize: 2.9 * SizeConfig.textMultiplier,
                                  color: MyColors.primaryColor),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: ScreenUtil.getInstance()
                                            .width
                                            .toDouble() /
                                        (ScreenUtil.getInstance()
                                                .height
                                                .toDouble() -
                                            14 * SizeConfig.heightMultiplier),
                                    mainAxisSpacing:
                                        1 * SizeConfig.heightMultiplier),
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () async {
                                    bool toLoad = await Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child: DoctorProfileForClient(
                                                doctor:
                                                    doctors[index].doctor)));
                                    if (toLoad != null && toLoad) {
                                      loadFavDoctors();
                                    }
                                  },
                                  child: SearchedDoctor(
                                    doctor: doctors[index].doctor,
                                  ));
                            },
                            itemCount: doctors.length),
              )
            ],
          ),
        ));
  }
}
