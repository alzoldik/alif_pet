import 'package:alif_pet/Common/about_the_app.dart';
import 'package:alif_pet/Common/privacy_policy.dart';
import 'package:alif_pet/Common/terms_of_use.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'app_background.dart';

class About extends StatelessWidget {
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
                        CommonUtils.translate(context, "about_app"),
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
              margin: CommonUtils.getLanguage(context) == "english"
                  ? EdgeInsets.only(
                      left: 3 * SizeConfig.widthMultiplier,
                      top: 12 * SizeConfig.heightMultiplier)
                  : EdgeInsets.only(
                      right: 3 * SizeConfig.widthMultiplier,
                      top: 12 * SizeConfig.heightMultiplier),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: AboutTheApp()));
                    },
                    child: Container(
                      child: Text(
                        CommonUtils.translate(context, "about_the_app"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProMedium,
                            decoration: TextDecoration.underline,
                            fontSize: 2.6 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: PrivacyPolicy()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 3.5 * SizeConfig.heightMultiplier),
                      child: Text(
                        CommonUtils.translate(context, "privacy_policy"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProMedium,
                            decoration: TextDecoration.underline,
                            fontSize: 2.6 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: TermsOfUse()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 3.5 * SizeConfig.heightMultiplier),
                      child: Text(
                        CommonUtils.translate(context, "terms_of_use"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProMedium,
                            decoration: TextDecoration.underline,
                            fontSize: 2.6 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
