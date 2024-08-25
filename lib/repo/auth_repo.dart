import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iraqdriver/api/api_component.dart';
import 'package:iraqdriver/model/login_model.dart';

import '../api/urls.dart';

class AuthRepo {
  Dio dio = Dio();

  Future<LoginModel?> loginRep(String email, String password) async {
    debugPrint("11111111 $email / $password");
    try {
      Response response;
      response = await dio.get(Urls.loginUrl, queryParameters: {
        'usr': email.toString(),
        'pwd': password.toString()
      });
      if (response.statusCode == 200) {
        LoginModel loginModel = LoginModel.fromJson(response.data);
        return loginModel;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      return null;
    }
  }
}
