import 'package:alif_pet/Common/login.dart';
import 'package:alif_pet/Common/register.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/language/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'app_background.dart';

class RegisterAs extends StatelessWidget {
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
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(top: 7 * SizeConfig.heightMultiplier),
                    alignment: Alignment.topCenter,
                    child: Hero(
                      tag: "logo",
                      child: Material(
                        color: Colors.transparent,
                        child: Image.asset(
                          ImageUtils.logo,
                          width: 22 * SizeConfig.imageSizeMultiplier,
                          height: 22 * SizeConfig.imageSizeMultiplier,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin:
                        EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier),
                    child: Text(
                      AppLocalizations.of(context).translate("register"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProMedium,
                          fontSize: 3.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin:
                        EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier),
                    child: Text(
                      AppLocalizations.of(context).translate("register_as"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProLight,
                          fontSize: 2.6 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        right: 6.5 * SizeConfig.widthMultiplier,
                        left: 6.5 * SizeConfig.widthMultiplier,
                        top: 5 * SizeConfig.heightMultiplier),
                    height: 6 * SizeConfig.heightMultiplier,
                    width: double.infinity,
                    child: OutlineButton(
                      child: Text(
                          AppLocalizations.of(context).translate("doctor"),
                          style: TextStyle(
                              color: MyColors.primaryColor,
                              fontSize: 2.9 * SizeConfig.textMultiplier,
                              fontFamily: FontUtils.ceraProRegular)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: Register("doctor")));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(
                              2.8 * SizeConfig.imageSizeMultiplier))),
                      color: MyColors.primaryColor,
                      highlightElevation: 0.0,
                      highlightedBorderColor: MyColors.primaryColor,
                      borderSide: BorderSide(
                        color: MyColors.primaryColor,
                        style: BorderStyle.solid,
                        width: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        right: 6.5 * SizeConfig.widthMultiplier,
                        left: 6.5 * SizeConfig.widthMultiplier,
                        top: 5 * SizeConfig.heightMultiplier),
                    child: MaterialButton(
                      child: Text(
                          AppLocalizations.of(context).translate("client"),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 2.9 * SizeConfig.textMultiplier,
                              fontFamily: FontUtils.ceraProRegular)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: Register("client")));
                      },
                      height: 6 * SizeConfig.heightMultiplier,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(
                              2.8 * SizeConfig.imageSizeMultiplier))),
                      color: MyColors.primaryColor,
                      elevation: 0.0,
                      highlightElevation: 0.0,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin:
                        EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate("do_you_have_account"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProLight,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade, child: Login()));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context).translate("login"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProRegular,
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            color: MyColors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
