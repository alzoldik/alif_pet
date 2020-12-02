import 'dart:io';
import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Apis/common_apis.dart';
import 'package:alif_pet/Apis/doctor_apis.dart';
import 'package:alif_pet/Common/my_loader.dart';
import 'package:alif_pet/CommonWidgets/pick_services_dialog.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/dialog_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/Utils/string_utils.dart';
import 'package:alif_pet/Utils/toast_utils.dart';
import 'package:alif_pet/language/app_localization.dart';
import 'package:alif_pet/models/certificate.dart';
import 'package:alif_pet/models/profile.dart';
import 'package:alif_pet/models/service_of_request.dart';
import 'package:alif_pet/models/speciality.dart';
import 'package:alif_pet/models/success.dart';
import 'package:alif_pet/models/update_profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as myPath;

class DoctorProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DoctorProfileState();
  }
}

class DoctorProfileState extends State<DoctorProfile> {
  List methods = [];
  var daysList = [
    "sunday",
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday"
  ];
  var selectedDays = [];
  bool isEnglish, isUpdating = false, isLoading = true, isUploading = false;
  final fromController = TextEditingController();
  final toController = TextEditingController();
  Profile profile;
  List<Speciality> specialities = [];
  List selectedServiceIds = [];
  List<Service_of_request> services = [];
  List<Certificate> certificates = [];
  List<DropdownMenuItem<Speciality>> specialityItems = List();
  Speciality selectedSpeciality;
  double from, to;
  String fromTime = "", toTime = "";
  File profilePic, certificateImage;
  @override
  void initState() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        CommonApis()
            .getProfileAndSpecialitiesAndServices(isEnglish)
            .then((result) {
          if (result is String) {
          } else {
            profile = result[0];
            specialities = result[1];
            services = result[2];
            fromController.text = profile.workHoursFrom.toString();
            toController.text = profile.workhoursTo.toString();
            specialityItems = specialities
                .asMap()
                .values
                .map((speciality) => DropdownMenuItem<Speciality>(
                    value: speciality,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 1.5 * SizeConfig.widthMultiplier),
                      child: Text(
                        speciality.name,
                        style: TextStyle(
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          fontFamily: FontUtils.ceraProMedium,
                          color: MyColors.primaryColor,
                        ),
                      ),
                    )))
                .toList();

            selectedSpeciality = profile.speciality == null
                ? specialities[0]
                : specialities.singleWhere(
                    (speciality) => speciality.id == profile.speciality.id);
            getWorkDays();
            toTime = profile.workhoursTo == null
                ? ""
                : _doubleToTimeOfDayString(profile.workhoursTo);
            fromTime = profile.workHoursFrom == null
                ? ""
                : _doubleToTimeOfDayString(profile.workHoursFrom);
            to = profile.workhoursTo == null
                ? 0
                : profile.workhoursTo.toDouble();
            from = profile.workHoursFrom == null
                ? 0
                : profile.workHoursFrom.toDouble();
            certificates = profile.certificates;
            profile.services.forEach((selectedService) {
              selectedServiceIds.add(selectedService.service.id);
              if (!methods.contains(selectedService.service.method)) {
                methods.add(selectedService.service.method);
              }
            });
            isLoading = false;
            if (mounted) {
              setState(() {});
            }
          }
        });
      } else {}
    });
    super.initState();
  }

  void openGalleryForPfp() async {
    File profilePicToChange =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (profilePicToChange != null) {
      setState(() {
        profilePic = profilePicToChange;
      });
    }
  }

  void openGalleryForCertificate() async {
    File certificateToUpload =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (certificateToUpload != null) {
      isUploading = true;
      setState(() {});
      DoctorApis()
          .uploadCertificate(
              FormData.fromMap({
                "file": await MultipartFile.fromFile(certificateToUpload.path,
                    filename: myPath.basename(certificateToUpload.path))
              }),
              isEnglish)
          .then((value) {
        if (value is String) {
          ToastUtils.showCustomToast(
              context, value, Colors.white, MyColors.primaryColor);
          isUploading = false;
          setState(() {});
        } else {
          Success response = value;
          CommonApis().getProfile().then((result) {
            if (result is String) {
            } else {
              profile = result;
              isUploading = false;
              certificates = profile.certificates;
              ToastUtils.showCustomToast(
                  context,
                  isEnglish ? response.en : response.ar,
                  Colors.white,
                  MyColors.primaryColor);
              if (mounted) {
                setState(() {});
              }
            }
          });
        }
      });
    }
  }

  void deleteCertificate(int id, int index) {
    CommonUtils.checkInternet().then((value) async {
      if (value) {
        certificates.removeAt(index);
        setState(() {});
        DoctorApis()
            .deleteCertificate(
                FormData.fromMap({
                  "id": id,
                }),
                isEnglish)
            .then((value) {
          if (value is String) {
            ToastUtils.showCustomToast(
                context, value, Colors.white, MyColors.primaryColor);
          } else {
            isUpdating = false;
            Success response = value;
            ToastUtils.showCustomToast(
                context,
                isEnglish ? response.en : response.ar,
                Colors.white,
                MyColors.primaryColor);
          }
        });
      } else {
        ToastUtils.showCustomToast(context, StringUtils.noInternet,
            Colors.white, MyColors.primaryColor);
      }
    });
  }

  void getFromTime() async {
    final timePicked = await showRoundedTimePicker(
      context: context,
      initialTime: _doubleToTimeOfDay(from),
      theme: ThemeData(primarySwatch: CommonUtils.getPrimaryColor()),
    );
    if (timePicked != null) {
      setState(() {
        from = double.parse(_timeOfDayToDouble(timePicked).toStringAsFixed(2));
        final MaterialLocalizations localizations =
            MaterialLocalizations.of(context);
        fromTime = localizations.formatTimeOfDay(timePicked);
      });
    }
  }

  void getToTime() async {
    final timePicked = await showRoundedTimePicker(
      context: context,
      initialTime: _doubleToTimeOfDay(to),
      theme: ThemeData(primarySwatch: CommonUtils.getPrimaryColor()),
    );
    if (timePicked != null) {
      setState(() {
        to = double.parse(_timeOfDayToDouble(timePicked).toStringAsFixed(2));
        final MaterialLocalizations localizations =
            MaterialLocalizations.of(context);
        toTime = localizations.formatTimeOfDay(timePicked);
      });
    }
  }

  String getSelectedServices() {
    String serviceText = "";
    services.forEach((service) {
      if (selectedServiceIds.contains(service.id)) {
        serviceText = isEnglish
            ? serviceText + service.name + ","
            : serviceText + service.nameAr + ",";
      }
    });

    return serviceText.length > 0
        ? serviceText.substring(0, serviceText.length - 1)
        : "";
  }

  @override
  void didChangeDependencies() {
    isEnglish = CommonUtils.getLanguage(context) == "english";

    super.didChangeDependencies();
  }

  void getWorkDays() {
    if (profile.workDaysNames != null && profile.workDaysNames.length > 0) {
      for (int i = 1; i < 8; i++) {
        if (profile.workDaysNames.containsKey(i.toString())) {
          selectedDays.add(1);
        } else {
          selectedDays.add(0);
        }
      }
    } else {
      for (int i = 1; i < 8; i++) {
        selectedDays.add(0);
      }
    }
  }

  List<Widget> getDayItems() {
    return List.generate(7, (index) {
      bool isSelected = selectedDays != null &&
          selectedDays.length > 0 &&
          selectedDays[index] == 1;
      return InkWell(
        onTap: () {
          if (selectedDays != null &&
              selectedDays.length > 0 &&
              selectedDays[index] == 1) {
            selectedDays[index] = 0;
          } else {
            selectedDays[index] = 1;
          }
          setState(() {});
        },
        child: Container(
          alignment: Alignment.center,
          width: 19 * SizeConfig.widthMultiplier,
          height: 5.5 * SizeConfig.heightMultiplier,
          decoration: BoxDecoration(
            color: isSelected ? MyColors.primaryColor : Colors.transparent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
                Radius.circular(3 * SizeConfig.imageSizeMultiplier)),
            border: Border.all(
                color: isSelected
                    ? MyColors.primaryColor
                    : MyColors.red.withOpacity(.5),
                width: 2),
          ),
          child: Text(
            CommonUtils.translate(context, daysList[index]),
            style: TextStyle(
                color: isSelected ? Colors.white : MyColors.primaryColor,
                fontSize: 1.85 * SizeConfig.textMultiplier,
                fontFamily: FontUtils.ceraProMedium),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    });
  }

  void updateProfile() {
    CommonUtils.checkInternet().then((value) async {
      if (value) {
        isUpdating = true;
        if (mounted) {
          setState(() {});
        }
        CommonApis()
            .updateProfile(
                FormData.fromMap({
                  "photo": profilePic == null
                      ? profile.photo
                      : await MultipartFile.fromFile(profilePic.path,
                          filename: myPath.basename(profilePic.path)),
                  "speciality_id": selectedSpeciality.id,
                  "work_days": selectedDays == null || selectedDays.length == 0
                      ? ""
                      : arrayToString(selectedDays),
                  "work_hours_from": from,
                  "work_hours_to": to,
                  "services": selectedServiceIds.length == 0
                      ? ""
                      : arrayToString(selectedServiceIds)
                }),
                isEnglish)
            .then((value) {
          if (value is String) {
            ToastUtils.showCustomToast(
                context, value, Colors.white, MyColors.primaryColor);
            isUpdating = false;
            if (mounted) {
              setState(() {});
            }
          } else {
            isUpdating = false;
            Update_profile response = value;
            ToastUtils.showCustomToast(
                context,
                isEnglish ? response.success.en : response.success.ar,
                Colors.white,
                MyColors.primaryColor);
            if (mounted) {
              setState(() {});
            }
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
    return Container(
      height: ScreenUtil.getInstance().height.toDouble(),
      width: ScreenUtil.getInstance().width.toDouble(),
      margin: EdgeInsets.only(
        bottom: 8 * SizeConfig.heightMultiplier,
      ),
      child: isLoading
          ? MyLoader()
          : Column(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: 11.5 * SizeConfig.heightMultiplier),
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 24 * SizeConfig.imageSizeMultiplier,
                            width: 24 * SizeConfig.imageSizeMultiplier,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 23 * SizeConfig.imageSizeMultiplier,
                                  width: 23 * SizeConfig.imageSizeMultiplier,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(.5),
                                            blurRadius: 3.5 *
                                                SizeConfig.imageSizeMultiplier,
                                            spreadRadius: 0.0,
                                            offset: Offset(2, 6.0)),
                                      ],
                                      color: Colors.white),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    child: profilePic == null
                                        ? profile.photo == null
                                            ? Image.asset(
                                                ImageUtils.doctorIcon,
                                                fit: BoxFit.contain,
                                              )
                                            : Image.network(
                                                ApiUtils.BaseApiUrlMain +
                                                    profile.photo,
                                                fit: BoxFit.contain,
                                              )
                                        : Image.file(
                                            profilePic,
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                    onTap: openGalleryForPfp,
                                    child: Container(
                                      height:
                                          8 * SizeConfig.imageSizeMultiplier,
                                      width: 8 * SizeConfig.imageSizeMultiplier,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        alignment: Alignment.center,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.withOpacity(.3)),
                                        child: Icon(
                                          Icons.photo_camera,
                                          size: 5 *
                                              SizeConfig.imageSizeMultiplier,
                                          color: MyColors.primaryColor
                                              .withOpacity(.7),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 2.5 * SizeConfig.heightMultiplier),
                  alignment: Alignment.center,
                  child: Text(
                    profile.name,
                    style: TextStyle(
                        fontFamily: FontUtils.ceraProMedium,
                        fontSize: 2.2 * SizeConfig.textMultiplier,
                        color: MyColors.primaryColor),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: 3 * SizeConfig.heightMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 24 * SizeConfig.widthMultiplier,
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
                              Expanded(
                                flex: 8,
                                child: Container(),
                              ),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: openGalleryForCertificate,
                                  child: Container(
                                    alignment:
                                        CommonUtils.getLanguage(context) ==
                                                "english"
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate("upload"),
                                      style: TextStyle(
                                        fontFamily: FontUtils.ceraProBold,
                                        fontSize:
                                            1.65 * SizeConfig.textMultiplier,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 9 * SizeConfig.heightMultiplier,
                          width: ScreenUtil.getInstance().width.toDouble(),
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier,
                              right: 6 * SizeConfig.widthMultiplier,
                              left: 6 * SizeConfig.widthMultiplier),
                          child: certificates.length > 0
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          right:
                                              2.5 * SizeConfig.widthMultiplier),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(
                                                  right:
                                                      1.5 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                  top: 1 *
                                                      SizeConfig
                                                          .imageSizeMultiplier),
                                              child: Image(
                                                  image: certificates[index]
                                                              .file ==
                                                          null
                                                      ? AssetImage(
                                                          ImageUtils
                                                              .certificateIcon)
                                                      : NetworkImage(ApiUtils
                                                              .BaseApiUrlMain +
                                                          certificates[index]
                                                              .file),
                                                  fit: BoxFit.cover,
                                                  width: 20 *
                                                      SizeConfig
                                                          .imageSizeMultiplier,
                                                  height: 20 *
                                                      SizeConfig
                                                          .imageSizeMultiplier)),
                                          Positioned(
                                            right: 0.0,
                                            top: 0.0,
                                            child: InkWell(
                                              onTap: () {
                                                deleteCertificate(
                                                    certificates[index].id,
                                                    index);
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 4 *
                                                      SizeConfig
                                                          .imageSizeMultiplier,
                                                  height: 4 *
                                                      SizeConfig
                                                          .imageSizeMultiplier,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey),
                                                  child: ImageIcon(
                                                    AssetImage(
                                                        ImageUtils.crossIcon),
                                                    size: 2 *
                                                        SizeConfig
                                                            .imageSizeMultiplier,
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: certificates.length,
                                )
                              : Center(
                                  child: Text(
                                    "No Cerificate Found",
                                    style: TextStyle(
                                      fontFamily: FontUtils.ceraProBold,
                                      fontSize:
                                          2.15 * SizeConfig.textMultiplier,
                                      color: MyColors.primaryColor,
                                    ),
                                  ),
                                ),
                        ),
                        isUploading
                            ? Container(
                                height: 1,
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                margin: EdgeInsets.only(
                                    top: 3 * SizeConfig.heightMultiplier),
                                child: Theme(
                                  data: ThemeData(
                                      accentColor: MyColors.primaryColor,
                                      backgroundColor: MyColors.primaryColor
                                          .withOpacity(.3)),
                                  child: LinearProgressIndicator(),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(
                                    top: 3 * SizeConfig.heightMultiplier),
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
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Text(
                            AppLocalizations.of(context)
                                    .translate("qualification") +
                                ":",
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProBold,
                                fontSize: 2.15 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        Container(
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          margin: EdgeInsets.only(
                              top: 1.5 * SizeConfig.heightMultiplier,
                              right: 4.5 * SizeConfig.widthMultiplier,
                              left: 4.5 * SizeConfig.widthMultiplier),
                          child: Text(
                            profile.qualifications == null
                                ? ""
                                : profile.qualifications,
                            style: TextStyle(
                              fontFamily: FontUtils.ceraProBold,
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                              color: MyColors.primaryColor,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 3 * SizeConfig.heightMultiplier),
                          height: 1,
                          width: ScreenUtil.getInstance().width.toDouble(),
                          color: MyColors.red.withOpacity(.3),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier),
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Text(
                            AppLocalizations.of(context)
                                    .translate("specialty") +
                                ":",
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProBold,
                                fontSize: 2.15 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        Container(
                          width: ScreenUtil.getInstance().width.toDouble(),
                          height: 5.5 * SizeConfig.heightMultiplier,
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier,
                              right: 9 * SizeConfig.widthMultiplier,
                              left: 9 * SizeConfig.widthMultiplier),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: MyColors.red.withOpacity(.5), width: 2),
                            borderRadius: BorderRadius.circular(
                                2.8 * SizeConfig.imageSizeMultiplier),
                          ),
                          child: DropdownButton<Speciality>(
                            items: specialityItems,
                            value: selectedSpeciality,
                            onChanged: (speciality) {
                              setState(() {
                                selectedSpeciality = speciality;
                              });
                            },
                            hint: Container(
                              margin: EdgeInsets.only(
                                  left: 3 * SizeConfig.widthMultiplier,
                                  right: 3 * SizeConfig.widthMultiplier),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("choose_your_specialty"),
                                style: TextStyle(
                                    color:
                                        MyColors.primaryColor.withOpacity(.5),
                                    fontFamily: FontUtils.ceraProMedium,
                                    fontSize: 1.8 * SizeConfig.textMultiplier),
                              ),
                            ),
                            isExpanded: true,
                            underline: Container(),
                            icon: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 6 * SizeConfig.imageSizeMultiplier,
                                color: MyColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier),
                          height: 1,
                          width: ScreenUtil.getInstance().width.toDouble(),
                          color: MyColors.red.withOpacity(.3),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier),
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Text(
                            AppLocalizations.of(context)
                                    .translate("work_days") +
                                ":",
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProBold,
                                fontSize: 2.15 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier),
                          child: Wrap(
                            spacing: 2 * SizeConfig.widthMultiplier,
                            runSpacing: 1 * SizeConfig.widthMultiplier,
                            children: getDayItems(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier),
                          height: 1,
                          width: ScreenUtil.getInstance().width.toDouble(),
                          color: MyColors.red.withOpacity(.3),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier),
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Text(
                            AppLocalizations.of(context)
                                    .translate("work_hours") +
                                ":",
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProBold,
                                fontSize: 2.15 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate("from"),
                                      style: TextStyle(
                                        fontFamily: FontUtils.ceraProBold,
                                        fontSize:
                                            1.9 * SizeConfig.textMultiplier,
                                        color: MyColors.primaryColor,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: getFromTime,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left:
                                                1 * SizeConfig.widthMultiplier),
                                        alignment: Alignment.center,
                                        width: 19 * SizeConfig.widthMultiplier,
                                        height:
                                            5.5 * SizeConfig.heightMultiplier,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3 *
                                                  SizeConfig
                                                      .imageSizeMultiplier)),
                                          border: Border.all(
                                              color:
                                                  MyColors.red.withOpacity(.5),
                                              width: 2),
                                        ),
                                        child: Center(
                                          child: Text(
                                            fromTime,
                                            style: TextStyle(
                                              fontFamily: FontUtils.ceraProBold,
                                              fontSize: 1.9 *
                                                  SizeConfig.textMultiplier,
                                              color: MyColors.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate("to"),
                                      style: TextStyle(
                                        fontFamily: FontUtils.ceraProBold,
                                        fontSize:
                                            1.9 * SizeConfig.textMultiplier,
                                        color: MyColors.primaryColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: getToTime,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left:
                                                1 * SizeConfig.widthMultiplier),
                                        alignment: Alignment.center,
                                        width: 19 * SizeConfig.widthMultiplier,
                                        height:
                                            5.5 * SizeConfig.heightMultiplier,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3 *
                                                  SizeConfig
                                                      .imageSizeMultiplier)),
                                          border: Border.all(
                                              color:
                                                  MyColors.red.withOpacity(.5),
                                              width: 2),
                                        ),
                                        child: Center(
                                          child: Text(
                                            toTime,
                                            style: TextStyle(
                                              fontFamily: FontUtils.ceraProBold,
                                              fontSize: 1.9 *
                                                  SizeConfig.textMultiplier,
                                              color: MyColors.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier),
                          height: 1,
                          width: ScreenUtil.getInstance().width.toDouble(),
                          color: MyColors.red.withOpacity(.3),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier),
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Text(
                            AppLocalizations.of(context)
                                    .translate("provided_services") +
                                ":",
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProBold,
                                fontSize: 2.15 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await DialogUtils.showDialog(
                                context,
                                PickServicesDialog(
                                  services: services,
                                  selectedServices: selectedServiceIds,
                                  isEnglish: isEnglish,
                                ));
                            methods.clear();
                            selectedServiceIds.forEach((id) {
                              Service_of_request service = services
                                  .singleWhere((service) => service.id == id);
                              if (service != null) {
                                if (!methods.contains(service.method)) {
                                  methods.add(service.method);
                                }
                              }
                            });
                            setState(() {});
                          },
                          child: Container(
                            width: ScreenUtil.getInstance().width.toDouble(),
                            height: 5.5 * SizeConfig.heightMultiplier,
                            margin: EdgeInsets.only(
                                top: 2 * SizeConfig.heightMultiplier,
                                right: 9 * SizeConfig.widthMultiplier,
                                left: 9 * SizeConfig.widthMultiplier),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  color: MyColors.red.withOpacity(.5),
                                  width: 2),
                              borderRadius: BorderRadius.circular(
                                  2.8 * SizeConfig.imageSizeMultiplier),
                            ),
                            child:
                                /*DropdownButton(
                        hint: Container(
                          margin: EdgeInsets.only(left: 3*SizeConfig.widthMultiplier,right: 3*SizeConfig.widthMultiplier ),
                          child: Text(
                            AppLocalizations.of(context).translate("choose_the_services_text"),
                            style: TextStyle(
                                color: MyColors.primaryColor.withOpacity(.5),
                                fontFamily: FontUtils.ceraProMedium,
                                fontSize: 1.8*SizeConfig.textMultiplier
                            ),
                          ),
                        ),
                        isExpanded: true,
                        underline: Container(),
                        icon: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.keyboard_arrow_down,size: 6*SizeConfig.imageSizeMultiplier,color: MyColors.primaryColor,),
                        ),
                      ),*/
                                Stack(
                              children: <Widget>[
                                Padding(
                                  padding: isEnglish
                                      ? EdgeInsets.only(
                                          left:
                                              1.5 * SizeConfig.widthMultiplier)
                                      : EdgeInsets.only(
                                          right:
                                              1.5 * SizeConfig.widthMultiplier),
                                  child: Align(
                                    alignment: isEnglish
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: Text(
                                      selectedServiceIds.length == 0
                                          ? AppLocalizations.of(context)
                                              .translate(
                                                  "choose_the_services_text")
                                          : getSelectedServices(),
                                      style: TextStyle(
                                          color: MyColors.primaryColor
                                              .withOpacity(.5),
                                          fontFamily: FontUtils.ceraProMedium,
                                          fontSize:
                                              1.8 * SizeConfig.textMultiplier),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: isEnglish
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 6 * SizeConfig.imageSizeMultiplier,
                                    color: MyColors.primaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier),
                          height: 1,
                          width: ScreenUtil.getInstance().width.toDouble(),
                          color: MyColors.red.withOpacity(.3),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier),
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Text(
                            AppLocalizations.of(context)
                                    .translate("available_methods") +
                                ":",
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProBold,
                                fontSize: 2.15 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier,
                              right: 2.5 * SizeConfig.widthMultiplier,
                              left: 2.5 * SizeConfig.widthMultiplier),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Container(
                                    margin: CommonUtils.getLanguage(context) ==
                                            "english"
                                        ? EdgeInsets.only(
                                            right:
                                                3 * SizeConfig.widthMultiplier)
                                        : EdgeInsets.only(
                                            left:
                                                3 * SizeConfig.widthMultiplier),
                                    alignment: Alignment.center,
                                    width: 17 * SizeConfig.widthMultiplier,
                                    height: 5.5 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      color: methods.contains("chat")
                                          ? MyColors.primaryColor
                                          : Colors.transparent,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3 *
                                              SizeConfig.imageSizeMultiplier)),
                                      border: Border.all(
                                          color: methods.contains("chat")
                                              ? MyColors.primaryColor
                                              : MyColors.red.withOpacity(.5),
                                          width: 2),
                                    ),
                                    child: Text(
                                      CommonUtils.translate(context, "chat"),
                                      style: TextStyle(
                                          color: methods.contains("chat")
                                              ? Colors.white
                                              : MyColors.primaryColor,
                                          fontSize:
                                              1.85 * SizeConfig.textMultiplier,
                                          fontFamily: FontUtils.ceraProMedium),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                    margin: CommonUtils.getLanguage(context) ==
                                            "english"
                                        ? EdgeInsets.only(
                                            left:
                                                3 * SizeConfig.widthMultiplier)
                                        : EdgeInsets.only(
                                            right:
                                                3 * SizeConfig.widthMultiplier),
                                    alignment: Alignment.center,
                                    width: 17 * SizeConfig.widthMultiplier,
                                    height: 5.5 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      color: methods.contains("visit")
                                          ? MyColors.primaryColor
                                          : Colors.transparent,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3 *
                                              SizeConfig.imageSizeMultiplier)),
                                      border: Border.all(
                                          color: methods.contains("visit")
                                              ? MyColors.primaryColor
                                              : MyColors.red.withOpacity(.5),
                                          width: 2),
                                    ),
                                    child: Text(
                                      CommonUtils.translate(context, "visit"),
                                      style: TextStyle(
                                          color: methods.contains("visit")
                                              ? Colors.white
                                              : MyColors.primaryColor,
                                          fontSize:
                                              1.85 * SizeConfig.textMultiplier,
                                          fontFamily: FontUtils.ceraProMedium),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3.5 * SizeConfig.heightMultiplier,
                          width: ScreenUtil.getInstance().width.toDouble(),
                        ),
                        Container(
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
                                            .translate("save"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                2.3 * SizeConfig.textMultiplier,
                                            fontFamily:
                                                FontUtils.ceraProRegular)),
                                    onPressed:
                                        isUpdating ? null : updateProfile,
                                    height: 5 * SizeConfig.heightMultiplier,
                                    minWidth: double.infinity,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.8 *
                                                SizeConfig
                                                    .imageSizeMultiplier))),
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
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .translate("cancel"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                2.3 * SizeConfig.textMultiplier,
                                            fontFamily:
                                                FontUtils.ceraProRegular)),
                                    onPressed: () {
                                      // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MobileVerification()));
                                    },
                                    height: 5 * SizeConfig.heightMultiplier,
                                    minWidth: double.infinity,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.8 *
                                                SizeConfig
                                                    .imageSizeMultiplier))),
                                    color: MyColors.primaryColor,
                                    elevation: 0.0,
                                    highlightElevation: 0.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  double _timeOfDayToDouble(TimeOfDay tod) => tod.hour + tod.minute / 60.0;
  String _doubleToTimeOfDayString(num time) {
    String doubleAsString = time.toString();
    int indexOfDecimal = doubleAsString.indexOf(".");
    int hour = indexOfDecimal == -1
        ? int.parse(doubleAsString)
        : int.parse(doubleAsString.substring(0, indexOfDecimal));
    double mins = indexOfDecimal == -1
        ? 0
        : double.parse(
            (double.parse(doubleAsString.substring(indexOfDecimal)) * 60)
                .toStringAsFixed(2));
    TimeOfDay tod = TimeOfDay(hour: hour, minute: mins.toInt());
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(tod);
  }

  TimeOfDay _doubleToTimeOfDay(num time) {
    String doubleAsString = time.toString();
    int indexOfDecimal = doubleAsString.indexOf(".");
    int hour = indexOfDecimal == -1
        ? int.parse(doubleAsString)
        : int.parse(doubleAsString.substring(0, indexOfDecimal));
    double mins = indexOfDecimal == -1
        ? 0
        : double.parse(
            (double.parse(doubleAsString.substring(indexOfDecimal)) * 60)
                .toStringAsFixed(2));
    TimeOfDay tod = TimeOfDay(hour: hour, minute: mins.toInt());

    return tod;
  }

  String arrayToString(List list) {
    String myString = "";
    list.forEach((value) {
      myString = myString + value.toString() + ",";
    });
    return myString.substring(0, myString.length - 1);
  }
}
