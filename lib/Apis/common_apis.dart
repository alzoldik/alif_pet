import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Common/splash_screen.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/constants.dart';
import 'package:alif_pet/Utils/userData.dart';
import 'package:alif_pet/models/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

import '../models/index.dart';
import '../models/message.dart';

class CommonApis {
  Future<dynamic> getMobileCode(dynamic data, bool isEnglish) async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/get_mobile_code",
          data: data,
          options: Options(headers: ApiUtils.normalHeader));
      if (response.statusCode == 200) {
        Map<String, dynamic> codeData = Map();
        codeData.putIfAbsent(
            "code",
            () => response.data
                .toString()
                .split("mobile_verification_code: ")[1]
                .substring(0, 5));
        return codeData;
      } else {
        return isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> login(dynamic data) async {
    try {
      Response response =
          await Dio().post("${ApiUtils.BaseApiUrl}/login", data: data);
      if (response.statusCode == 200) {
        Map<String, dynamic> loginData = response.data;
        return LoginResponse.fromJson(loginData);
      } else {
        return response.data;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> getCountries() async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/get_countries",
          options: Options(headers: ApiUtils.normalHeader));
      List countriesData = response.data['countries'];
      List<Country> countries = [];
      for (int i = 0; i < countriesData.length; i++) {
        countries.add(Country.fromJson(countriesData[i]));
      }
      return countries;
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> getRequests(bool isEnglish) async {
    try {
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/my_requests",
          options: Options(headers: ApiUtils.headerWithToken));
      if (response.statusCode == 200) {
        List requestsData = response.data['requests'];
        List<Request> requests = [];
        for (int i = 0; i < requestsData.length; i++) {
          requests.add(Request.fromJson(requestsData[i]));
        }
        return requests;
      } else {
        return isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> getMessages(dynamic data, bool isEnglish) async {
    try {
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/get_chat",
          data: data, options: Options(headers: ApiUtils.headerWithToken));
      if (response.statusCode == 200) {
        List messagesData = response.data['messages'];
        List<Message> messages = [];
        if (messagesData.length > 0) {
          messagesData = messagesData.reversed.toList();

          messagesData.forEach((message) {
            messages.add(Message.fromJson(message));
          });
        }
        return messages;
      } else {
        return isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> sendMessage(dynamic data, bool isEnglish) async {
    try {
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/send_chat",
          data: data, options: Options(headers: ApiUtils.headerWithToken));
      if (response.statusCode == 200) {
        /*       List messagesData = response.data['messages'];
        List<Message> messages = [];
        messagesData.forEach((message){
          messages.add(Message.fromJson(message));
        });*/
        return true;
      } else {
        return isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> getUserRole(bool isEnglish) async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/get_user_role",
          options: Options(headers: ApiUtils.headerWithToken));
      List result = [];
      if (response.statusCode == 200) {
        String userType = response.data['role'];
        result.add(true);
        result.add(userType);
        return result;
      } else {
        result.add(false);
        result.add(isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar']);
        return result;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        List result = [];
        result.add(false);
        result.add(e.message);
        return result;
      }
    }
  }

  Future<dynamic> getPlaceId(double lat, double long) async {
    try {
      Response response = await Dio().post(
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-$lat,$long&radius=100&key=${Constants.kGoogleApiKey}",
          options: Options(headers: ApiUtils.normalHeader));
      PlaceForId place = response.data;
      return place;
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> getProfile() async {
    try {
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/get_profile",
          options: Options(headers: ApiUtils.headerWithToken));
      Profile profile = Profile.fromJson(response.data);
      return profile;
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> logout(BuildContext context, bool isEnglish) async {
    try {
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/logout",
          options: Options(headers: ApiUtils.headerWithToken));
      if (response.statusCode == 200) {
        return true;
      } else {
        return isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        if (e.response.statusCode == 302) {
          var userData = UserData();
          userData.remove();
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(type: PageTransitionType.fade, child: Splash()),
              (Route<dynamic> route) => false);
          return false;
        }
        return e.message;
      }
    }
  }

  Future<dynamic> sendCodeToResetPassword(
      bool isEnglish, Map<String, dynamic> data) async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/forgot_password",
          data: data,
          options: Options(headers: ApiUtils.normalHeader));
      if (response.statusCode == 200) {
        return {
          "message": response.data['success'],
        };
      } else {
        return isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> resetPassword(
      bool isEnglish, Map<String, dynamic> data) async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/reset_password",
          data: data,
          options: Options(headers: ApiUtils.normalHeader));
      if (response.statusCode == 200) {
        return {
          "message": isEnglish
              ? response.data['success']['en']
              : response.data['success']['ar'],
        };
      } else {
        return isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> getProfileAndSpecialitiesAndServices(bool isEnglish) async {
    try {
      List<Response> response = await Future.wait([
        Dio().post("${ApiUtils.BaseApiUrl}/get_profile",
            options: Options(headers: ApiUtils.headerWithToken)),
        Dio().post("${ApiUtils.BaseApiUrl}/get_specialities",
            options: Options(headers: ApiUtils.headerWithToken)),
        Dio().post("${ApiUtils.BaseApiUrl}/get_services",
            options: Options(headers: ApiUtils.headerWithToken))
      ]);
      if (response[0].statusCode == 200 &&
          response[1].statusCode == 200 &&
          response[2].statusCode == 200) {
        Profile profile = Profile.fromJson(response[0].data);
        List specialitiesData = response[1].data['specialities'];
        List<Speciality> specialities = [];
        specialitiesData.forEach((speciality) {
          specialities.add(Speciality.fromJson(speciality));
        });
        List servicesData = response[2].data['services'];
        List<Service_of_request> services = [];
        servicesData.forEach((serviceData) {
          services.add(Service_of_request.fromJson(serviceData));
        });
        return [profile, specialities, services];
      } else {
        return "Something went wrong";
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> getBlogs() async {
    try {
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/blog_posts",
          options: Options(headers: ApiUtils.headerWithToken));
      List blogData = response.data['posts'];
      List<Blog> blogs = blogData.map((blog) => Blog.fromJson(blog)).toList();
      return blogs;
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> register(dynamic data, bool isEnglish) async {
    try {
      final response = await Dio().post("${ApiUtils.BaseApiUrl}/register",
          data: data, options: Options(headers: ApiUtils.normalHeader));
      if (response.statusCode == 200) {
        return true;
      } else {
        return isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return e.message;
      }
    }
  }

  Future<dynamic> verifyEmail(dynamic data, BuildContext context) async {
    try {
      final response = await Dio().post("${ApiUtils.BaseApiUrl}/confirm_email",
          data: data, options: Options(headers: ApiUtils.normalHeader));
      if (response.statusCode == 200) {
        return true;
      } else {
        return CommonUtils.getLanguage(context) == "english"
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return e.message;
      }
    }
  }

  Future<dynamic> logInWithFB(dynamic data, bool isEnglish) async {
    try {
      final response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/auth/social/facebook",
          data: data,
          options: Options(headers: ApiUtils.normalHeader));
      if (response.statusCode == 200) {
        return {"token": response.data['token']};
      } else {
        return isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return e.message;
      }
    }
  }

  Future<dynamic> logInWithGmail(dynamic data, bool isEnglish) async {
    try {
      final response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/auth/social/google",
          data: data,
          options: Options(headers: ApiUtils.normalHeader));
      if (response.statusCode == 200) {
        return {"token": response.data['token']};
      } else {
        return isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return e.message;
      }
    }
  }

  Future<dynamic> verifyMobile(dynamic data, BuildContext context) async {
    try {
      final response = await Dio().post("${ApiUtils.BaseApiUrl}/confirm_mobile",
          data: data, options: Options(headers: ApiUtils.normalHeader));
      if (response.statusCode == 200) {
        return true;
      } else {
        return CommonUtils.getLanguage(context) == "english"
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return e.message;
      }
    }
  }

  Future<dynamic> getBalance(bool isEnglish) async {
    try {
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/get_balance",
          options: Options(headers: ApiUtils.headerWithToken));
      if (response.statusCode == 200) {
        Balance balance = Balance.fromJson(response.data);
        return balance;
      } else {
        return isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> updateProfile(dynamic data, bool isEnglish) async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/update_profile",
          data: data,
          options: Options(headers: ApiUtils.headerWithToken));
      if (response.statusCode == 200) {
        return Update_profile.fromJson(response.data);
      } else {
        return isEnglish
            ? response.data['error']['en']
            : response.data['error']['ar'];
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.error;
      }
    }
  }
}
