import 'dart:async';
import 'dart:convert';

import 'package:central_music/models/forgot_password.dart';
import 'package:http/http.dart' as https;

class SendTokenService {
  Future<int> sendToken([ForgotPassword newRequest]) async {
    final url = "https://10.0.2.2:5001/forgotPassword";

    final response = await https.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': newRequest.email,
      }),
    );

    return response.statusCode;

  }
}
