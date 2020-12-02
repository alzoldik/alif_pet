import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData extends ChangeNotifier {
  String _token ;
  String _userType;
  String get getToken => _token!=null? _token: null;
  String get getUserType => _userType!=null?_userType:null;
  readUserData(SharedPreferences prefs) async {
    var tokenData = prefs.getString("token");
    var userTypeData = prefs.getString("type");
    _token = tokenData!=null? tokenData :null;
    _userType = userTypeData!=null? userTypeData :null;
  }
  save(token,type) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token",token);
    prefs.setString("type", type);
    _token = token;
    _userType = type;
    notifyListeners();
  }

  remove() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("type");
    _token = null;
    _userType = null;
    notifyListeners();
  }
}