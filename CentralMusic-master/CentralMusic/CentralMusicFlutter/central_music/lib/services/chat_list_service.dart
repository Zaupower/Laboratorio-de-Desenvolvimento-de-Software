import 'dart:convert';
import 'dart:io';

import 'package:central_music/helpers/connection_helper.dart';
import 'package:central_music/helpers/storage_helper.dart';
import 'package:central_music/models/chat.dart';
import 'package:central_music/models/message.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class ChatListServices {
  static Future<List<Chat>> getChats() async {
    final String token = await StorageHelper.readToken();
    final String url = "https://10.0.2.2:5001/Chat/getChatsFromUser";
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      print('response body GET CHATS: ${response.body}');
      return compute(parseMessage, response.body);
    } else {
      return new List<Chat>();
    }
  }

  //Post Messages to server
  static Future<http.Response> addMessage(Message message) async {
    final response = await http.post(
      "https://10.0.2.2:5001/sendMessage",
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "chatId": message.chatId.toString(),
        "messageSend": message.messageSend,
        "senderId": message.senderId.toString()
      }),
    );
  }

  static List<Chat> parseMessage(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Chat>((json) => Chat.fromJson(json)).toList();
  }

  //Create chat
  static Future<String> createChat(int id, int publicationId, String publicationName) async {

    final String token = await StorageHelper.readToken();
    const String url = 'https://10.0.2.2:5001/createChat/';

    final response = await http.post(url +"?matchId="+ id.toString()+"&publicationId=" +publicationId.toString()+"&publicationName="+publicationName,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    print("Status code:"+response.statusCode.toString());
    if (response.statusCode == 200) {
      print('response body : ${response.body}');
      final String result = response.body ;
      return "true";
    } else {
      return "false";
    }
  }

  //Create chat
  static Future<String> createChat2(int id) async {

    final String token = await StorageHelper.readToken();
    const String url = 'https://10.0.2.2:5001/createChat/';

    final response = await http.post(url + id.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    print("Status code:"+response.statusCode.toString());
    if (response.statusCode == 200) {
      print('response body : ${response.body}');
      final String result = response.body ;
      return "Concluido!";
    } else {
      return "false";
    }
  }

}
