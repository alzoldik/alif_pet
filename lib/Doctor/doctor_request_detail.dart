import 'dart:async';

import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Apis/doctor_apis.dart';
import 'package:alif_pet/Common/app_background.dart';
import 'package:alif_pet/Common/chat_screen.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/Utils/string_utils.dart';
import 'package:alif_pet/Utils/toast_utils.dart';
import 'package:alif_pet/Utils/userData.dart';
import 'package:alif_pet/language/app_localization.dart';
import 'package:alif_pet/models/request.dart';
import 'package:alif_pet/models/success.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DoctorRequestDetail extends StatefulWidget {
  final Request request;

  const DoctorRequestDetail({Key key, this.request}) : super(key: key);

  @override
  _DoctorRequestDetailState createState() => _DoctorRequestDetailState();
}

class _DoctorRequestDetailState extends State<DoctorRequestDetail> {
  bool isEnglish, isClicked = false;
  int status;
  @override
  void didChangeDependencies() {
    isEnglish = CommonUtils.getLanguage(context) == "english";
    super.didChangeDependencies();
  }

  @override
  void initState() {
    status = widget.request.status;
    super.initState();
  }

  void acceptRequest() {
    CommonUtils.checkInternet().then((value) async {
      if (value) {
        isClicked = true;
        setState(() {});
        DoctorApis().acceptRequest(
            {"service_request_id": widget.request.id}, isEnglish).then((value) {
          if (value is String) {
            ToastUtils.showCustomToast(
                context, value, Colors.white, MyColors.primaryColor);
            isClicked = false;
            if (mounted) {
              setState(() {});
            }
          } else {
            isClicked = false;
            Success response = value;
            ToastUtils.showCustomToast(
                context,
                isEnglish ? response.en : response.ar,
                Colors.white,
                MyColors.primaryColor);
            setState(() {});
            Navigator.of(context).pop(true);
          }
        });
      } else {
        ToastUtils.showCustomToast(context, StringUtils.noInternet,
            Colors.white, MyColors.primaryColor);
      }
    });
  }

  void cancelRequest() {
    CommonUtils.checkInternet().then((value) async {
      if (value) {
        isClicked = true;
        setState(() {});
        DoctorApis().cancelRequest(
            {"service_request_id": widget.request.id}, isEnglish).then((value) {
          if (value is String) {
            ToastUtils.showCustomToast(
                context, value, Colors.white, MyColors.primaryColor);
            isClicked = false;
            if (mounted) {
              setState(() {});
            }
          } else {
            isClicked = false;
            Success response = value;
            ToastUtils.showCustomToast(
                context,
                isEnglish ? response.en : response.ar,
                Colors.white,
                MyColors.primaryColor);
            setState(() {});
            Navigator.of(context).pop(true);
          }
        });
      } else {
        ToastUtils.showCustomToast(context, StringUtils.noInternet,
            Colors.white, MyColors.primaryColor);
      }
    });
  }

  void endRequest() {
    CommonUtils.checkInternet().then((value) async {
      if (value) {
        isClicked = true;
        setState(() {});
        DoctorApis().endRequest(
            {"service_request_id": widget.request.id}, isEnglish).then((value) {
          if (value is String) {
            ToastUtils.showCustomToast(
                context, value, Colors.white, MyColors.primaryColor);
            isClicked = false;
            if (mounted) {
              setState(() {});
            }
          } else {
            isClicked = false;
            Success response = value;
            ToastUtils.showCustomToast(
                context,
                isEnglish ? response.en : response.ar,
                Colors.white,
                MyColors.primaryColor);
            setState(() {});
            Navigator.of(context).pop(true);
          }
        });
      } else {
        ToastUtils.showCustomToast(context, StringUtils.noInternet,
            Colors.white, MyColors.primaryColor);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserData>(context);
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
                          isClicked
                              ? Navigator.of(context).pop(true)
                              : Navigator.pop(context);
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
                        CommonUtils.translate(context, "my_requests"),
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
                  top: 12 * SizeConfig.heightMultiplier,
                  bottom: 5 * SizeConfig.heightMultiplier),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 9 * SizeConfig.widthMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              top: 2 * SizeConfig.heightMultiplier)
                          : EdgeInsets.only(
                              right: 9 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier,
                              top: 2 * SizeConfig.heightMultiplier),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Hero(
                                tag: widget.request.id,
                                child: Container(
                                  height: 9 * SizeConfig.imageSizeMultiplier,
                                  width: 9 * SizeConfig.imageSizeMultiplier,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(.5),
                                            blurRadius: 2 *
                                                SizeConfig.imageSizeMultiplier)
                                      ]),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    child: widget.request.client.photo == null
                                        ? Image.asset(
                                            ImageUtils.doctorIcon,
                                            fit: BoxFit.contain,
                                          )
                                        : Image.network(
                                            ApiUtils.BaseApiUrlMain +
                                                widget.request.client.photo,
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? EdgeInsets.only(
                                        left: 2 * SizeConfig.widthMultiplier)
                                    : EdgeInsets.only(
                                        right: 2 * SizeConfig.widthMultiplier),
                                child: Text(
                                  widget.request.client.name,
                                  style: TextStyle(
                                      fontFamily: FontUtils.ceraProBold,
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      color: MyColors.primaryColor),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin:
                                CommonUtils.getLanguage(context) == "english"
                                    ? EdgeInsets.only(
                                        right: 2 * SizeConfig.widthMultiplier)
                                    : EdgeInsets.only(
                                        left: 2 * SizeConfig.widthMultiplier),
                            child: Text(
                              CommonUtils.translate(context, "request_no") +
                                  " ${widget.request.id}",
                              style: TextStyle(
                                  fontFamily: FontUtils.ceraProMedium,
                                  decoration: TextDecoration.underline,
                                  fontSize: 1.7 * SizeConfig.textMultiplier,
                                  color: MyColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: ScreenUtil.getInstance().width.toDouble(),
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 20 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 20 * SizeConfig.widthMultiplier),
                      child: Text(
                        DateFormat("EEE,MMM-dd")
                            .format(DateTime.parse(widget.request.date)),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProRegular,
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                      height: .3,
                      width: ScreenUtil.getInstance().width.toDouble(),
                      color: MyColors.primaryColor,
                    ),
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 7 * SizeConfig.widthMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              top: 3 * SizeConfig.heightMultiplier)
                          : EdgeInsets.only(
                              right: 7 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier,
                              top: 3 * SizeConfig.heightMultiplier),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 2 * SizeConfig.widthMultiplier),
                              child: Text(
                                CommonUtils.translate(context, "status"),
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProBold,
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 5 * SizeConfig.imageSizeMultiplier,
                                    height: 5 * SizeConfig.imageSizeMultiplier,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: status == 1
                                          ? Colors.deepOrange
                                          : status == 2
                                              ? MyColors.yellow
                                              : status == 3
                                                  ? MyColors.green
                                                  : MyColors.red_icon,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(.5 *
                                              SizeConfig.imageSizeMultiplier)),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 1),
                                            color: Colors.black.withOpacity(.2),
                                            blurRadius: 2 *
                                                SizeConfig.imageSizeMultiplier)
                                      ],
                                    ),
                                    child: Icon(
                                      status == 1
                                          ? Icons.add
                                          : status == 2
                                              ? Icons.arrow_forward
                                              : status == 3
                                                  ? Icons.done
                                                  : Icons.clear,
                                      color: Colors.white,
                                      size: 5 * SizeConfig.imageSizeMultiplier,
                                    )),
                                Tooltip(
                                  preferBelow: false,
                                  message: isEnglish
                                      ? widget.request.statusName['en']
                                      : widget.request.statusName['ar'],
                                  textStyle: TextStyle(
                                      fontFamily: FontUtils.ceraProRegular,
                                      fontSize: 2.1 * SizeConfig.textMultiplier,
                                      color: Colors.white),
                                  child: Container(
                                    width: 25 * SizeConfig.widthMultiplier,
                                    margin: CommonUtils.getLanguage(context) ==
                                            "english"
                                        ? EdgeInsets.only(
                                            left:
                                                3 * SizeConfig.widthMultiplier)
                                        : EdgeInsets.only(
                                            right:
                                                3 * SizeConfig.widthMultiplier),
                                    child: Text(
                                      isEnglish
                                          ? widget.request.statusName['en']
                                          : widget.request.statusName['ar'],
                                      style: TextStyle(
                                          fontFamily: FontUtils.ceraProMedium,
                                          fontSize:
                                              2.5 * SizeConfig.textMultiplier,
                                          color: MyColors.primaryColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier),
                      height: .3,
                      width: ScreenUtil.getInstance().width.toDouble(),
                      color: MyColors.primaryColor,
                    ),
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 7 * SizeConfig.widthMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              top: 3 * SizeConfig.heightMultiplier)
                          : EdgeInsets.only(
                              right: 7 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier,
                              top: 3 * SizeConfig.heightMultiplier),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: Container(
                              width: 25 * SizeConfig.widthMultiplier,
                              margin: CommonUtils.getLanguage(context) ==
                                      "english"
                                  ? EdgeInsets.only(
                                      left: 2 * SizeConfig.widthMultiplier)
                                  : EdgeInsets.only(
                                      right: 2 * SizeConfig.widthMultiplier),
                              child: Text(
                                CommonUtils.translate(context, "price"),
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProBold,
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              margin: CommonUtils.getLanguage(context) ==
                                      "english"
                                  ? EdgeInsets.only(
                                      left: 7.5 * SizeConfig.widthMultiplier)
                                  : EdgeInsets.only(
                                      right: 7.5 * SizeConfig.widthMultiplier),
                              child: Text(
                                widget.request.cost.toString() +
                                    " ${isEnglish ? widget.request.currency['en'] : widget.request.currency['ar']}",
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProMedium,
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                    color: MyColors.dark_blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier),
                      height: .3,
                      width: ScreenUtil.getInstance().width.toDouble(),
                      color: MyColors.primaryColor,
                    ),
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 7 * SizeConfig.widthMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              top: 3 * SizeConfig.heightMultiplier)
                          : EdgeInsets.only(
                              right: 7 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier,
                              top: 3 * SizeConfig.heightMultiplier),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: Container(
                              width: 25 * SizeConfig.widthMultiplier,
                              margin: CommonUtils.getLanguage(context) ==
                                      "english"
                                  ? EdgeInsets.only(
                                      left: 2 * SizeConfig.widthMultiplier)
                                  : EdgeInsets.only(
                                      right: 2 * SizeConfig.widthMultiplier),
                              child: Text(
                                CommonUtils.translate(context, "service"),
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProBold,
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              margin: CommonUtils.getLanguage(context) ==
                                      "english"
                                  ? EdgeInsets.only(
                                      left: 7.5 * SizeConfig.widthMultiplier)
                                  : EdgeInsets.only(
                                      right: 7.5 * SizeConfig.widthMultiplier),
                              child: Text(
                                isEnglish
                                    ? widget.request.service.name
                                    : widget.request.service.nameAr,
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProMedium,
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier),
                      height: .3,
                      width: ScreenUtil.getInstance().width.toDouble(),
                      color: MyColors.primaryColor,
                    ),
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 7 * SizeConfig.widthMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              top: 3 * SizeConfig.heightMultiplier)
                          : EdgeInsets.only(
                              right: 7 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier,
                              top: 3 * SizeConfig.heightMultiplier),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            child: Container(
                              width: 27 * SizeConfig.widthMultiplier,
                              margin: EdgeInsets.only(
                                  left: 2 * SizeConfig.widthMultiplier),
                              child: Text(
                                CommonUtils.translate(context, "description"),
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProBold,
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: CommonUtils.getLanguage(context) ==
                                      "english"
                                  ? EdgeInsets.only(
                                      left: 7.5 * SizeConfig.widthMultiplier,
                                      right: 2.5 * SizeConfig.widthMultiplier)
                                  : EdgeInsets.only(
                                      right: 7.5 * SizeConfig.widthMultiplier,
                                      left: 2.5 * SizeConfig.widthMultiplier),
                              child: Text(
                                widget.request.description,
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProMedium,
                                    fontSize: 1.7 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            status == 1
                ? Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                right: CommonUtils.getLanguage(context) !=
                                        "english"
                                    ? 6.5 * SizeConfig.widthMultiplier
                                    : 3.5 * SizeConfig.widthMultiplier,
                                left: CommonUtils.getLanguage(context) !=
                                        "english"
                                    ? 3.5 * SizeConfig.widthMultiplier
                                    : 6.5 * SizeConfig.widthMultiplier),
                            child: MaterialButton(
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate("accept"),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 2.3 * SizeConfig.textMultiplier,
                                      fontFamily: FontUtils.ceraProRegular)),
                              onPressed: isClicked ? null : acceptRequest,
                              height: 5 * SizeConfig.heightMultiplier,
                              minWidth: double.infinity,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2.8 *
                                          SizeConfig.imageSizeMultiplier))),
                              color: MyColors.primaryColor,
                              elevation: 0.0,
                              highlightElevation: 0.0,
                              disabledColor:
                                  MyColors.primaryColor.withOpacity(.8),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                right: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? 6.5 * SizeConfig.widthMultiplier
                                    : 3.5 * SizeConfig.widthMultiplier,
                                left: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? 3.5 * SizeConfig.widthMultiplier
                                    : 6.5 * SizeConfig.widthMultiplier),
                            child: MaterialButton(
                              onPressed: isClicked ? null : cancelRequest,
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate("cancel"),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 2.3 * SizeConfig.textMultiplier,
                                      fontFamily: FontUtils.ceraProRegular)),
                              height: 5 * SizeConfig.heightMultiplier,
                              minWidth: double.infinity,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2.8 *
                                          SizeConfig.imageSizeMultiplier))),
                              color: MyColors.primaryColor,
                              elevation: 0.0,
                              highlightElevation: 0.0,
                              disabledColor:
                                  MyColors.primaryColor.withOpacity(.8),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : status == 2
                    ? Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: CommonUtils.getLanguage(context) !=
                                            "english"
                                        ? 6.5 * SizeConfig.widthMultiplier
                                        : 3.5 * SizeConfig.widthMultiplier,
                                    left: CommonUtils.getLanguage(context) !=
                                            "english"
                                        ? 3.5 * SizeConfig.widthMultiplier
                                        : 6.5 * SizeConfig.widthMultiplier),
                                child: MaterialButton(
                                  child: Text(widget.request.service.method,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                          fontFamily:
                                              FontUtils.ceraProRegular)),
                                  onPressed: isClicked
                                      ? null
                                      : () async {
                                          final result = await Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: ChatScreen(
                                                    serviceId:
                                                        widget.request.id,
                                                    userData: userData,
                                                    userToSend: userData
                                                                .getUserType ==
                                                            "client"
                                                        ? widget.request.doctor
                                                        : widget.request.client,
                                                  )));
                                          if (result) {
                                            Timer(Duration(milliseconds: 150),
                                                () {
                                              FlutterStatusbarcolor
                                                  .setStatusBarColor(
                                                      Colors.white);
                                              FlutterStatusbarcolor
                                                  .setStatusBarWhiteForeground(
                                                      false);
                                            });
                                          }
                                        },
                                  height: 5 * SizeConfig.heightMultiplier,
                                  minWidth: double.infinity,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.8 *
                                              SizeConfig.imageSizeMultiplier))),
                                  color: MyColors.primaryColor,
                                  elevation: 0.0,
                                  highlightElevation: 0.0,
                                  disabledColor:
                                      MyColors.primaryColor.withOpacity(.8),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: CommonUtils.getLanguage(context) ==
                                            "english"
                                        ? 6.5 * SizeConfig.widthMultiplier
                                        : 3.5 * SizeConfig.widthMultiplier,
                                    left: CommonUtils.getLanguage(context) ==
                                            "english"
                                        ? 3.5 * SizeConfig.widthMultiplier
                                        : 6.5 * SizeConfig.widthMultiplier),
                                child: MaterialButton(
                                  onPressed: isClicked ? null : cancelRequest,
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate("end"),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                          fontFamily:
                                              FontUtils.ceraProRegular)),
                                  height: 5 * SizeConfig.heightMultiplier,
                                  minWidth: double.infinity,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.8 *
                                              SizeConfig.imageSizeMultiplier))),
                                  color: MyColors.primaryColor,
                                  elevation: 0.0,
                                  highlightElevation: 0.0,
                                  disabledColor:
                                      MyColors.primaryColor.withOpacity(.8),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container()
          ],
        ),
      ),
    );
  }
}
