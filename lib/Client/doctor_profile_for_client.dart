import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Apis/client_apis.dart';
import 'package:alif_pet/Client/client_review_item.dart';
import 'package:alif_pet/Client/request_service.dart';
import 'package:alif_pet/Common/app_background.dart';
import 'package:alif_pet/models/certificate.dart';
import 'package:alif_pet/models/profile.dart';
import 'package:alif_pet/models/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/language/app_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';

class DoctorProfileForClient extends StatefulWidget {
  final Profile doctor;
  const DoctorProfileForClient({Key key, this.doctor}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return DoctorProfileForClientState();
  }
}

class DoctorProfileForClientState extends State<DoctorProfileForClient> {
  String workDays = "";
  //String services="";
  String methodsNames = "";
  List<InlineSpan> services = List();
  bool isEnglish;
  List methodsList;
  dynamic workdaysMap;
  bool isfavting = false;
  bool isFav = false;
  void getWorkDays() {
    if (workdaysMap.length > 0) {
      for (int i = 1; i < 7; i++) {
        if (workdaysMap.containsKey(i.toString())) {
          workDays = isEnglish
              ? workDays + workdaysMap[i.toString()]['en'] + "/"
              : workDays + workdaysMap[i.toString()]['ar'] + "/";
        }
      }
      workDays = workDays.substring(0, workDays.length - 1);
    }
  }

  void doFav() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        isfavting = true;
        setState(() {});
        ClientApis().favADoctor(
            {"doctor_id": "${widget.doctor.id}"}, isEnglish).then((value) {
          if (value is bool && value) {
            isfavting = false;
            setState(() {});
          } else {
            isfavting = false;
            setState(() {});
          }
        });
      }
    });
  }

  void doUnFav() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        isfavting = true;
        setState(() {});
        ClientApis().unFavADoctor(
            {"doctor_id": "${widget.doctor.id}"}, isEnglish).then((value) {
          if (value is bool && value) {
            isfavting = false;
            setState(() {});
          } else {
            isfavting = false;
            setState(() {});
          }
        });
      }
    });
  }

  void getServices() {
    if (widget.doctor.services != null && widget.doctor.services.length > 0) {
      for (int i = 0; i < widget.doctor.services.length; i++) {
        //services = services+widget.doctor.services[i].service.name+", ";
        services.add(TextSpan(
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: RequestService(
                          doctor: widget.doctor,
                          serviceId: widget.doctor.services[i].serviceId,
                          method: widget.doctor.services[i].service.method)));
            },
          text: isEnglish
              ? CommonUtils.capitalize(widget.doctor.services[i].service.name) +
                  (i == widget.doctor.services.length - 1 ? "" : ", ")
              : CommonUtils.capitalize(
                      widget.doctor.services[i].service.nameAr) +
                  (i == widget.doctor.services.length - 1 ? "" : ", "),
          style: TextStyle(
            fontFamily: FontUtils.ceraProBold,
            fontSize: 1.8 * SizeConfig.textMultiplier,
            color: MyColors.primaryColor,
          ),
        ));
        if (!methodsNames.contains(
            CommonUtils.capitalize(widget.doctor.services[i].service.method))) {
          methodsNames = methodsNames +
              CommonUtils.capitalize(widget.doctor.services[i].service.method) +
              "/";
        }
      }
      methodsNames = methodsNames.substring(0, methodsNames.length - 1);
    }
  }

  @override
  void initState() {
    workdaysMap = widget.doctor.workDaysNames;
    isFav = widget.doctor.favorite;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    isEnglish = CommonUtils.getLanguage(context) == "english";
    getWorkDays();
    getServices();
    super.didChangeDependencies();
  }

  // ignore: missing_return
  Future<bool> goBack() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: goBack,
      child: SafeArea(
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
                    margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    height: 7.5 * SizeConfig.heightMultiplier,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            icon: Icon(
                              Icons.keyboard_backspace,
                              color: MyColors.primaryColor,
                            ),
                          ),
                        ),
                        Container(
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
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
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          margin: CommonUtils.getLanguage(context) == "english"
                              ? EdgeInsets.only(
                                  left: 25 * SizeConfig.widthMultiplier)
                              : EdgeInsets.only(
                                  right: 25 * SizeConfig.widthMultiplier),
                          child: Text(
                            widget.doctor.name == null
                                ? "-"
                                : widget.doctor.name,
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProMedium,
                                fontSize: 2.9 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor),
                          ),
                        ),
                        Align(
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.notifications,
                                  color: MyColors.primaryColor)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: 11.5 * SizeConfig.heightMultiplier),
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 24 * SizeConfig.imageSizeMultiplier,
                                  width: 24 * SizeConfig.imageSizeMultiplier,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Hero(
                                          tag: widget.doctor.id,
                                          child: Container(
                                            height: 23 *
                                                SizeConfig.imageSizeMultiplier,
                                            width: 23 *
                                                SizeConfig.imageSizeMultiplier,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(.5),
                                                      blurRadius: 3.5 *
                                                          SizeConfig
                                                              .imageSizeMultiplier,
                                                      spreadRadius: 0.0,
                                                      offset: Offset(2, 6.0)),
                                                ],
                                                color: Colors.white),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                              child: widget.doctor.photo == null
                                                  ? Image.asset(
                                                      ImageUtils.doctorIcon,
                                                      fit: BoxFit.contain,
                                                    )
                                                  : Image.network(
                                                      ApiUtils.BaseApiUrlMain +
                                                          widget.doctor.photo,
                                                      fit: BoxFit.contain,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: isfavting
                                              ? null
                                              : () {
                                                  if (isFav) {
                                                    doUnFav();
                                                  } else {
                                                    doFav();
                                                  }
                                                  isFav = !(isFav);
                                                  setState(() {});
                                                },
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                top: .5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(.5),
                                                      blurRadius: 2.5 *
                                                          SizeConfig
                                                              .imageSizeMultiplier,
                                                      spreadRadius: 0.0,
                                                      offset: Offset(2, 5.0)),
                                                ],
                                                shape: BoxShape.circle,
                                              ),
                                              width: 7 *
                                                  SizeConfig
                                                      .imageSizeMultiplier,
                                              height: 7 *
                                                  SizeConfig
                                                      .imageSizeMultiplier,
                                              child: Icon(
                                                isFav
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: MyColors.primaryColor,
                                                size: 7 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 2.5 * SizeConfig.heightMultiplier),
                        alignment: Alignment.center,
                        child: Text(
                          widget.doctor.name == null ? "-" : widget.doctor.name,
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProMedium,
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                              color: MyColors.primaryColor),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: .5 * SizeConfig.heightMultiplier,
                            left: 2.5 * SizeConfig.widthMultiplier,
                            right: 2.5 * SizeConfig.widthMultiplier),
                        alignment: Alignment.topCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // RatingBar(
                            //   ignoreGestures: true,
                            //   itemSize: 2.5 * SizeConfig.imageSizeMultiplier,
                            //   initialRating: widget.doctor.rating.toDouble(),
                            //   minRating: 1,
                            //   direction: Axis.horizontal,
                            //   allowHalfRating: true,
                            //   itemCount: 5,
                            //   itemBuilder: (context, _) => Icon(
                            //     Icons.star,
                            //     color: MyColors.red,
                            //   ),
                            //   onRatingUpdate: (rating) {
                            //     print(rating);
                            //   },
                            // ),
                            RatingBar.builder(
                              ignoreGestures: true,
                              itemSize: 2.5 * SizeConfig.imageSizeMultiplier,
                              initialRating: widget.doctor.rating.toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: MyColors.red,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            Container(
                              margin: CommonUtils.getLanguage(context) ==
                                      "english"
                                  ? EdgeInsets.only(
                                      left: 1.5 * SizeConfig.widthMultiplier)
                                  : EdgeInsets.only(
                                      right: 1.5 * SizeConfig.widthMultiplier),
                              child: Text(
                                "(" + widget.doctor.rating.toString() + ")",
                                style: TextStyle(
                                  fontFamily: FontUtils.ceraProMedium,
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  color: MyColors.primaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    top: 3 * SizeConfig.heightMultiplier),
                                height: .7,
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                color: MyColors.red.withOpacity(.5),
                              ),
                              Container(
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                margin: EdgeInsets.only(
                                    top: 2 * SizeConfig.heightMultiplier,
                                    right: 2.5 * SizeConfig.widthMultiplier,
                                    left: 2.5 * SizeConfig.widthMultiplier),
                                child: Text(
                                  AppLocalizations.of(context)
                                          .translate("certificate") +
                                      ":",
                                  style: TextStyle(
                                      fontFamily: FontUtils.ceraProBold,
                                      fontSize:
                                          2.15 * SizeConfig.textMultiplier,
                                      color: MyColors.primaryColor,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              Container(
                                height: 9 * SizeConfig.heightMultiplier,
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                margin: EdgeInsets.only(
                                    top: 2 * SizeConfig.heightMultiplier,
                                    right: 6 * SizeConfig.widthMultiplier,
                                    left: 6 * SizeConfig.widthMultiplier),
                                child: widget.doctor.certificates != null &&
                                        widget.doctor.certificates.length > 0
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          Certificate certificate =
                                              widget.doctor.certificates[index];
                                          return Container(
                                            margin: EdgeInsets.only(
                                                right: 2.5 *
                                                    SizeConfig.widthMultiplier),
                                            child: Image(
                                              image: certificate.file == null
                                                  ? AssetImage(ImageUtils
                                                      .certificateIcon)
                                                  : NetworkImage(
                                                      ApiUtils.BaseApiUrlMain +
                                                          certificate.file),
                                              fit: BoxFit.contain,
                                            ),
                                          );
                                        },
                                        itemCount: widget.doctor.certificates ==
                                                null
                                            ? 0
                                            : widget.doctor.certificates.length,
                                      )
                                    : Center(
                                        child: Text(
                                          "No Cerificate Found",
                                          style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize: 2.15 *
                                                SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                      ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 2 * SizeConfig.heightMultiplier),
                                height: .7,
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                color: MyColors.red.withOpacity(.5),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 2 * SizeConfig.heightMultiplier,
                                    right: 2.5 * SizeConfig.widthMultiplier,
                                    left: 2.5 * SizeConfig.widthMultiplier),
                                alignment: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Text(
                                  AppLocalizations.of(context)
                                          .translate("qualification") +
                                      ":",
                                  style: TextStyle(
                                      fontFamily: FontUtils.ceraProBold,
                                      fontSize:
                                          2.15 * SizeConfig.textMultiplier,
                                      color: MyColors.primaryColor,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              Container(
                                alignment: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                margin: EdgeInsets.only(
                                    top: 1.5 * SizeConfig.heightMultiplier,
                                    right: 4.5 * SizeConfig.widthMultiplier,
                                    left: 4.5 * SizeConfig.widthMultiplier),
                                child: Text(
                                  widget.doctor.qualifications == null
                                      ? "-"
                                      : widget.doctor.qualifications,
                                  style: TextStyle(
                                    fontFamily: FontUtils.ceraProBold,
                                    fontSize: 1.8 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 2 * SizeConfig.heightMultiplier),
                                height: .7,
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                color: MyColors.red.withOpacity(.5),
                              ),
                              Container(
                                  width:
                                      ScreenUtil.getInstance().width.toDouble(),
                                  margin: EdgeInsets.only(
                                      top: 2 * SizeConfig.heightMultiplier,
                                      right: 2.5 * SizeConfig.widthMultiplier,
                                      left: 2.5 * SizeConfig.widthMultiplier),
                                  alignment: CommonUtils.getLanguage(context) ==
                                          "english"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                                .translate("specialty") +
                                            ":",
                                        style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize: 2.15 *
                                                SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      Container(
                                        margin: CommonUtils.getLanguage(
                                                    context) ==
                                                "english"
                                            ? EdgeInsets.only(
                                                left: 2.5 *
                                                    SizeConfig.widthMultiplier)
                                            : EdgeInsets.only(
                                                right: 2.5 *
                                                    SizeConfig.widthMultiplier),
                                        child: Text(
                                          widget.doctor.speciality == null
                                              ? ""
                                              : CommonUtils.getLanguage(
                                                          context) ==
                                                      "english"
                                                  ? widget
                                                      .doctor.speciality.name
                                                  : widget
                                                      .doctor.speciality.nameAr,
                                          style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 2 * SizeConfig.heightMultiplier),
                                height: .7,
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                color: MyColors.red.withOpacity(.5),
                              ),
                              Container(
                                  width:
                                      ScreenUtil.getInstance().width.toDouble(),
                                  margin: EdgeInsets.only(
                                      top: 2 * SizeConfig.heightMultiplier,
                                      right: 2.5 * SizeConfig.widthMultiplier,
                                      left: 2.5 * SizeConfig.widthMultiplier),
                                  alignment: CommonUtils.getLanguage(context) ==
                                          "english"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                                .translate("address") +
                                            ":",
                                        style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize: 2.15 *
                                                SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      Container(
                                        margin: CommonUtils.getLanguage(
                                                    context) ==
                                                "english"
                                            ? EdgeInsets.only(
                                                left: 2.5 *
                                                    SizeConfig.widthMultiplier)
                                            : EdgeInsets.only(
                                                right: 2.5 *
                                                    SizeConfig.widthMultiplier),
                                        child: Text(
                                          widget.doctor.address == null
                                              ? ""
                                              : widget.doctor.address,
                                          style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 2 * SizeConfig.heightMultiplier),
                                height: .7,
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                color: MyColors.red.withOpacity(.5),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 2 * SizeConfig.heightMultiplier,
                                      right: 2.5 * SizeConfig.widthMultiplier,
                                      left: 2.5 * SizeConfig.widthMultiplier),
                                  alignment: CommonUtils.getLanguage(context) ==
                                          "english"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                                .translate("work_days") +
                                            ":",
                                        style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize: 2.15 *
                                                SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      Container(
                                        margin: CommonUtils.getLanguage(
                                                    context) ==
                                                "english"
                                            ? EdgeInsets.only(
                                                left: 2.5 *
                                                    SizeConfig.widthMultiplier)
                                            : EdgeInsets.only(
                                                right: 2.5 *
                                                    SizeConfig.widthMultiplier),
                                        child: Text(
                                          workDays,
                                          style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 2 * SizeConfig.heightMultiplier),
                                height: .7,
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                color: MyColors.red.withOpacity(.5),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 2 * SizeConfig.heightMultiplier,
                                      right: 2.5 * SizeConfig.widthMultiplier,
                                      left: 2.5 * SizeConfig.widthMultiplier),
                                  alignment: CommonUtils.getLanguage(context) ==
                                          "english"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                                .translate("work_hours") +
                                            ":",
                                        style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize: 2.15 *
                                                SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      Container(
                                        margin: CommonUtils.getLanguage(
                                                    context) ==
                                                "english"
                                            ? EdgeInsets.only(
                                                left: 2.5 *
                                                    SizeConfig.widthMultiplier)
                                            : EdgeInsets.only(
                                                right: 2.5 *
                                                    SizeConfig.widthMultiplier),
                                        child: Text(
                                          CommonUtils.getLanguage(context) ==
                                                  "english"
                                              ? widget.doctor.workHoursStr['en']
                                              : widget.doctor.workHoursStr['ar'],
                                          //CommonUtils.translate(context, "from")+" 3:00 "+ CommonUtils.translate(context, "to")+" 6:30 " ,
                                          style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 2 * SizeConfig.heightMultiplier),
                                height: .7,
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                color: MyColors.red.withOpacity(.5),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 2 * SizeConfig.heightMultiplier,
                                    right: 2.5 * SizeConfig.widthMultiplier,
                                    left: 2.5 * SizeConfig.widthMultiplier),
                                alignment: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Text(
                                  AppLocalizations.of(context)
                                          .translate("provided_services") +
                                      ":",
                                  style: TextStyle(
                                      fontFamily: FontUtils.ceraProBold,
                                      fontSize:
                                          2.15 * SizeConfig.textMultiplier,
                                      color: MyColors.primaryColor,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              Container(
                                alignment: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                margin: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? EdgeInsets.only(
                                        top: 2 * SizeConfig.heightMultiplier,
                                        left: 5 * SizeConfig.widthMultiplier)
                                    : EdgeInsets.only(
                                        top: 2 * SizeConfig.heightMultiplier,
                                        right: 5 * SizeConfig.widthMultiplier),
                                child: RichText(
                                  text: TextSpan(children: services),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 2 * SizeConfig.heightMultiplier),
                                height: 1,
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                color: MyColors.red.withOpacity(.3),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 2 * SizeConfig.heightMultiplier,
                                      right: 2.5 * SizeConfig.widthMultiplier,
                                      left: 2.5 * SizeConfig.widthMultiplier),
                                  alignment: CommonUtils.getLanguage(context) ==
                                          "english"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).translate(
                                                "available_methods") +
                                            ":",
                                        style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize: 2.15 *
                                                SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      Container(
                                        margin: CommonUtils.getLanguage(
                                                    context) ==
                                                "english"
                                            ? EdgeInsets.only(
                                                left: 2.5 *
                                                    SizeConfig.widthMultiplier)
                                            : EdgeInsets.only(
                                                right: 2.5 *
                                                    SizeConfig.widthMultiplier),
                                        child: Text(
                                          methodsNames,
                                          style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              Container(
                                color: Colors.grey.withOpacity(0.3),
                                margin: EdgeInsets.only(
                                    top: 2 * SizeConfig.heightMultiplier),
                                padding: EdgeInsets.only(
                                    bottom: 4 * SizeConfig.heightMultiplier),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: CommonUtils.getLanguage(
                                                    context) ==
                                                "english"
                                            ? EdgeInsets.only(
                                                top: 2 *
                                                    SizeConfig.heightMultiplier,
                                                left: 2.5 *
                                                    SizeConfig.widthMultiplier)
                                            : EdgeInsets.only(
                                                top: 2 *
                                                    SizeConfig.heightMultiplier,
                                                right: 2.5 *
                                                    SizeConfig.widthMultiplier),
                                        width: ScreenUtil.getInstance()
                                            .width
                                            .toDouble(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate("reviews"),
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontUtils.ceraProBold,
                                                  fontSize: 2.00 *
                                                      SizeConfig.textMultiplier,
                                                  color: MyColors.primaryColor,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                            Container(
                                              margin: CommonUtils.getLanguage(
                                                          context) ==
                                                      "english"
                                                  ? EdgeInsets.only(
                                                      left: .5 *
                                                          SizeConfig
                                                              .widthMultiplier)
                                                  : EdgeInsets.only(
                                                      right: .5 *
                                                          SizeConfig
                                                              .widthMultiplier),
                                              child: Text(
                                                "(${widget.doctor.reviews == null ? 0 : widget.doctor.reviews.length})",
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontUtils.ceraProBold,
                                                  fontSize: 1.8 *
                                                      SizeConfig.textMultiplier,
                                                  color: MyColors.primaryColor,
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                    Container(
                                      height: widget.doctor.reviews != null &&
                                              widget.doctor.reviews.length == 0
                                          ? 0
                                          : 30 * SizeConfig.heightMultiplier,
                                      margin: EdgeInsets.only(
                                          top: 1.5 *
                                              SizeConfig.heightMultiplier),
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          Review review =
                                              widget.doctor.reviews[index];
                                          return ClientReviewItem(review);
                                        },
                                        itemCount: widget.doctor.reviews == null
                                            ? 0
                                            : widget.doctor.reviews.length,
                                        shrinkWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
