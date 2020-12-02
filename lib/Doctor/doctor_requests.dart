import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Apis/common_apis.dart';
import 'package:alif_pet/Common/app_background.dart';
import 'package:alif_pet/Common/my_loader.dart';
import 'package:alif_pet/Doctor/doctor_request_detail.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/Utils/userData.dart';
import 'package:alif_pet/models/request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DoctorRequests extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DoctorRequestsState();
  }
}

class DoctorRequestsState extends State<DoctorRequests> {
  String userType;
  bool isLoading = true;
  bool isInternet = true;
  bool isEnglish = true;
  List<Request> requests = [];
  @override
  void initState() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        CommonApis().getRequests(isEnglish).then((result) {
          if (result is String) {
            //ToastUtils.showCustomToast(context, result, Colors.white , MyColors.primaryColor);
          } else {
            requests = result;
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
  void didChangeDependencies() {
    isEnglish = CommonUtils.getLanguage(context) == "english";
    var userData = Provider.of<UserData>(context);
    userType = userData.getUserType;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void reload() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        CommonApis().getRequests(isEnglish).then((result) {
          if (result is String) {
          } else {
            requests = result;
            setState(() {});
          }
        });
      } else {
        setState(() {
          isInternet = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              child: isLoading
                  ? MyLoader()
                  : requests.length == 0
                      ? Center(
                          child: Text(
                            CommonUtils.translate(context, "no_request"),
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProMedium,
                                fontSize: 2.9 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            int status = requests[index].status;
                            return InkWell(
                              onTap: () async {
                                bool toLoad = await Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: DoctorRequestDetail(
                                            request: requests[index])));
                                if (toLoad != null && toLoad) {
                                  reload();
                                }
                              },
                              child: Container(
                                  child: status == 1
                                      ? newRequest(requests[index], index)
                                      : status == 2
                                          ? inProgressRequest(
                                              requests[index], index)
                                          : status == 3
                                              ? doneRequest(
                                                  requests[index], index)
                                              : cancelRequest(
                                                  requests[index], index)),
                            );
                          },
                          itemCount: requests.length),
            )
          ],
        ),
      ),
    );
  }

  Widget doneRequest(Request request, int index) {
    String requestDate =
        DateFormat("EEE,MMM-dd").format(DateTime.parse(request.date));
    return Column(
      children: <Widget>[
        Container(
          width: ScreenUtil.getInstance().width.toDouble(),
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
                  children: <Widget>[
                    Hero(
                      tag: request.id,
                      child: Container(
                        height: 9 * SizeConfig.imageSizeMultiplier,
                        width: 9 * SizeConfig.imageSizeMultiplier,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.5),
                                  blurRadius:
                                      2 * SizeConfig.imageSizeMultiplier)
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: userType == "doctor"
                              ? request.client.photo == null
                                  ? Image.asset(
                                      ImageUtils.doctorIcon,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      ApiUtils.BaseApiUrlMain +
                                          request.client.photo,
                                      fit: BoxFit.contain,
                                    )
                              : request.doctor.photo == null
                                  ? Image.asset(
                                      ImageUtils.doctorIcon,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      ApiUtils.BaseApiUrlMain +
                                          request.doctor.photo,
                                      fit: BoxFit.contain,
                                    ),
                        ),
                      ),
                    ),
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 2 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 2 * SizeConfig.widthMultiplier),
                      child: Text(
                        userType == "doctor"
                            ? request.client.name
                            : request.doctor.name,
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProBold,
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: ScreenUtil.getInstance().width.toDouble(),
                margin: CommonUtils.getLanguage(context) == "english"
                    ? EdgeInsets.only(left: 20 * SizeConfig.widthMultiplier)
                    : EdgeInsets.only(right: 20 * SizeConfig.widthMultiplier),
                child: Text(
                  requestDate,
                  style: TextStyle(
                      fontFamily: FontUtils.ceraProRegular,
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                      color: MyColors.primaryColor),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            left: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier)
                        : EdgeInsets.only(
                            right: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier),
                    child: Text(
                      CommonUtils.translate(context, "status"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProBold,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor),
                    ),
                  ),
                  Container(
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            right: 20 * SizeConfig.widthMultiplier)
                        : EdgeInsets.only(
                            left: 20 * SizeConfig.widthMultiplier),
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 5 * SizeConfig.imageSizeMultiplier,
                            height: 5 * SizeConfig.imageSizeMultiplier,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: MyColors.green,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  .5 * SizeConfig.imageSizeMultiplier)),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black.withOpacity(.2),
                                    blurRadius:
                                        2 * SizeConfig.imageSizeMultiplier)
                              ],
                            ),
                            margin: EdgeInsets.only(
                                top: 1.5 * SizeConfig.heightMultiplier),
                            child: Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 5 * SizeConfig.imageSizeMultiplier,
                            )),
                        Container(
                          margin: CommonUtils.getLanguage(context) == "english"
                              ? EdgeInsets.only(
                                  left: 3 * SizeConfig.widthMultiplier,
                                  top: 1.5 * SizeConfig.heightMultiplier)
                              : EdgeInsets.only(
                                  right: 3 * SizeConfig.widthMultiplier,
                                  top: 1.5 * SizeConfig.heightMultiplier),
                          child: Text(
                            isEnglish
                                ? request.statusName['en']
                                : request.statusName['ar'],
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProMedium,
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 25 * SizeConfig.widthMultiplier,
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            left: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier)
                        : EdgeInsets.only(
                            right: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier),
                    child: Text(
                      CommonUtils.translate(context, "cost"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProBold,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor),
                    ),
                  ),
                  Container(
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            left: 23 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier)
                        : EdgeInsets.only(
                            right: 23 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier),
                    child: Text(
                      request.cost.toString() +
                          " ${isEnglish ? request.currency['en'] : request.currency['ar']}",
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProMedium,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.dark_blue),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        index == requests.length
            ? Container()
            : Container(
                margin: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                height: .3,
                width: ScreenUtil.getInstance().width.toDouble(),
                color: MyColors.dark_red,
              ),
      ],
    );
  }

  Widget cancelRequest(Request request, int index) {
    String requestDate =
        DateFormat("EEE,MMM-dd").format(DateTime.parse(request.date));
    return Column(
      children: <Widget>[
        Container(
          width: ScreenUtil.getInstance().width.toDouble(),
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
                  children: <Widget>[
                    Hero(
                      tag: request.id,
                      child: Container(
                        height: 9 * SizeConfig.imageSizeMultiplier,
                        width: 9 * SizeConfig.imageSizeMultiplier,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.5),
                                  blurRadius:
                                      2 * SizeConfig.imageSizeMultiplier)
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: userType == "doctor"
                              ? request.client.photo == null
                                  ? Image.asset(
                                      ImageUtils.doctorIcon,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      ApiUtils.BaseApiUrlMain +
                                          request.client.photo,
                                      fit: BoxFit.contain,
                                    )
                              : request.doctor.photo == null
                                  ? Image.asset(
                                      ImageUtils.doctorIcon,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      ApiUtils.BaseApiUrlMain +
                                          request.doctor.photo,
                                      fit: BoxFit.contain,
                                    ),
                        ),
                      ),
                    ),
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 2 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 2 * SizeConfig.widthMultiplier),
                      child: Text(
                        userType == "doctor"
                            ? request.client.name
                            : request.doctor.name,
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProBold,
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: ScreenUtil.getInstance().width.toDouble(),
                margin: CommonUtils.getLanguage(context) == "english"
                    ? EdgeInsets.only(left: 20 * SizeConfig.widthMultiplier)
                    : EdgeInsets.only(right: 20 * SizeConfig.widthMultiplier),
                child: Text(
                  requestDate,
                  style: TextStyle(
                      fontFamily: FontUtils.ceraProRegular,
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                      color: MyColors.primaryColor),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 20 * SizeConfig.widthMultiplier,
                              top: 1.5 * SizeConfig.heightMultiplier)
                          : EdgeInsets.only(
                              right: 20 * SizeConfig.widthMultiplier,
                              top: 1.5 * SizeConfig.heightMultiplier),
                      child: Text(
                        CommonUtils.translate(context, "status"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProBold,
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? EdgeInsets.only(
                                        top: 1.5 * SizeConfig.heightMultiplier,
                                        left: 30 * SizeConfig.widthMultiplier)
                                    : EdgeInsets.only(
                                        right: 30 * SizeConfig.widthMultiplier),
                                width: 5 * SizeConfig.imageSizeMultiplier,
                                height: 5 * SizeConfig.imageSizeMultiplier,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: MyColors.red_icon,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          .5 * SizeConfig.imageSizeMultiplier)),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 1),
                                        color: Colors.black.withOpacity(.2),
                                        blurRadius:
                                            2 * SizeConfig.imageSizeMultiplier)
                                  ],
                                ),
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 5 * SizeConfig.imageSizeMultiplier,
                                )),
                            Tooltip(
                              preferBelow: false,
                              message: isEnglish
                                  ? request.statusName['en']
                                  : request.statusName['ar'],
                              textStyle: TextStyle(
                                  fontFamily: FontUtils.ceraProRegular,
                                  fontSize: 2.1 * SizeConfig.textMultiplier,
                                  color: Colors.white),
                              child: Container(
                                width: 25 * SizeConfig.widthMultiplier,
                                margin: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? EdgeInsets.only(
                                        left: 3 * SizeConfig.widthMultiplier,
                                        top: 1.5 * SizeConfig.heightMultiplier)
                                    : EdgeInsets.only(
                                        right: 3 * SizeConfig.widthMultiplier,
                                        top: 1.5 * SizeConfig.heightMultiplier),
                                child: Text(
                                  isEnglish
                                      ? request.statusName['en']
                                      : request.statusName['ar'],
                                  style: TextStyle(
                                      fontFamily: FontUtils.ceraProMedium,
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      color: MyColors.primaryColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 25 * SizeConfig.widthMultiplier,
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            left: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier)
                        : EdgeInsets.only(
                            right: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier),
                    child: Text(
                      CommonUtils.translate(context, "cost"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProBold,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor),
                    ),
                  ),
                  Container(
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            left: 23 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier)
                        : EdgeInsets.only(
                            right: 23 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier),
                    child: Text(
                      request.cost.toString() +
                          " ${isEnglish ? request.currency['en'] : request.currency['ar']}",
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProMedium,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.dark_blue),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        index == requests.length
            ? Container()
            : Container(
                margin: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                height: .3,
                width: ScreenUtil.getInstance().width.toDouble(),
                color: MyColors.dark_red,
              ),
      ],
    );
  }

  Widget inProgressRequest(Request request, int index) {
    String requestDate =
        DateFormat("EEE,MMM-dd").format(DateTime.parse(request.date));
    return Column(
      children: <Widget>[
        Container(
          width: ScreenUtil.getInstance().width.toDouble(),
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
                  children: <Widget>[
                    Hero(
                      tag: request.id,
                      child: Container(
                        height: 9 * SizeConfig.imageSizeMultiplier,
                        width: 9 * SizeConfig.imageSizeMultiplier,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.5),
                                  blurRadius:
                                      2 * SizeConfig.imageSizeMultiplier)
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: userType == "doctor"
                              ? request.client.photo == null
                                  ? Image.asset(
                                      ImageUtils.doctorIcon,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      ApiUtils.BaseApiUrlMain +
                                          request.client.photo,
                                      fit: BoxFit.contain,
                                    )
                              : request.doctor.photo == null
                                  ? Image.asset(
                                      ImageUtils.doctorIcon,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      ApiUtils.BaseApiUrlMain +
                                          request.doctor.photo,
                                      fit: BoxFit.contain,
                                    ),
                        ),
                      ),
                    ),
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 2 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 2 * SizeConfig.widthMultiplier),
                      child: Text(
                        userType == "doctor"
                            ? request.client.name
                            : request.doctor.name,
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProBold,
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: ScreenUtil.getInstance().width.toDouble(),
                margin: CommonUtils.getLanguage(context) == "english"
                    ? EdgeInsets.only(left: 20 * SizeConfig.widthMultiplier)
                    : EdgeInsets.only(right: 20 * SizeConfig.widthMultiplier),
                child: Text(
                  requestDate,
                  style: TextStyle(
                      fontFamily: FontUtils.ceraProRegular,
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                      color: MyColors.primaryColor),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 25 * SizeConfig.widthMultiplier,
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            left: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier)
                        : EdgeInsets.only(
                            right: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier),
                    child: Text(
                      CommonUtils.translate(context, "status"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProBold,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor),
                    ),
                  ),
                  Container(
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            left: 23 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier)
                        : EdgeInsets.only(
                            right: 23 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier),
                    child: Text(
                      isEnglish
                          ? request.statusName['en']
                          : request.statusName['ar'],
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProMedium,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 25 * SizeConfig.widthMultiplier,
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            left: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier)
                        : EdgeInsets.only(
                            right: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier),
                    child: Text(
                      CommonUtils.translate(context, "cost"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProBold,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor),
                    ),
                  ),
                  Container(
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(left: 15 * SizeConfig.widthMultiplier)
                        : EdgeInsets.only(
                            right: 15 * SizeConfig.widthMultiplier),
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 5 * SizeConfig.imageSizeMultiplier,
                            height: 5 * SizeConfig.imageSizeMultiplier,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: MyColors.yellow,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  .5 * SizeConfig.imageSizeMultiplier)),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black.withOpacity(.2),
                                    blurRadius:
                                        2 * SizeConfig.imageSizeMultiplier)
                              ],
                            ),
                            margin: EdgeInsets.only(
                                left: 0 * SizeConfig.widthMultiplier,
                                top: 1.5 * SizeConfig.heightMultiplier),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 5 * SizeConfig.imageSizeMultiplier,
                            )),
                        Container(
                          margin: EdgeInsets.only(
                              left: 3 * SizeConfig.widthMultiplier,
                              top: 1.5 * SizeConfig.heightMultiplier),
                          child: Text(
                            request.cost.toString() +
                                " ${isEnglish ? request.currency['en'] : request.currency['ar']}",
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProMedium,
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: MyColors.dark_blue),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        index == requests.length
            ? Container()
            : Container(
                margin: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                height: .3,
                width: ScreenUtil.getInstance().width.toDouble(),
                color: MyColors.dark_red,
              ),
      ],
    );
  }

  Widget newRequest(Request request, int index) {
    String requestDate =
        DateFormat("EEE,MMM-dd").format(DateTime.parse(request.date));
    return Column(
      children: <Widget>[
        Container(
          width: ScreenUtil.getInstance().width.toDouble(),
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
                  children: <Widget>[
                    Hero(
                      tag: request.id,
                      child: Container(
                        height: 9 * SizeConfig.imageSizeMultiplier,
                        width: 9 * SizeConfig.imageSizeMultiplier,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.5),
                                  blurRadius:
                                      2 * SizeConfig.imageSizeMultiplier)
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: userType == "doctor"
                              ? request.client.photo == null
                                  ? Image.asset(
                                      ImageUtils.doctorIcon,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      ApiUtils.BaseApiUrlMain +
                                          request.client.photo,
                                      fit: BoxFit.contain,
                                    )
                              : request.doctor.photo == null
                                  ? Image.asset(
                                      ImageUtils.doctorIcon,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      ApiUtils.BaseApiUrlMain +
                                          request.doctor.photo,
                                      fit: BoxFit.contain,
                                    ),
                        ),
                      ),
                    ),
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 2 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 2 * SizeConfig.widthMultiplier),
                      child: Text(
                        userType == "doctor"
                            ? request.client.name
                            : request.doctor.name,
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProBold,
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: ScreenUtil.getInstance().width.toDouble(),
                margin: CommonUtils.getLanguage(context) == "english"
                    ? EdgeInsets.only(left: 20 * SizeConfig.widthMultiplier)
                    : EdgeInsets.only(right: 20 * SizeConfig.widthMultiplier),
                child: Text(
                  requestDate,
                  style: TextStyle(
                      fontFamily: FontUtils.ceraProRegular,
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                      color: MyColors.primaryColor),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            left: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier)
                        : EdgeInsets.only(
                            right: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier),
                    child: Text(
                      CommonUtils.translate(context, "status"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProBold,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor),
                    ),
                  ),
                  Container(
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            right: 20 * SizeConfig.widthMultiplier)
                        : EdgeInsets.only(
                            left: 20 * SizeConfig.widthMultiplier),
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 5 * SizeConfig.imageSizeMultiplier,
                            height: 5 * SizeConfig.imageSizeMultiplier,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  .5 * SizeConfig.imageSizeMultiplier)),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black.withOpacity(.2),
                                    blurRadius:
                                        2 * SizeConfig.imageSizeMultiplier)
                              ],
                            ),
                            margin: EdgeInsets.only(
                                top: 1.5 * SizeConfig.heightMultiplier),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 5 * SizeConfig.imageSizeMultiplier,
                            )),
                        Container(
                          margin: CommonUtils.getLanguage(context) == "english"
                              ? EdgeInsets.only(
                                  left: 3 * SizeConfig.widthMultiplier,
                                  top: 1.5 * SizeConfig.heightMultiplier)
                              : EdgeInsets.only(
                                  right: 3 * SizeConfig.widthMultiplier,
                                  top: 1.5 * SizeConfig.heightMultiplier),
                          child: Text(
                            isEnglish
                                ? request.statusName['en']
                                : request.statusName['ar'],
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProMedium,
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 25 * SizeConfig.widthMultiplier,
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            left: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier)
                        : EdgeInsets.only(
                            right: 20 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier),
                    child: Text(
                      CommonUtils.translate(context, "cost"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProBold,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor),
                    ),
                  ),
                  Container(
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(
                            left: 23 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier)
                        : EdgeInsets.only(
                            right: 23 * SizeConfig.widthMultiplier,
                            top: 1.5 * SizeConfig.heightMultiplier),
                    child: Text(
                      request.cost.toString() +
                          " ${isEnglish ? request.currency['en'] : request.currency['ar']}",
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProMedium,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.dark_blue),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        index == requests.length
            ? Container()
            : Container(
                margin: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                height: .3,
                width: ScreenUtil.getInstance().width.toDouble(),
                color: MyColors.dark_red,
              ),
      ],
    );
  }
}
