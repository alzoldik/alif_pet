import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/language/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NavBar extends StatefulWidget {
  final Function(int) onClick;
  final currentIndex;
  NavBar({Key key, this.onClick, this.currentIndex}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return NavbarState();
  }
}

class NavbarState extends State<NavBar> {
  int navIndex = 0;
  @override
  Widget build(BuildContext context) {
    navIndex = widget.currentIndex;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 8 * SizeConfig.heightMultiplier,
        width: ScreenUtil.getInstance().width.toDouble(),
        color: MyColors.primaryColor,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (navIndex != 0) {
                    setState(() {
                      navIndex = 0;
                      widget.onClick(navIndex);
                    });
                  }
                },
                child: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (navIndex == 0)
                        ? Icon(Icons.home,
                            color: MyColors.red,
                            size: 6.5 * SizeConfig.imageSizeMultiplier)
                        : Icon(Icons.home,
                            color: Colors.white,
                            size: 7 * SizeConfig.imageSizeMultiplier),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context).translate("home"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProRegular,
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                            color: (navIndex == 0)
                                ? MyColors.dark_red
                                : Colors.white),
                      ),
                    ),
                  ],
                )),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    if (navIndex != 1) {
                      setState(() {
                        navIndex = 1;
                        widget.onClick(navIndex);
                      });
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          child: (navIndex == 1)
                              ? Icon(Icons.contacts,
                                  color: MyColors.red,
                                  size: 7 * SizeConfig.imageSizeMultiplier)
                              : Icon(Icons.contacts,
                                  color: Colors.white,
                                  size: 6.5 * SizeConfig.imageSizeMultiplier)),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context).translate("contact"),
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProRegular,
                              fontSize: 1.5 * SizeConfig.textMultiplier,
                              color: (navIndex == 1)
                                  ? MyColors.dark_red
                                  : Colors.white),
                        ),
                      ),
                    ],
                  )),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (navIndex != 2) {
                    setState(() {
                      navIndex = 2;
                      widget.onClick(navIndex);
                    });
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: (navIndex == 2)
                            ? Icon(
                                Icons.account_balance_wallet,
                                color: MyColors.dark_red,
                                size: 7 * SizeConfig.imageSizeMultiplier,
                              )
                            : Icon(
                                Icons.account_balance_wallet,
                                color: Colors.white,
                                size: 6.5 * SizeConfig.imageSizeMultiplier,
                              )),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context).translate("wallet"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProRegular,
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                            color: (navIndex == 2)
                                ? MyColors.dark_red
                                : Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (navIndex != 3) {
                    setState(() {
                      navIndex = 3;
                      widget.onClick(navIndex);
                    });
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: (navIndex == 3)
                            ? Icon(
                                Icons.person,
                                color: MyColors.dark_red,
                                size: 6.5 * SizeConfig.imageSizeMultiplier,
                              )
                            : Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 7 * SizeConfig.imageSizeMultiplier,
                              )),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context).translate("profile"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProRegular,
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                            color: (navIndex == 3)
                                ? MyColors.dark_red
                                : Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
