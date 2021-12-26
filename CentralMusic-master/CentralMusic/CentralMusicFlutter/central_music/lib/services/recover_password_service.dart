import 'dart:async';
import 'dart:convert';

import 'package:central_music/models/recover_password.dart';
import 'package:http/http.dart' as https;

class RecoverPasswordService {
  Future<int> changePassword([RecoverPassword newPassword]) async {
    final url = "https://10.0.2.2:5001/resetPassword";

    final response = await https.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': newPassword.email,
        'password': newPassword.password,
        'confirmPassword': newPassword.confirmPassword,
        'token': newPassword.token,
      }),
    );

    return response.statusCode;
  }
}
