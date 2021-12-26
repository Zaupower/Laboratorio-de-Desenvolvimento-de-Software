import 'dart:async';
import 'dart:convert';

import 'package:central_music/models/user_register.dart';
import 'package:http/http.dart' as https;

class UserRegisterService {
  Future<int> createUserRegister([UserRegister newUser]) async {
    final url = "https://10.0.2.2:5001/api/User/register";

    final response = await https.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': newUser.email,
        'password': newUser.password,
        'firstName': newUser.firstName,
        'lastName': newUser.lastName,
        'localization': newUser.localization.toJson()
      }),
    );

    return response.statusCode;
  }
}
