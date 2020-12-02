import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class ImageUtils {
  static String logo = "assets/logo.png";
  static String appName = "assets/app_name.png";
  static String facebookIcon = "assets/facebook.png";
  static String googleIcon = "assets/google_icon.png";
  static String twitterIcon = "assets/twitter.png";
  static String snapchatIcon = "assets/snapchat.png";
  static String instagramIcon = "assets/instagram.png";
  static String nextArrow = "assets/next_arrow.png";
  static String doctorIcon = "assets/veterinary.png";
  static String starsIcon = "assets/star_icon.png";
  static String requestIcon = "assets/waze.png";
  static String requestsIcon = "assets/mobile.png";
  static String blogIcon = "assets/blog.png";
  static String aboutIcon = "assets/about.png";
  static String walletIcon = "assets/wallet.png";
  static String certificateIcon = "assets/certi.png";
  static String crossIcon = "assets/clear.png";
  static String filterIcon = "assets/filter.png";
  static String markerIcon = "assets/marker.png";
  static Future<Uint8List> getBytesFromAsset(String path, double width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width.round());
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
