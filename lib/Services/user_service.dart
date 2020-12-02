import 'package:alif_pet/Apis/common_apis.dart';
import 'package:alif_pet/models/index.dart';
import 'package:flutter/material.dart';

class UserService with ChangeNotifier {
  Profile _profile;
  bool isLoading;
  Future<dynamic> getProfile() async {
    await CommonApis().getProfile().then((value) {
      if (value is Profile) {
        _profile = value;
        notifyListeners();
      }
    });
  }

  Profile get profile {
    return _profile;
  }
}
