import 'dart:ui';

import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/language/app_localization.dart';
import 'package:alif_pet/models/service_of_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickServicesDialog extends StatefulWidget {
  final List<Service_of_request> services;
  final List selectedServices;
  final bool isEnglish;
  const PickServicesDialog(
      {Key key, this.services, this.selectedServices, this.isEnglish})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return PickServicesDialogState();
  }
}

class PickServicesDialogState extends State<PickServicesDialog> {
  List getServicesWidgets() {
    List widgets = [];
    widgets = widget.services
        .map((service) => Container(
              height: 5 * SizeConfig.heightMultiplier,
              margin: EdgeInsets.only(
                  top: 2 * SizeConfig.heightMultiplier,
                  left: 3 * SizeConfig.widthMultiplier,
                  right: 3 * SizeConfig.widthMultiplier),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(
                        widget.isEnglish ? service.name : service.nameAr,
                        style: TextStyle(
                            color: MyColors.primaryColor,
                            fontSize: 2.3 * SizeConfig.textMultiplier,
                            fontFamily: FontUtils.ceraProMedium)),
                  ),
                  Container(
                    child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: MyColors.primaryColor,
                        onChanged: (value) {
                          if (isSelected(service)) {
                            widget.selectedServices.remove(service.id);
                          } else {
                            widget.selectedServices.add(service.id);
                          }
                          setState(() {});
                        },
                        value: isSelected(service)),
                  )
                ],
              ),
            ))
        .toList();
    return widgets;
  }

  bool isSelected(Service_of_request service) {
    int isPresent = widget.selectedServices
        .singleWhere((id) => service.id == id, orElse: () => null);
    return isPresent == null ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context),
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.5),
                blurRadius: 2 * SizeConfig.imageSizeMultiplier)
          ]),
      margin: EdgeInsets.all(2.5 * SizeConfig.imageSizeMultiplier),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier),
            child: Text(CommonUtils.translate(context, "choose_your_services"),
                style: TextStyle(
                    color: MyColors.primaryColor,
                    fontSize: 2.3 * SizeConfig.textMultiplier,
                    fontFamily: FontUtils.ceraProBold)),
          ),
          SingleChildScrollView(
            child: Column(
              children: getServicesWidgets(),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: 3 * SizeConfig.heightMultiplier,
                horizontal: 15 * SizeConfig.widthMultiplier),
            child: MaterialButton(
              child: Text(AppLocalizations.of(context).translate("done"),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 2.3 * SizeConfig.textMultiplier,
                      fontFamily: FontUtils.ceraProRegular)),
              onPressed: () {
                Navigator.pop(context);
              },
              height: 5 * SizeConfig.heightMultiplier,
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(2.8 * SizeConfig.imageSizeMultiplier))),
              color: MyColors.primaryColor,
              elevation: 0.0,
              highlightElevation: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}
