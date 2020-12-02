import 'package:alif_pet/models/country.dart';
import 'package:alif_pet/models/index.dart';
import 'package:alif_pet/models/profile.dart';
import 'package:dio/dio.dart';

import 'api_utils.dart';

class ClientApis {
  Future<dynamic> getDoctors() async {
    try {
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/get_doctors",
          options: Options(headers: ApiUtils.headerWithToken));
      List doctorsData = response.data['doctors'];
      List<Profile> doctors = List();
      for (int i = 0; i < doctorsData.length; i++) {
        doctors.add(Profile.fromJson(doctorsData[i]));
      }
      return doctors;
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> getFavDoctors(bool isEnglish) async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/favorite_doctors",
          options: Options(headers: ApiUtils.headerWithToken));

      if (response.statusCode == 200) {
        List doctorsData = response.data['favorite_doctors'];
        List<FavDoc> doctors = List();
        for (int i = 0; i < doctorsData.length; i++) {
          doctors.add(FavDoc.fromJson(doctorsData[i]));
        }
        return doctors;
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

  Future<dynamic> requestService(dynamic data, bool isEnglish) async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/request_service",
          data: data,
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
        return e.message;
      }
    }
  }

  Future<dynamic> rateDoctor(dynamic data, bool isEnglish) async {
    try {
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/rate_doctor",
          data: data, options: Options(headers: ApiUtils.headerWithToken));
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
        return e.message;
      }
    }
  }

  Future<dynamic> getChatTimeSlots(dynamic data, bool isEnglish) async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/get_time_slots/0.5",
          data: data,
          options: Options(headers: ApiUtils.headerWithToken));
      if (response.statusCode == 200) {
        Map<String, dynamic> slotsMap = response.data['slots'];
        return slotsMap;
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

  Future<dynamic> addBalance(dynamic data, bool isEnglish) async {
    try {
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/add_payment",
          data: data, options: Options(headers: ApiUtils.headerWithToken));
      if (response.statusCode == 200) {
        return Success.fromJson(response.data['success']);
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

  Future<dynamic> getVisitTimeSlots(dynamic data, bool isEnglish) async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/get_time_slots/2",
          data: data,
          options: Options(headers: ApiUtils.headerWithToken));
      if (response.statusCode == 200) {
        Map<String, dynamic> slotsMap = response.data['slots'];
        return slotsMap;
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

  Future<dynamic> getTransactions(bool isEnglish) async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/my_transactions",
          options: Options(headers: ApiUtils.headerWithToken));
      if (response.statusCode == 200) {
        dynamic transactions = response.data['transactions'];
        return transactions;
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

  Future<dynamic> favADoctor(dynamic data, bool isEnglish) async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/favorite_doctor",
          data: data,
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
        return e.message;
      }
    }
  }

  Future<dynamic> unFavADoctor(dynamic data, bool isEnglish) async {
    try {
      Response response = await Dio().post(
          "${ApiUtils.BaseApiUrl}/unfavorite_doctor",
          data: data,
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
        return e.message;
      }
    }
  }

  Future<dynamic> getDoctorsBySearch(dynamic data) async {
    try {
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/get_doctors",
          data: data, options: Options(headers: ApiUtils.headerWithToken));
      List doctorsData = response.data['doctors'];
      List<Profile> doctors = List();
      for (int i = 0; i < doctorsData.length; i++) {
        doctors.add(Profile.fromJson(doctorsData[i]));
      }
      return doctors;
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> getDoctorsAndServices() async {
    try {
      List<Response> response = await Future.wait([
        Dio().post("${ApiUtils.BaseApiUrl}/get_doctors",
            options: Options(headers: ApiUtils.headerWithToken)),
        Dio().post("${ApiUtils.BaseApiUrl}/get_services",
            options: Options(headers: ApiUtils.headerWithToken))
      ]);
      List doctorsData = response[0].data['doctors'];
      List servicesData = response[1].data['services'];
      List<Profile> doctors = List();
      for (int i = 0; i < doctorsData.length; i++) {
        doctors.add(Profile.fromJson(doctorsData[i]));
      }
      List<Service_of_request> services = List();
      for (int i = 0; i < servicesData.length; i++) {
        services.add(Service_of_request.fromJson(servicesData[i]));
      }
      List result = [];
      result.add(doctors);
      result.add(services);
      return result;
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> getCountriesAndSpecialities() async {
    try {
      List<Response> response = await Future.wait([
        Dio().post("${ApiUtils.BaseApiUrl}/get_countries",
            options: Options(headers: ApiUtils.headerWithToken)),
        Dio().post("${ApiUtils.BaseApiUrl}/get_specialities",
            options: Options(headers: ApiUtils.headerWithToken))
      ]);
      List countriesData = response[0].data['countries'];
      List specialityData = response[1].data['specialities'];
      List<Country> countries = [];
      List<Speciality> specialities = [];
      for (int i = 0; i < countriesData.length; i++) {
        countries.add(Country.fromJson(countriesData[i]));
      }
      for (int i = 0; i < specialityData.length; i++) {
        specialities.add(Speciality.fromJson(specialityData[i]));
      }
      List resultData = [];
      resultData.add(countries);
      resultData.add(specialities);
      return resultData;
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        return e.message;
      }
    }
  }

  Future<dynamic> getBalanceWindow(String clientID, String amount) async {
    Map<String, dynamic> result = Map();
    try {
      Response response = await Dio().get(
          "${ApiUtils.BaseApiUrl}/get_payment_window/1/$clientID/$amount",
          options: Options(headers: ApiUtils.normalHeader));
      if (response.statusCode == 200) {
        result.putIfAbsent("hasError", () => false);
        result.putIfAbsent("value", () => response.data);
        return result;
      } else {
        result.putIfAbsent("hasError", () => true);
        result.putIfAbsent("value", () => response.data);
        return result;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RESPONSE) {
        result.putIfAbsent("hasError", () => true);
        result.putIfAbsent("value", () => e.message);
        return result;
      }
    }
  }
}
