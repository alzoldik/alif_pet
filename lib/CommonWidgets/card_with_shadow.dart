import 'package:alif_pet/Utils/screen_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardShadow extends StatelessWidget {
  final Widget childWidget;

  const CardShadow({Key key, this.childWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: childWidget,
      margin: EdgeInsets.symmetric(
          horizontal: 5 * SizeConfig.widthMultiplier,
          vertical: 1.5 * SizeConfig.heightMultiplier),
      decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
              Radius.circular(4.5 * SizeConfig.imageSizeMultiplier)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.5),
                blurRadius: 4 * SizeConfig.imageSizeMultiplier,
                spreadRadius: 0.0),
          ],
          color: Colors.white),
    );
  }
}
