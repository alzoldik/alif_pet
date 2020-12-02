import 'package:alif_pet/models/index.dart';
import 'package:dio/dio.dart';

import 'api_utils.dart';

class DoctorApis {
  Future<dynamic> uploadCertificate(dynamic data,bool isEnglish) async{
    try{
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/add_certificate",data: data,options: Options(headers: ApiUtils.headerWithToken ));
      if(response.statusCode==200){
        return Success.fromJson(response.data['success']);
      }
      else{
        return isEnglish? response.data['error']['en'] : response.data['error']['ar'];
      }
    }on DioError catch(e) {
      if(e.type == DioErrorType.DEFAULT || e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RESPONSE) {
        return e.error;
      }
    }
  }
  Future<dynamic> deleteCertificate(dynamic data,bool isEnglish) async{
    try{
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/delete_certificate",data: data,options: Options(headers: ApiUtils.headerWithToken ));
      if(response.statusCode==200){
        return Success.fromJson(response.data['success']);
      }
      else{
        return isEnglish? response.data['error']['en'] : response.data['error']['ar'];
      }
    }on DioError catch(e) {
      if(e.type == DioErrorType.DEFAULT || e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RESPONSE) {
        return e.error;
      }
    }
  }
  Future<dynamic> acceptRequest(dynamic data,bool isEnglish) async{
    try{
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/accept_service_request",data: data,options: Options(headers: ApiUtils.headerWithToken ));
      if(response.statusCode==200){
        return Success.fromJson(response.data['success']);
      }
      else{
        return isEnglish? response.data['error']['en'] : response.data['error']['ar'];
      }
    }on DioError catch(e) {
      if(e.type == DioErrorType.DEFAULT || e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RESPONSE) {
        return e.error;
      }
    }
  }
  Future<dynamic> cancelRequest(dynamic data,bool isEnglish) async{
    try{
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/cancel_service_request",data: data,options: Options(headers: ApiUtils.headerWithToken ));
      if(response.statusCode==200){
        return Success.fromJson(response.data['success']);
      }
      else{
        return isEnglish? response.data['error']['en'] : response.data['error']['ar'];
      }
    }on DioError catch(e) {
      if(e.type == DioErrorType.DEFAULT || e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RESPONSE) {
        return e.error;
      }
    }
  }
  Future<dynamic> endRequest(dynamic data,bool isEnglish) async{
    try{
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/end_service_request",data: data,options: Options(headers: ApiUtils.headerWithToken ));
      if(response.statusCode==200){
        return Success.fromJson(response.data['success']);
      }
      else{
        return isEnglish? response.data['error']['en'] : response.data['error']['ar'];
      }
    }on DioError catch(e) {
      if(e.type == DioErrorType.DEFAULT || e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RESPONSE) {
        return e.error;
      }
    }
  }
  Future<dynamic> withdrawRequest(dynamic data,bool isEnglish) async{
    try{
      Response response = await Dio().post("${ApiUtils.BaseApiUrl}/withdraw_request",data: data,options: Options(headers: ApiUtils.headerWithToken ));
      if(response.statusCode==200){
        return Success.fromJson(response.data['success']);
      }
      else{
        return isEnglish? response.data['error']['en'] : response.data['error']['ar'];
      }
    }on DioError catch(e) {
      if(e.type == DioErrorType.DEFAULT || e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RESPONSE) {
        return e.error;
      }
    }
  }
}