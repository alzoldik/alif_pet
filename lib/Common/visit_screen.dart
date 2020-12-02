import 'dart:async';
import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Common/my_loader.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/constants.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/Utils/userData.dart';
import 'package:alif_pet/models/request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class VisitScreen extends StatefulWidget {
  final Request request;
  final UserData userData;
  const VisitScreen({Key key, this.request, this.userData}) : super(key: key);
  @override
  _VisitScreenState createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen> {
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  StreamSubscription<LocationData> locationStream;
  Set<Marker> markers;
  bool isLoading = true;
  double distance;
  Location currentLocation = new Location();
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );
/*  void getCurrentLocation() async{

    currentLocation =  await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    serviceLat = currentLocation.latitude;
    serviceLong = currentLocation.longitude;
    //PlaceForId detail = await CommonApis().getPlaceId(serviceLat,serviceLong);
    markers.clear();
    ImageUtils.getBytesFromAsset(ImageUtils.marker_icon, 20*SizeConfig.imageSizeMultiplier).then((icon) async{
      markers.add(Marker(icon: BitmapDescriptor.fromBytes(icon),markerId: MarkerId('1'), position: LatLng(currentLocation.latitude,currentLocation.longitude)));
      currentLocationPos =  CameraPosition(
          bearing: 90.0,
          target: LatLng(currentLocation.latitude,currentLocation.longitude),
          tilt: 0,
          zoom: 20.0);

      setState(() {});
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(currentLocationPos));
    });
  }*/
  setPolylines(double sourceLat, double sourceLong) async {
    _polylines.clear();
    try {
      List<PointLatLng> result =
          await polylinePoints.getRouteBetweenCoordinates(
              Constants.kGoogleApiKey,
              sourceLat,
              sourceLong,
              widget.request.latitude,
              widget.request.longitude);
      if (result != null && result.isNotEmpty) {
        result.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly_line"),
          color: Colors.red,
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    } catch (e) {
      print(e.toString());
    }
  }

  loadMarker(double lat, double long, String id) {
    ImageUtils.getBytesFromAsset(
            ImageUtils.markerIcon, 20 * SizeConfig.imageSizeMultiplier)
        .then((icon) {
      markers.add(Marker(
          icon: BitmapDescriptor.fromBytes(icon),
          markerId: MarkerId(id),
          position: LatLng(lat, long)));
    });
  }

  void getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    //LocationData _locationData;

    _serviceEnabled = await currentLocation.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await currentLocation.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await currentLocation.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await currentLocation.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    //_locationData = await currentLocation.getLocation();
    Future.delayed(Duration(seconds: 2)).then((value) async {
      isLoading = false;
      setState(() {});
      locationStream = currentLocation
          .onLocationChanged()
          .listen((LocationData currentLocation) async {
        if (_controller.isCompleted) {
          loadMarker(currentLocation.latitude, currentLocation.longitude, "2");

          CameraPosition currentLocationPos = CameraPosition(
              bearing: 0.0,
              target:
                  LatLng(currentLocation.latitude, currentLocation.longitude),
              tilt: 0,
              zoom: 15.0);
          distance = await Geolocator().distanceBetween(
              currentLocation.latitude,
              currentLocation.longitude,
              widget.request.latitude,
              widget.request.longitude);
          final GoogleMapController controller = await _controller.future;

          if (mounted) {
            try {
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(currentLocationPos));
            } on MissingPluginException catch (e) {
              print(e.toString());
            }
            setPolylines(currentLocation.latitude, currentLocation.longitude);
            setState(() {});
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Container(
              width: ScreenUtil.getInstance().width.toDouble(),
              height: ScreenUtil.getInstance().height.toDouble(),
              margin: EdgeInsets.only(
                  bottom: 11.5 * SizeConfig.heightMultiplier,
                  top: 14.5 * SizeConfig.heightMultiplier),
              child: isLoading
                  ? MyLoader()
                  : GoogleMap(
                      mapType: MapType.normal,
                      polylines: _polylines,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: markers,
                    ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 10,
                  color: MyColors.primaryColor,
                )),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: MyColors.primaryColor,
                height: 14.5 * SizeConfig.heightMultiplier,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.topLeft
                          : Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 2 * SizeConfig.heightMultiplier),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          icon: Icon(
                            Icons.keyboard_backspace,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.topLeft
                          : Alignment.topLeft,
                      child: Hero(
                        tag: widget.request.id,
                        child: Container(
                          margin: CommonUtils.getLanguage(context) == "english"
                              ? EdgeInsets.only(
                                  left: 12 * SizeConfig.widthMultiplier,
                                  top: 2 * SizeConfig.heightMultiplier,
                                )
                              : EdgeInsets.only(
                                  right: 12 * SizeConfig.widthMultiplier,
                                  top: 2 * SizeConfig.heightMultiplier,
                                ),
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
                            child: widget.userData.getUserType == "client"
                                ? widget.request.doctor.photo == null
                                    ? Image.asset(
                                        ImageUtils.doctorIcon,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        ApiUtils.BaseApiUrlMain +
                                            widget.request.doctor.photo,
                                        fit: BoxFit.contain,
                                      )
                                : widget.request.client.photo == null
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
                    ),
                    Align(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.topLeft
                          : Alignment.topLeft,
                      child: Container(
                        margin: CommonUtils.getLanguage(context) == "english"
                            ? EdgeInsets.only(
                                left: 24 * SizeConfig.widthMultiplier,
                                top: 3 * SizeConfig.heightMultiplier)
                            : EdgeInsets.only(
                                right: 24 * SizeConfig.widthMultiplier,
                                top: 3 * SizeConfig.heightMultiplier),
                        child: Text(
                          widget.userData.getUserType == "client"
                              ? widget.request.doctor.name
                              : widget.request.client.name,
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProMedium,
                              fontSize: 2.1 * SizeConfig.textMultiplier,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Align(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.topLeft
                          : Alignment.topLeft,
                      child: Container(
                        margin: CommonUtils.getLanguage(context) == "english"
                            ? EdgeInsets.only(
                                left: 12 * SizeConfig.widthMultiplier,
                                top: 16 * SizeConfig.imageSizeMultiplier)
                            : EdgeInsets.only(
                                right: 24 * SizeConfig.widthMultiplier,
                                top: 16 * SizeConfig.imageSizeMultiplier),
                        child: Text(
                          widget.request.address,
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProMedium,
                              fontSize: 2.1 * SizeConfig.textMultiplier,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 11.5 * SizeConfig.heightMultiplier,
                  width: ScreenUtil.getInstance().width.toDouble(),
                  color: MyColors.primaryColor,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: CommonUtils.getLanguage(context) == "english"
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          margin: CommonUtils.getLanguage(context) == "english"
                              ? EdgeInsets.only(
                                  left: 5 * SizeConfig.widthMultiplier)
                              : EdgeInsets.only(
                                  right: 5 * SizeConfig.widthMultiplier),
                          child: Text(
                            distance == null ? "..." : "($distance m)",
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProMedium,
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Align(
                        alignment: CommonUtils.getLanguage(context) == "english"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: CommonUtils.getLanguage(context) == "english"
                              ? EdgeInsets.only(
                                  right: 5 * SizeConfig.widthMultiplier)
                              : EdgeInsets.only(
                                  left: 5 * SizeConfig.widthMultiplier),
                          child: Text(
                            CommonUtils.translate(context, "start"),
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProMedium,
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: MyColors.red),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 14 * SizeConfig.imageSizeMultiplier,
                    height: 14 * SizeConfig.imageSizeMultiplier,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Center(
                      child: Icon(
                        Icons.my_location,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 2 * SizeConfig.heightMultiplier,
                        bottom: 8.5 * SizeConfig.heightMultiplier,
                        right: 4 * SizeConfig.widthMultiplier),
                    width: 14 * SizeConfig.imageSizeMultiplier,
                    height: 14 * SizeConfig.imageSizeMultiplier,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: MyColors.dark_red),
                    child: Center(
                      child: Icon(
                        Icons.near_me,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    locationStream.cancel();
    super.dispose();
  }

  @override
  void initState() {
    markers = Set.from([]);
    loadMarker(widget.request.latitude, widget.request.longitude, "1");
    getCurrentLocation();
    Future.delayed(Duration(milliseconds: 90)).then((done) {
      FlutterStatusbarcolor.setStatusBarColor(MyColors.primaryColor);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    });
    super.initState();
  }
}
