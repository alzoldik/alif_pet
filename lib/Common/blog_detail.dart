import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/models/blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_background.dart';

class BlogDetails extends StatelessWidget {
  final Blog blog;
  const BlogDetails({Key key, this.blog}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
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
                        blog.title == null ? "-" : blog.title,
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
              margin: EdgeInsets.only(top: 11.5 * SizeConfig.heightMultiplier),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Hero(
                      tag: blog.id,
                      child: Container(
                          width: ScreenUtil.getInstance().width.toDouble(),
                          child: Image.network(
                            ApiUtils.BaseApiUrlMain + blog.image,
                            fit: BoxFit.fitWidth,
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.5 * SizeConfig.widthMultiplier,
                          vertical: 1 * SizeConfig.heightMultiplier),
                      child: Text(
                        blog.body == null ? "-" : blog.body,
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProRegular,
                            fontWeight: FontWeight.bold,
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Center(
                        child: MaterialButton(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4 * SizeConfig.widthMultiplier),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: CommonUtils.getLanguage(context) ==
                                          "english"
                                      ? EdgeInsets.only(
                                          right: 2 * SizeConfig.widthMultiplier)
                                      : EdgeInsets.only(
                                          left: 2 * SizeConfig.widthMultiplier),
                                  child: RotationTransition(
                                      turns: CommonUtils.getLanguage(context) ==
                                              "english"
                                          ? AlwaysStoppedAnimation(180 / 360)
                                          : AlwaysStoppedAnimation(0),
                                      child: ImageIcon(
                                        AssetImage(ImageUtils.nextArrow),
                                        color: MyColors.red_icon,
                                      )),
                                ),
                                Text(CommonUtils.translate(context, "back"),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            2.3 * SizeConfig.textMultiplier,
                                        fontFamily: FontUtils.ceraProRegular,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          height: 5 * SizeConfig.heightMultiplier,
                          minWidth: 16 * SizeConfig.widthMultiplier,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  2.8 * SizeConfig.imageSizeMultiplier))),
                          color: MyColors.primaryColor,
                          elevation: 0.0,
                          highlightElevation: 0.0,
                        ),
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
