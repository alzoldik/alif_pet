import 'package:alif_pet/Services/user_service.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/userData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Apis/api_utils.dart';
import '../Client/client_main.dart';
import '../Doctor/doctor_main.dart';
import 'app_background.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<Splash> {
  void loadUserData() async {
    UserData userData = UserData();
    final prefs = await SharedPreferences.getInstance();
    await userData.readUserData(prefs);

    if (userData.getUserType == null) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(type: PageTransitionType.fade, child: Login()),
            (Route<dynamic> route) => false);
      }
    } else if (userData.getUserType == "client") {
      ApiUtils.headerWithToken
          .update("Authorization", (value) => userData.getToken);
      await Provider.of<UserService>(context, listen: false).getProfile();
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(type: PageTransitionType.fade, child: ClientMain()),
          (Route<dynamic> route) => false);
    } else {
      ApiUtils.headerWithToken
          .update("Authorization", (value) => userData.getToken);
      await Provider.of<UserService>(context, listen: false).getProfile();
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(type: PageTransitionType.fade, child: DoctorMain()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      loadUserData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            AppBackground(),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 12 * SizeConfig.heightMultiplier),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Material(
                      color: Colors.transparent,
                      child: Image.asset(
                        ImageUtils.logo,
                        width: 38 * SizeConfig.imageSizeMultiplier,
                        height: 38 * SizeConfig.imageSizeMultiplier,
                      )),
                ),
                Container(
                    alignment: Alignment.topCenter,
                    height: 32 * SizeConfig.imageSizeMultiplier,
                    width: 32 * SizeConfig.imageSizeMultiplier,
                    child: Image.asset(ImageUtils.appName))
              ]),
            )
          ],
        ),
      ),
    );
  }
}
