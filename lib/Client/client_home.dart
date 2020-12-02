import 'package:alif_pet/Client/browse_doctors.dart';
import 'package:alif_pet/Client/client_requests.dart';
import 'package:alif_pet/Client/fav_doctors.dart';
import 'package:alif_pet/Client/request_service0.dart';
import 'package:alif_pet/Common/about.dart';
import 'package:alif_pet/Common/blog.dart';
import 'package:alif_pet/CommonWidgets/card_with_shadow.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/language/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ClientHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClientHomeState();
  }
}

class ClientHomeState extends State<ClientHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 11.5 * SizeConfig.heightMultiplier,
        bottom: 10.5 * SizeConfig.heightMultiplier,
        right: 2.5 * SizeConfig.widthMultiplier,
        left: 2.5 * SizeConfig.widthMultiplier,
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: BrowseDoctors()));
                      },
                      child: CardShadow(
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage(ImageUtils.doctorIcon),
                              width: 24 * SizeConfig.imageSizeMultiplier,
                              height: 24 * SizeConfig.imageSizeMultiplier,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 2 * SizeConfig.heightMultiplier),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("browse_doctors"),
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProRegular,
                                    fontSize: 1.7 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: FavDoctors()));
                      },
                      child: CardShadow(
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage(ImageUtils.starsIcon),
                              width: 24 * SizeConfig.imageSizeMultiplier,
                              height: 24 * SizeConfig.imageSizeMultiplier,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 2 * SizeConfig.heightMultiplier),
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("my_fav_doctors"),
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProRegular,
                                    fontSize: 1.7 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: RequestService0()));
                      },
                      child: CardShadow(
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage(ImageUtils.requestIcon),
                              width: 24 * SizeConfig.imageSizeMultiplier,
                              height: 24 * SizeConfig.imageSizeMultiplier,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 2 * SizeConfig.heightMultiplier),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("request_service"),
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProRegular,
                                    fontSize: 1.7 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: ClientRequests()));
                      },
                      child: CardShadow(
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage(ImageUtils.requestsIcon),
                              width: 24 * SizeConfig.imageSizeMultiplier,
                              height: 24 * SizeConfig.imageSizeMultiplier,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 2 * SizeConfig.heightMultiplier),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("requests"),
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProRegular,
                                    fontSize: 1.7 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade, child: Blog()));
                      },
                      child: CardShadow(
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage(ImageUtils.blogIcon),
                              width: 24 * SizeConfig.imageSizeMultiplier,
                              height: 24 * SizeConfig.imageSizeMultiplier,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 2 * SizeConfig.heightMultiplier),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context).translate("blog"),
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProRegular,
                                    fontSize: 1.7 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade, child: About()));
                      },
                      child: CardShadow(
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage(ImageUtils.aboutIcon),
                              width: 24 * SizeConfig.imageSizeMultiplier,
                              height: 24 * SizeConfig.imageSizeMultiplier,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 2 * SizeConfig.heightMultiplier),
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                AppLocalizations.of(context).translate("about"),
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProRegular,
                                    fontSize: 1.7 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
