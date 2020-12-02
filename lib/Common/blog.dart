import 'package:alif_pet/Apis/common_apis.dart';
import 'package:alif_pet/Common/blog_detail.dart';
import 'package:alif_pet/Common/blog_item.dart';
import 'package:alif_pet/Common/my_loader.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/models/blog.dart' as myBlog;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'app_background.dart';

class Blog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BlogState();
  }
}

class BlogState extends State<Blog> {
  bool isLoading = true;
  bool isInternet = true;
  List<myBlog.Blog> blogs = List();
  @override
  void initState() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        CommonApis().getBlogs().then((result) {
          if (result is String) {
            //ToastUtils.showCustomToast(context, result, Colors.white , MyColors.primaryColor);
          } else {
            blogs = result;
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
    super.initState();
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
                        CommonUtils.translate(context, "blog"),
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
              margin: EdgeInsets.only(
                  top: 10 * SizeConfig.heightMultiplier,
                  right: 4.5 * SizeConfig.widthMultiplier,
                  left: 4.5 * SizeConfig.widthMultiplier),
              child: isLoading
                  ? MyLoader()
                  : GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: CommonUtils.getLanguage(
                                          context) ==
                                      "english"
                                  ? ((ScreenUtil.getInstance()
                                          .width
                                          .toDouble()) /
                                      (ScreenUtil.getInstance()
                                              .height
                                              .toDouble() -
                                          8.5 * SizeConfig.heightMultiplier))
                                  : ((ScreenUtil.getInstance()
                                          .width
                                          .toDouble()) /
                                      (ScreenUtil.getInstance()
                                              .height
                                              .toDouble() -
                                          8 * SizeConfig.heightMultiplier))),
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: BlogDetails(
                                        blog: blogs[index],
                                      )));
                            },
                            child: BlogItem(blog: blogs[index]));
                      },
                      itemCount: blogs.length),
            )
          ],
        ),
      ),
    );
  }
}
