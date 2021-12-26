import 'dart:async';
import 'dart:convert';

import 'package:central_music/helpers/storage_helper.dart';
import 'package:central_music/models/update_password.dart';
import 'package:http/http.dart' as http;

class UpdatePasswordService {
  Future<int> updatePassword([UpdatePassword newPassword]) async {
    final url = "https://10.0.2.2:5001/api/User/update-password";

    final String token = await StorageHelper.readToken();

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'actualPassword': newPassword.actualPassword,
        'newPassword': newPassword.newPassword,
      }),
    );
    return response.statusCode;
  }
}