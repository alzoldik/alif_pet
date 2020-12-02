import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/language/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class MyLoader extends StatefulWidget {
  final double containerSize;

  const MyLoader({Key key, this.containerSize}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return MyLoaderState();
  }
}

class MyLoaderState extends State<MyLoader>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInOut,
    );

    animation = Tween<double>(
      begin: 0,
      end: 4 * math.pi,
    ).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animController.forward();
        }
      });

    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.containerSize == null
            ? 22 * SizeConfig.imageSizeMultiplier
            : widget.containerSize,
        padding: EdgeInsets.all(2 * SizeConfig.imageSizeMultiplier),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
                Radius.circular(3 * SizeConfig.imageSizeMultiplier)),
            color: MyColors.primaryColor.withOpacity(.7),
            boxShadow: [
              BoxShadow(
                color: MyColors.primaryColor.withOpacity(.7),
                blurRadius: 3 * SizeConfig.imageSizeMultiplier,
              )
            ]),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: <Widget>[
              Transform.rotate(
                angle: animation.value,
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    ImageUtils.logo,
                    width: 11 * SizeConfig.imageSizeMultiplier,
                    height: 11 * SizeConfig.imageSizeMultiplier,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: .5 * SizeConfig.heightMultiplier),
                child: Text(
                  AppLocalizations.of(context).translate("loading") + "...",
                  style: TextStyle(
                      fontFamily: FontUtils.ceraProRegular,
                      fontSize: 1.9 * SizeConfig.textMultiplier,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}
