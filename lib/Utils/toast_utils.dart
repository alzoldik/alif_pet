import 'dart:async';
import 'dart:math';


import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

import 'font_utils.dart';


class ToastUtils {
  static Timer toastTimer;
  static OverlayEntry _overlayEntry;

  static void showCustomToast(BuildContext context, String message,Color iconColor,Color backgroundColor) {

    if (toastTimer == null || !toastTimer.isActive) {
      _overlayEntry = createOverlayEntry(context, message, iconColor, backgroundColor);
      Overlay.of(context).insert(_overlayEntry);
      toastTimer = Timer(Duration(seconds: 2), () {
        if (_overlayEntry != null) {
          _overlayEntry.remove();
        }
      });
    }
  }

  static OverlayEntry createOverlayEntry(BuildContext context,
      String message,Color iconColor,Color toastColor) {

    return OverlayEntry(
        builder: (context) => Positioned(
          top: 8*SizeConfig.heightMultiplier,
          width: ScreenUtil.getInstance().width.toDouble()*.90,
          left: 5*SizeConfig.widthMultiplier,
          child: ToastMessageAnimation(Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
             constraints: BoxConstraints(
               minHeight:  8.5*SizeConfig.heightMultiplier,
               maxHeight:  8.5*SizeConfig.heightMultiplier,
             ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: toastColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.all(2.5*SizeConfig.imageSizeMultiplier),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 2.5*SizeConfig.textMultiplier,
                          fontFamily: FontUtils.ceraProMedium,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 1.5*SizeConfig.widthMultiplier),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Transform.rotate(
                        angle: pi/8,
                        child: ImageIcon(AssetImage(ImageUtils.logo),color: iconColor,size: 8.5*SizeConfig.imageSizeMultiplier,),
                      ) ,
                    ),
                  ),

                ],
              ),
            )
          )),
        ));
  }
}
class ToastMessageAnimation extends StatelessWidget {
  final Widget child;

  ToastMessageAnimation(this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("translateY")
          .add(
        Duration(milliseconds: 250),
        Tween(begin: -100.0, end: 0.0),
        curve: Curves.easeOut,
      )
          .add(Duration(seconds: 1, milliseconds: 250),
          Tween(begin: 0.0, end: 0.0))
          .add(Duration(milliseconds: 250),
          Tween(begin: 0.0, end: -100.0),
          curve: Curves.easeIn),
      Track("opacity")
          .add(Duration(milliseconds: 500),
          Tween(begin: 0.0, end: 1.0))
          .add(Duration(seconds: 1),
          Tween(begin: 1.0, end: 1.0))
          .add(Duration(milliseconds: 500),
          Tween(begin: 1.0, end: 0.0)),
    ]);

    return ControlledAnimation(
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(0, animation["translateY"]),
            child: child),
      ),
    );
  }
}