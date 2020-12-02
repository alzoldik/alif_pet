import 'package:alif_pet/Apis/common_apis.dart';
import 'package:alif_pet/Common/app_background.dart';
import 'package:alif_pet/Common/contact.dart';
import 'package:alif_pet/Common/splash_screen.dart';
import 'package:alif_pet/CommonWidgets/nav_bar.dart';
import 'package:alif_pet/Doctor/doctor_profile.dart';
import 'package:alif_pet/Doctor/doctor_wallet_balance.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/toast_utils.dart';
import 'package:alif_pet/Utils/userData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:page_transition/page_transition.dart';

import 'doctor_home.dart';

class DoctorMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DoctorMainState();
  }
}

class DoctorMainState extends State<DoctorMain> {
  bool isLoggingOut = false;
  int currentIndex = 0;
  double bottomMargin = 8 * SizeConfig.heightMultiplier;
  @override
  void initState() {
    // KeyboardVisibilityNotification().addNewListener(
    //   onChange: (bool visible) {
    //     if (visible) {
    //       bottomMargin = 0;
    //     } else {
    //       bottomMargin = 8 * SizeConfig.heightMultiplier;
    //     }
    //     setState(() {});
    //   },
    // );
    super.initState();
  }

  void logout() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        isLoggingOut = true;
        setState(() {});
        CommonApis()
            .logout(context, CommonUtils.getLanguage(context) == "english")
            .then((value) {
          if (value is String) {
            isLoggingOut = false;
            setState(() {});
            ToastUtils.showCustomToast(
                context, value, Colors.white, MyColors.primaryColor);
          } else if (value is bool && value) {
            var userData = UserData();
            userData.remove();
            isLoggingOut = false;
            setState(() {});
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(type: PageTransitionType.fade, child: Splash()),
                (Route<dynamic> route) => false);
          }
        });
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            children: <Widget>[
              AppBackground(),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  height: 7.5 * SizeConfig.heightMultiplier,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: CommonUtils.getLanguage(context) == "english"
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
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
                                left: 12 * SizeConfig.widthMultiplier)
                            : EdgeInsets.only(
                                right: 12 * SizeConfig.widthMultiplier),
                        child: Text(
                          currentIndex == 0
                              ? CommonUtils.translate(context, "welcome_doctor")
                              : currentIndex == 1
                                  ? CommonUtils.translate(context, "contact")
                                  : currentIndex == 2
                                      ? CommonUtils.translate(
                                          context, "wallet_balance")
                                      : CommonUtils.translate(
                                          context, "my_profile"),
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProBold,
                              fontSize: 2.9 * SizeConfig.textMultiplier,
                              color: MyColors.primaryColor),
                        ),
                      ),
                      GestureDetector(
                        onTap: isLoggingOut ? null : logout,
                        child: Container(
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          margin: CommonUtils.getLanguage(context) == "english"
                              ? EdgeInsets.only(
                                  left: 12 * SizeConfig.widthMultiplier)
                              : EdgeInsets.only(
                                  right: 12 * SizeConfig.widthMultiplier),
                          child: Text(
                            CommonUtils.translate(context, "logout"),
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProBold,
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              NavBar(
                onClick: onClick,
                currentIndex: currentIndex,
              ),
              getPages(currentIndex),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  Widget getPages(int position) {
    switch (position) {
      case 0:
        return DoctorHome(onWalletClick: onWalletClick);
      case 1:
        return Contact();
      case 2:
        return Container(
            margin: EdgeInsets.only(
                top: 11.5 * SizeConfig.heightMultiplier, bottom: bottomMargin),
            child: DoctorWalletBalance());
      case 3:
        return DoctorProfile();
    }
  }

  onClick(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void onWalletClick() {
    setState(() {
      currentIndex = 2;
    });
  }
}
