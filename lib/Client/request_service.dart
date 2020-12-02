import 'dart:async';
import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Apis/client_apis.dart';
import 'package:alif_pet/Common/my_loader.dart';
import 'package:alif_pet/Utils/string_utils.dart';
import 'package:alif_pet/models/request_service_for_chat.dart';
import 'package:alif_pet/models/request_service_for_visit.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:alif_pet/Common/app_background.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/constants.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/Utils/toast_utils.dart';
import 'package:alif_pet/models/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class RequestService extends StatefulWidget {
  final Profile doctor;
  final int serviceId;
  final String method;
  const RequestService({Key key, this.doctor, this.serviceId, this.method})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RequestServiceState();
  }
}

class RequestServiceState extends State<RequestService> {
  final descriptionController = TextEditingController();
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Constants.kGoogleApiKey);
  var method = "chat", when, address = "";
  DateTime selectedDate;
  String selectedTimeSlot;
  dynamic selectedTimeSlotValue;
  bool shouldShowTimeSlot = false;
  bool isEnglish, isReady, isRequesting = false;
  List<DropdownMenuItem<dynamic>> timeSlotItems = List();
  Map<String, dynamic> timeSlotsMap = Map();
  Map<String, dynamic> requestMap = Map();
  Completer<GoogleMapController> _controller = Completer();
  Position currentLocation;
  double serviceLat, serviceLong;
  Set<Marker> markers;
  BitmapDescriptor mapIcon;
  var searchController = TextEditingController();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );

  CameraPosition currentLocationPos;
  void openDatePicker() async {
    selectedDate = await showRoundedDatePicker(
      context: context,
      fontFamily: FontUtils.ceraProMedium,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      borderRadius: 1.5 * SizeConfig.imageSizeMultiplier,
      theme: ThemeData(primarySwatch: CommonUtils.getPrimaryColor()),
    );
    if (selectedDate != null) {
      shouldShowTimeSlot = true;
      requestMap.update(
          "date", (value) => DateFormat("yyyy-MM-dd").format(selectedDate));
      getTimeSlots();
    } else {
      when = null;
    }
    setState(() {});
  }

  void setChatSlots() {
    timeSlotItems = timeSlotsMap.values
        .map((slotValue) => DropdownMenuItem<dynamic>(
            value: slotValue,
            child: Container(
              margin: EdgeInsets.only(left: 1.5 * SizeConfig.widthMultiplier),
              child: Text(
                isEnglish ? slotValue['en'] : slotValue['ar'],
                style: TextStyle(
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  fontFamily: FontUtils.ceraProMedium,
                  color: MyColors.primaryColor,
                ),
              ),
            )))
        .toList();
    selectedTimeSlotValue = timeSlotsMap.values.toList()[0];
  }

  void getTimeSlots() {
    CommonUtils.checkInternet().then((isInternet) {
      if (isInternet) {
        if (method == "chat") {
          ClientApis()
              .getChatTimeSlots(requestMap, isEnglish)
              .then((chatSlots) {
            if (chatSlots is String) {
              ToastUtils.showCustomToast(
                  context, chatSlots, Colors.white, MyColors.primaryColor);
              selectedDate = null;
              when = null;
              shouldShowTimeSlot = false;
              setState(() {});
            } else {
              timeSlotsMap = chatSlots;
              setChatSlots();
              setState(() {});
            }
          });
        } else {
          ClientApis()
              .getVisitTimeSlots(requestMap, isEnglish)
              .then((chatSlots) {
            if (chatSlots is String) {
              ToastUtils.showCustomToast(
                  context, chatSlots, Colors.white, MyColors.primaryColor);
              selectedDate = null;
              when = null;
              shouldShowTimeSlot = false;
              setState(() {});
            } else {
              timeSlotsMap = chatSlots;
              setChatSlots();
              setState(() {});
            }
          });
        }
      } else {}
    });
  }

  void openMapAndShowResults() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: Constants.kGoogleApiKey,
        mode: Mode.overlay,
        language: isEnglish ? "en" : "ar",
        components: [
          Component(Component.country, "sa"),
          Component(Component.country, "ae")
        ]);
    if (p != null) {
      final GoogleMapController controller = await _controller.future;
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      serviceLat = detail.result.geometry.location.lat;
      serviceLong = detail.result.geometry.location.lng;
      ImageUtils.getBytesFromAsset(
              ImageUtils.markerIcon, 20 * SizeConfig.imageSizeMultiplier)
          .then((icon) {
        markers.clear();
        markers.add(Marker(
            icon: BitmapDescriptor.fromBytes(icon),
            markerId: MarkerId('1'),
            position: LatLng(serviceLat, serviceLong)));
        CameraPosition searchedLocationPos = CameraPosition(
            bearing: 90.0,
            target: LatLng(serviceLat, serviceLong),
            tilt: 0,
            zoom: 20.0);
        controller
            .animateCamera(CameraUpdate.newCameraPosition(searchedLocationPos));
        searchController.text = detail.result.formattedAddress;
        setState(() {});
      });
    }
  }

  void getCurrentLocation() async {
    currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    serviceLat = currentLocation.latitude;
    serviceLong = currentLocation.longitude;
    //PlaceForId detail = await CommonApis().getPlaceId(serviceLat,serviceLong);
    markers.clear();
    ImageUtils.getBytesFromAsset(
            ImageUtils.markerIcon, 20 * SizeConfig.imageSizeMultiplier)
        .then((icon) async {
      markers.add(Marker(
          icon: BitmapDescriptor.fromBytes(icon),
          markerId: MarkerId('1'),
          position:
              LatLng(currentLocation.latitude, currentLocation.longitude)));
      currentLocationPos = CameraPosition(
          bearing: 90.0,
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          tilt: 0,
          zoom: 20.0);

      setState(() {});
      final GoogleMapController controller = await _controller.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(currentLocationPos));
    });
  }

  void requestService() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        isRequesting = true;
        setState(() {});
        if (method == "chat") {
          Request_service_for_chat rsforChat = Request_service_for_chat();
          rsforChat.doctorId = widget.doctor.id;
          rsforChat.serviceId = widget.serviceId;
          rsforChat.date = DateFormat("yyyy-MM-dd").format(selectedDate);
          rsforChat.timeSlot = selectedTimeSlot;
          rsforChat.description = descriptionController.text;
          ClientApis()
              .requestService(rsforChat.toJson(), isEnglish)
              .then((result) {
            if (result is String) {
              isRequesting = false;
              ToastUtils.showCustomToast(
                  context, result, Colors.white, MyColors.primaryColor);
              setState(() {});
            } else if (result is bool && result) {
              ToastUtils.showCustomToast(
                  context,
                  "Successfully Requested Service",
                  Colors.white,
                  MyColors.primaryColor);
              Navigator.pop(context);
            }
          });
        } else {
          Request_service_for_visit rsforVisit = Request_service_for_visit();
          rsforVisit.doctorId = widget.doctor.id;
          rsforVisit.serviceId = widget.serviceId;
          rsforVisit.date = DateFormat("yyyy-MM-dd").format(selectedDate);
          rsforVisit.timeSlot = selectedTimeSlot;
          rsforVisit.description = descriptionController.text;
          rsforVisit.address = searchController.text;
          rsforVisit.latitude = serviceLat;
          rsforVisit.longitude = serviceLong;
          ClientApis()
              .requestService(rsforVisit.toJson(), isEnglish)
              .then((result) {
            if (result is String) {
              isRequesting = false;
              ToastUtils.showCustomToast(
                  context, result, Colors.white, MyColors.primaryColor);
              setState(() {});
            } else if (result is bool && result) {
              ToastUtils.showCustomToast(
                  context,
                  "Successfully Requested Service",
                  Colors.white,
                  MyColors.primaryColor);
              Navigator.pop(context);
            }
          });
        }
      } else {
        ToastUtils.showCustomToast(context, StringUtils.noInternet,
            Colors.white, MyColors.primaryColor);
      }
    });
  }

  void isReadyToRequest() {
    isReady = (when == "visit"
        ? (selectedDate != null &&
                selectedTimeSlotValue != null &&
                descriptionController.text.length > 0 &&
                address != null &&
                serviceLat != null &&
                serviceLong != null &&
                !isRequesting)
            ? true
            : false
        : (selectedDate != null &&
                selectedTimeSlotValue != null &&
                descriptionController.text.length > 0 &&
                !isRequesting)
            ? true
            : false);
  }

  @override
  void initState() {
    markers = Set.from([]);
    method = widget.method;
    getCurrentLocation();
    requestMap = {"doctor_id": widget.doctor.id, "date": ""};
    descriptionController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    isEnglish = CommonUtils.getLanguage(context) == "english";
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    isReadyToRequest();
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
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
                        CommonUtils.translate(context, "request_service"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProBold,
                            fontSize: 2.9 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                      ),
                    ),
                    /*      Container(
                        alignment: CommonUtils.getLanguage(context)=="english"?Alignment.centerRight:Alignment.centerLeft,
                        margin: CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(right: 11.5*SizeConfig.widthMultiplier) : EdgeInsets.only(left: 11.5*SizeConfig.widthMultiplier),
                        child: InkWell(onTap:(){
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SearchFilter()));
                        },child: ImageIcon(AssetImage(ImageUtils.filter_icon),color: MyColors.primaryColor,size: 5*SizeConfig.imageSizeMultiplier,))
                    ),*/
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
            Column(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: 11.5 * SizeConfig.heightMultiplier),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Hero(
                          tag: widget.doctor.id,
                          child: Container(
                            height: 23 * SizeConfig.imageSizeMultiplier,
                            width: 23 * SizeConfig.imageSizeMultiplier,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius:
                                          3.5 * SizeConfig.imageSizeMultiplier,
                                      spreadRadius: 0.0,
                                      offset: Offset(2, 6.0)),
                                ],
                                color: Colors.white),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
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
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 2.5 * SizeConfig.heightMultiplier),
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
                      //   itemSize: 2.5 * SizeConfig.imageSizeMultiplier,
                      //   initialRating: widget.doctor.rating == null
                      //       ? 0
                      //       : widget.doctor.rating.toDouble(),
                      //   minRating: 0,
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
                        itemSize: 2.5 * SizeConfig.imageSizeMultiplier,
                        initialRating: widget.doctor.rating == null
                            ? 0
                            : widget.doctor.rating.toDouble(),
                        minRating: 0,
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
                        margin: CommonUtils.getLanguage(context) == "english"
                            ? EdgeInsets.only(
                                left: 1.5 * SizeConfig.widthMultiplier)
                            : EdgeInsets.only(
                                right: 1.5 * SizeConfig.widthMultiplier),
                        child: Text(
                          "(${widget.doctor.rating})",
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
                              margin:
                                  CommonUtils.getLanguage(context) == "english"
                                      ? EdgeInsets.only(
                                          right: 3 * SizeConfig.widthMultiplier)
                                      : EdgeInsets.only(
                                          left: 3 * SizeConfig.widthMultiplier),
                              alignment: Alignment.center,
                              width: 17 * SizeConfig.widthMultiplier,
                              height: 6 * SizeConfig.heightMultiplier,
                              decoration: BoxDecoration(
                                color: method == "chat"
                                    ? MyColors.primaryColor
                                    : Colors.transparent,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    3 * SizeConfig.imageSizeMultiplier)),
                                border: Border.all(
                                    color: method == "chat"
                                        ? MyColors.primaryColor
                                        : Colors.red,
                                    width: .7),
                              ),
                              child: Text(
                                CommonUtils.translate(context, "chat"),
                                style: TextStyle(
                                    color: method == "chat"
                                        ? Colors.white
                                        : MyColors.primaryColor,
                                    fontSize: 1.85 * SizeConfig.textMultiplier,
                                    fontFamily: FontUtils.ceraProBold),
                                overflow: TextOverflow.ellipsis,
                              ))),
                      Flexible(
                          flex: 1,
                          child: Container(
                              margin: CommonUtils.getLanguage(context) ==
                                      "english"
                                  ? EdgeInsets.only(
                                      left: 3 * SizeConfig.widthMultiplier)
                                  : EdgeInsets.only(
                                      right: 3 * SizeConfig.widthMultiplier),
                              alignment: Alignment.center,
                              width: 17 * SizeConfig.widthMultiplier,
                              height: 6 * SizeConfig.heightMultiplier,
                              decoration: BoxDecoration(
                                color: method == "visit"
                                    ? MyColors.primaryColor
                                    : Colors.transparent,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    3 * SizeConfig.imageSizeMultiplier)),
                                border: Border.all(
                                    color: method == "visit"
                                        ? MyColors.primaryColor
                                        : Colors.red,
                                    width: .7),
                              ),
                              child: Text(
                                CommonUtils.translate(context, "visit"),
                                style: TextStyle(
                                    color: method == "visit"
                                        ? Colors.white
                                        : MyColors.primaryColor,
                                    fontSize: 1.85 * SizeConfig.textMultiplier,
                                    fontFamily: FontUtils.ceraProBold),
                                overflow: TextOverflow.ellipsis,
                              )))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier),
                  height: .7,
                  width: ScreenUtil.getInstance().width.toDouble(),
                  color: MyColors.red.withOpacity(.5),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil.getInstance().width.toDouble(),
                          height: 6 * SizeConfig.heightMultiplier,
                          margin: EdgeInsets.only(
                              top: 1.5 * SizeConfig.heightMultiplier),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  margin: CommonUtils.getLanguage(context) ==
                                          "english"
                                      ? EdgeInsets.only(
                                          left:
                                              5.5 * SizeConfig.widthMultiplier)
                                      : EdgeInsets.only(
                                          right:
                                              5.5 * SizeConfig.widthMultiplier),
                                  alignment: CommonUtils.getLanguage(context) ==
                                          "english"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        CommonUtils.translate(context, "time"),
                                        style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize: 2.15 *
                                                SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      selectedDate == null
                                          ? Container()
                                          : Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 5.5 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          child: Text(
                                                            DateFormat(
                                                                    "EEE,MMM yy")
                                                                .format(
                                                                    selectedDate),
                                                            style: TextStyle(
                                                              fontFamily: FontUtils
                                                                  .ceraProMedium,
                                                              fontSize: 2.15 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              color: MyColors
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        )),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons.cancel,
                                                            color: MyColors
                                                                .primaryColor,
                                                            size: 7 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                          ),
                                                          onPressed: () {
                                                            selectedDate = null;
                                                            when = null;
                                                            shouldShowTimeSlot =
                                                                false;
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ],
                                  )),
                              Container(
                                  alignment: Alignment.center,
                                  child: selectedDate == null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                                flex: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (when != "now") {
                                                        when = "now";
                                                        shouldShowTimeSlot =
                                                            true;
                                                        selectedDate =
                                                            DateTime.now();
                                                        requestMap.update(
                                                            "date",
                                                            (value) => DateFormat(
                                                                    "yyyy-MM-dd")
                                                                .format(
                                                                    selectedDate));
                                                        getTimeSlots();
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                      margin: CommonUtils
                                                                  .getLanguage(
                                                                      context) ==
                                                              "english"
                                                          ? EdgeInsets.only(
                                                              right: 3 *
                                                                  SizeConfig
                                                                      .widthMultiplier)
                                                          : EdgeInsets.only(
                                                              left: 3 *
                                                                  SizeConfig
                                                                      .widthMultiplier),
                                                      alignment:
                                                          Alignment.center,
                                                      width: 17 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                      height: 6 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      decoration: BoxDecoration(
                                                        color: when == "now"
                                                            ? MyColors
                                                                .primaryColor
                                                            : Colors
                                                                .transparent,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(3 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier)),
                                                        border: Border.all(
                                                            color: when == "now"
                                                                ? MyColors
                                                                    .primaryColor
                                                                : Colors.red,
                                                            width: .7),
                                                      ),
                                                      child: Text(
                                                        CommonUtils.translate(
                                                            context, "now"),
                                                        style: TextStyle(
                                                            color: when == "now"
                                                                ? Colors.white
                                                                : MyColors
                                                                    .primaryColor,
                                                            fontSize: 1.85 *
                                                                SizeConfig
                                                                    .textMultiplier,
                                                            fontFamily: FontUtils
                                                                .ceraProBold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                )),
                                            Flexible(
                                                flex: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (when != "later") {
                                                        when = "later";
                                                        openDatePicker();
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                      margin: CommonUtils
                                                                  .getLanguage(
                                                                      context) ==
                                                              "english"
                                                          ? EdgeInsets.only(
                                                              left: 3 *
                                                                  SizeConfig
                                                                      .widthMultiplier)
                                                          : EdgeInsets
                                                              .only(
                                                                  right: 3 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                      alignment:
                                                          Alignment.center,
                                                      width: CommonUtils
                                                                  .getLanguage(
                                                                      context) ==
                                                              "english"
                                                          ? 17 *
                                                              SizeConfig
                                                                  .widthMultiplier
                                                          : 31 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                      height: 6 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      decoration: BoxDecoration(
                                                        color: when == "later"
                                                            ? MyColors
                                                                .primaryColor
                                                            : Colors
                                                                .transparent,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(3 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier)),
                                                        border: Border.all(
                                                            color: when ==
                                                                    "later"
                                                                ? MyColors
                                                                    .primaryColor
                                                                : Colors.red,
                                                            width: .7),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.date_range,
                                                            color: when ==
                                                                    "later"
                                                                ? Colors.white
                                                                : MyColors
                                                                    .primaryColor,
                                                            size: 5 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                          ),
                                                          Container(
                                                            margin: CommonUtils
                                                                        .getLanguage(
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
                                                              CommonUtils
                                                                  .translate(
                                                                      context,
                                                                      "later"),
                                                              style: TextStyle(
                                                                  color: when ==
                                                                          "later"
                                                                      ? Colors
                                                                          .white
                                                                      : MyColors
                                                                          .primaryColor,
                                                                  fontSize: 1.85 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontFamily:
                                                                      FontUtils
                                                                          .ceraProBold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                ))
                                          ],
                                        )
                                      : Container()),
                            ],
                          ),
                        ),
                        shouldShowTimeSlot
                            ? AnimatedContainer(
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                height: 10.5 * SizeConfig.heightMultiplier,
                                margin: EdgeInsets.only(
                                    top: 1.5 * SizeConfig.heightMultiplier),
                                duration: Duration(milliseconds: 550),
                                curve: Curves.easeOut,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: CommonUtils.getLanguage(
                                                  context) ==
                                              "english"
                                          ? EdgeInsets.only(
                                              left: 5.5 *
                                                  SizeConfig.widthMultiplier)
                                          : EdgeInsets.only(
                                              right: 5.5 *
                                                  SizeConfig.widthMultiplier),
                                      alignment:
                                          CommonUtils.getLanguage(context) ==
                                                  "english"
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                      child: Text(
                                        CommonUtils.translate(
                                            context, "time_slot"),
                                        style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize: 2.15 *
                                                SizeConfig.textMultiplier,
                                            color: MyColors.primaryColor,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                    Container(
                                      width: ScreenUtil.getInstance()
                                          .width
                                          .toDouble(),
                                      height: 6 * SizeConfig.heightMultiplier,
                                      margin: EdgeInsets.only(
                                          top: 1 * SizeConfig.heightMultiplier,
                                          left:
                                              6.5 * SizeConfig.widthMultiplier,
                                          right:
                                              6.5 * SizeConfig.widthMultiplier),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            color: MyColors.red.withOpacity(.5),
                                            width: 2),
                                        borderRadius: BorderRadius.circular(
                                            2.8 *
                                                SizeConfig.imageSizeMultiplier),
                                      ),
                                      child: DropdownButton<dynamic>(
                                        onChanged: (dynamic value) {
                                          int index;
                                          selectedTimeSlotValue = value;
                                          index = timeSlotsMap.values
                                              .toList()
                                              .indexOf(selectedTimeSlotValue);
                                          selectedTimeSlot = timeSlotsMap
                                              .entries
                                              .toList()[index]
                                              .key;
                                          setState(() {});
                                        },
                                        value: selectedTimeSlotValue == null
                                            ? null
                                            : selectedTimeSlotValue,
                                        items: timeSlotItems.length > 0
                                            ? timeSlotItems
                                            : null,
                                        isExpanded: true,
                                        underline: Container(),
                                        icon: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 6 *
                                                SizeConfig.imageSizeMultiplier,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2 * SizeConfig.heightMultiplier),
                          height: .7,
                          width: ScreenUtil.getInstance().width.toDouble(),
                          color: MyColors.red.withOpacity(.5),
                        ),
                        Container(
                          margin: CommonUtils.getLanguage(context) == "english"
                              ? EdgeInsets.only(
                                  top: 1.5 * SizeConfig.heightMultiplier,
                                  left: 5.5 * SizeConfig.widthMultiplier)
                              : EdgeInsets.only(
                                  right: 5.5 * SizeConfig.widthMultiplier),
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Text(
                            CommonUtils.translate(context, "description") + ":",
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProBold,
                                fontSize: 2.15 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 3.5 * SizeConfig.heightMultiplier,
                              right: 7.5 * SizeConfig.widthMultiplier,
                              left: 7.5 * SizeConfig.widthMultiplier),
                          height: 13 * SizeConfig.heightMultiplier,
                          width: ScreenUtil.getInstance().width.toDouble(),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(
                                3 * SizeConfig.imageSizeMultiplier)),
                            border: Border.all(color: Colors.red, width: .7),
                          ),
                          child: TextFormField(
                            controller: descriptionController,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            autofocus: false,
                            style: TextStyle(
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                              fontFamily: FontUtils.ceraProRegular,
                              color: MyColors.primaryColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 1 * SizeConfig.heightMultiplier,
                                  horizontal: 1 * SizeConfig.widthMultiplier),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                        ),
                        method == "visit"
                            ? Container(
                                margin: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? EdgeInsets.only(
                                        top: 1.5 * SizeConfig.heightMultiplier,
                                        left: 5.5 * SizeConfig.widthMultiplier)
                                    : EdgeInsets.only(
                                        right:
                                            5.5 * SizeConfig.widthMultiplier),
                                alignment: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Text(
                                  CommonUtils.translate(context, "address") +
                                      ":",
                                  style: TextStyle(
                                      fontFamily: FontUtils.ceraProBold,
                                      fontSize:
                                          2.15 * SizeConfig.textMultiplier,
                                      color: MyColors.primaryColor,
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            : Container(),
                        method == "visit"
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: 3.5 * SizeConfig.heightMultiplier,
                                    right: 7.5 * SizeConfig.widthMultiplier,
                                    left: 7.5 * SizeConfig.widthMultiplier),
                                height: 5 * SizeConfig.heightMultiplier,
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                child: TextFormField(
                                  controller: searchController,
                                  onTap: openMapAndShowResults,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textAlign: TextAlign.start,
                                  autofocus: false,
                                  style: TextStyle(
                                    fontSize: 2.2 * SizeConfig.textMultiplier,
                                    fontFamily: FontUtils.ceraProRegular,
                                    color: MyColors.primaryColor,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical:
                                            1 * SizeConfig.heightMultiplier,
                                        horizontal:
                                            2 * SizeConfig.widthMultiplier),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: .7),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.5 *
                                              SizeConfig.imageSizeMultiplier)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: .7),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.5 *
                                              SizeConfig.imageSizeMultiplier)),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        method == "visit"
                            ? Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: 3.5 * SizeConfig.heightMultiplier,
                                    right: 7.5 * SizeConfig.widthMultiplier,
                                    left: 7.5 * SizeConfig.widthMultiplier),
                                height: 28 * SizeConfig.heightMultiplier,
                                width:
                                    ScreenUtil.getInstance().width.toDouble(),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2.5 *
                                          SizeConfig.imageSizeMultiplier)),
                                  border:
                                      Border.all(color: Colors.red, width: .7),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    serviceLat != null && serviceLong != null
                                        ? Padding(
                                            padding: EdgeInsets.all(2.2),
                                            child: GoogleMap(
                                              mapType: MapType.normal,
                                              initialCameraPosition:
                                                  _kGooglePlex,
                                              onMapCreated: (GoogleMapController
                                                  controller) {
                                                _controller
                                                    .complete(controller);
                                              },
                                              markers: markers,
                                            ),
                                          )
                                        : MyLoader(
                                            containerSize: 15 *
                                                SizeConfig.imageSizeMultiplier),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        onPressed: () async {
                                          final GoogleMapController controller =
                                              await _controller.future;
                                          controller.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                  currentLocationPos));
                                        },
                                        icon: Icon(
                                          Icons.my_location,
                                          color: MyColors.primaryColor,
                                          size: 7.5 *
                                              SizeConfig.imageSizeMultiplier,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(
                              top: 6.5 * SizeConfig.heightMultiplier,
                              bottom: 2.5 * SizeConfig.heightMultiplier),
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
                                        CommonUtils.translate(context, "next"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                2.3 * SizeConfig.textMultiplier,
                                            fontFamily: FontUtils.ceraProBold)),
                                    /*          final result = await Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: ChatScreen()));
                                      if (result) {
                                        Timer(Duration(milliseconds: 150), () {
                                          FlutterStatusbarcolor
                                              .setStatusBarColor(Colors.white);
                                          FlutterStatusbarcolor
                                              .setStatusBarWhiteForeground(
                                                  false);
                                        });
                                      }*/
                                    onPressed: isReady ? requestService : null,
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
                                        CommonUtils.translate(
                                            context, "cancel"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                2.3 * SizeConfig.textMultiplier,
                                            fontFamily: FontUtils.ceraProBold)),
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
          ],
        ),
      ),
    );
  }
}
