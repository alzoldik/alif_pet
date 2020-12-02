import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 11.5 * SizeConfig.heightMultiplier,
        bottom: 10.5 * SizeConfig.heightMultiplier,
        right: 2.5 * SizeConfig.widthMultiplier,
        left: 2.5 * SizeConfig.widthMultiplier,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil.getInstance().width * .40,
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(left: 3 * SizeConfig.widthMultiplier)
                        : EdgeInsets.only(
                            right: 3 * SizeConfig.widthMultiplier),
                    child: Text(
                      CommonUtils.translate(context, "mobile_number") + ":",
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProBold,
                          fontSize: 2.4 * SizeConfig.textMultiplier,
                          decoration: TextDecoration.underline,
                          color: MyColors.primaryColor),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        "012345678",
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProMedium,
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier),
              child: Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil.getInstance().width * .40,
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(left: 3 * SizeConfig.widthMultiplier)
                        : EdgeInsets.only(
                            right: 3 * SizeConfig.widthMultiplier),
                    child: Text(
                      CommonUtils.translate(context, "address") + ":",
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProBold,
                          fontSize: 2.4 * SizeConfig.textMultiplier,
                          decoration: TextDecoration.underline,
                          color: MyColors.primaryColor),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        "123 Street abcabc",
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProMedium,
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            decoration: TextDecoration.underline,
                            color: MyColors.primaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: ScreenUtil.getInstance().width.toDouble(),
              margin: CommonUtils.getLanguage(context) == "english"
                  ? EdgeInsets.only(
                      left: 3 * SizeConfig.widthMultiplier,
                      top: 7 * SizeConfig.heightMultiplier)
                  : EdgeInsets.only(
                      right: 3 * SizeConfig.widthMultiplier,
                      top: 7 * SizeConfig.heightMultiplier),
              child: Text(
                CommonUtils.translate(context, "social_media_accounts"),
                style: TextStyle(
                    fontFamily: FontUtils.ceraProBold,
                    fontSize: 2.8 * SizeConfig.textMultiplier,
                    decoration: TextDecoration.underline,
                    color: MyColors.primaryColor),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 2.5 * SizeConfig.heightMultiplier,
                  right: 3 * SizeConfig.widthMultiplier,
                  left: 3 * SizeConfig.widthMultiplier),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      ImageUtils.facebookIcon,
                      width: 10.5 * SizeConfig.imageSizeMultiplier,
                      height: 10.5 * SizeConfig.imageSizeMultiplier,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      ImageUtils.twitterIcon,
                      width: 10.5 * SizeConfig.imageSizeMultiplier,
                      height: 10.5 * SizeConfig.imageSizeMultiplier,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      ImageUtils.snapchatIcon,
                      width: 10.5 * SizeConfig.imageSizeMultiplier,
                      height: 10.5 * SizeConfig.imageSizeMultiplier,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      ImageUtils.instagramIcon,
                      width: 10.5 * SizeConfig.imageSizeMultiplier,
                      height: 10.5 * SizeConfig.imageSizeMultiplier,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 4.5 * SizeConfig.heightMultiplier,
                  right: 7.5 * SizeConfig.widthMultiplier,
                  left: 7.5 * SizeConfig.widthMultiplier),
              height: 22 * SizeConfig.heightMultiplier,
              width: ScreenUtil.getInstance().width.toDouble(),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                    Radius.circular(3 * SizeConfig.imageSizeMultiplier)),
                border: Border.all(color: Colors.red, width: .7),
              ),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textAlign: TextAlign.start,
                autofocus: false,
                style: TextStyle(
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  fontFamily: FontUtils.ceraProMedium,
                  color: MyColors.primaryColor,
                ),
                decoration: InputDecoration(
                  hintText:
                      CommonUtils.translate(context, "write_your_message_here"),
                  hintStyle: TextStyle(
                    fontSize: 2.2 * SizeConfig.textMultiplier,
                    fontFamily: FontUtils.ceraProMedium,
                    color: MyColors.primaryColor,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 1 * SizeConfig.heightMultiplier,
                      horizontal: 1 * SizeConfig.widthMultiplier),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4.5 * SizeConfig.heightMultiplier),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(
                          right: CommonUtils.getLanguage(context) != "english"
                              ? 6.5 * SizeConfig.widthMultiplier
                              : 3.5 * SizeConfig.widthMultiplier,
                          left: CommonUtils.getLanguage(context) != "english"
                              ? 3.5 * SizeConfig.widthMultiplier
                              : 6.5 * SizeConfig.widthMultiplier),
                      child: MaterialButton(
                        child: Text(CommonUtils.translate(context, "save"),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 2.3 * SizeConfig.textMultiplier,
                                fontFamily: FontUtils.ceraProMedium)),
                        onPressed: () {
                          // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MobileVerification()));
                        },
                        height: 5 * SizeConfig.heightMultiplier,
                        minWidth: 22 * SizeConfig.widthMultiplier,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                2.8 * SizeConfig.imageSizeMultiplier))),
                        color: MyColors.primaryColor,
                        elevation: 0.0,
                        highlightElevation: 0.0,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(
                          right: CommonUtils.getLanguage(context) == "english"
                              ? 6.5 * SizeConfig.widthMultiplier
                              : 3.5 * SizeConfig.widthMultiplier,
                          left: CommonUtils.getLanguage(context) == "english"
                              ? 3.5 * SizeConfig.widthMultiplier
                              : 6.5 * SizeConfig.widthMultiplier),
                      child: MaterialButton(
                        child: Text(CommonUtils.translate(context, "cancel"),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 2.3 * SizeConfig.textMultiplier,
                                fontFamily: FontUtils.ceraProMedium)),
                        onPressed: () {
                          // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MobileVerification()));
                        },
                        height: 5 * SizeConfig.heightMultiplier,
                        minWidth: 22 * SizeConfig.widthMultiplier,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                2.8 * SizeConfig.imageSizeMultiplier))),
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
    );
  }
}
