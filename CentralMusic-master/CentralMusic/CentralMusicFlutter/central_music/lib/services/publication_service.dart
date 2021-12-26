import 'dart:convert';
import 'dart:io';

import 'package:central_music/helpers/storage_helper.dart';
import 'package:central_music/models/publicati_with_range.dart';
import 'package:central_music/models/publication_create.dart';
import 'package:central_music/services/main_page_services.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/publicati_with_range.dart';
import '../models/publicati_with_range.dart';
import '../models/publicati_with_range.dart';
import '../models/publicati_with_range.dart';
import '../models/publicati_with_range.dart';
import '../models/publication_create.dart';

class PublicationServices {
  static const String url =
      'https://10.0.2.2:5001/api/Publication/CreatePublication';

  static Future<List<String>> postPublications(PublicationCreate p) async {
    final String token = await StorageHelper.readToken();
    List<String> resultList = new List();
    print(p);
    final String userId = await StorageHelper.readTokenID();
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          "id": 0,
          "utilizadorId": userId,
          "tittle": p.tittle,
          "description": p.description,
          "tradable": p.tradable,
          "category": EnumToString.convertToString(p.category),
          "initialPrice": p.initialPrice,
          "imagePath": p.imagePath,
          "instrumentCondition":
              EnumToString.convertToString(p.instrumentCondition),
          "userAddress": p.localization.toJson(),
        }));
    if (response.statusCode == 200) {
      print(response.statusCode);
      print('response body : ${response.body}');
      final String publications = response.body;
      Map valueMap = jsonDecode(response.body);
      //print("MAPAA "+valueMap.toString());
      String tittle = valueMap["tittle"];
      int id = valueMap["id"];
      String desciption = valueMap["tittle"];
      int utilizadorId = valueMap["utilizadorId"];

      int price = valueMap["initialPrice"];
      int usrId = valueMap["utilizadorId"];
      String category = valueMap["category"];
      Map district2 = valueMap["userAddress"];
      String district = district2["district"];
      print("District adress value ash map"+ district2.toString());

      print("District deposi de retirado do map distric2"+ district);
      print(tittle +
          "b  tittle fds " +
          id.toString() +
          "id" +
          valueMap["tittle"]);

      resultList.add(tittle);
      resultList.add(id.toString());
      resultList.add(desciption);
      resultList.add(utilizadorId.toString());
      resultList.add(price.toString());
      resultList.add(usrId.toString());
      resultList.add(category);
      resultList.add(district);
      print(resultList);

      PublicationWithRange p = new PublicationWithRange();
      return resultList;
    } else {
      if (response.statusCode != 200) {
        print(response.statusCode);
        throw Exception("Request Failed");
      }

      return null;
    }
  }

  static Future<String> addToFavorites(int id) async {
    final String token = await StorageHelper.readToken();
    String newUrl =
        "https://10.0.2.2:5001/api/Publication/AddPublicationToFavorites?pId=";
    String result = "";
    final response = await http.post(
      newUrl + id.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      print("Response: " + response.body);
      result = response.body;
      print("Result: " + response.body);
      return result;
    }
  }

  static Future<String> removeFromFavorites(int id) async {
    final String token = await StorageHelper.readToken();
    String newUrl =
        "https://10.0.2.2:5001/api/User/DeletePublicationFromFavorites?pId=";
    String result = "";
    final response = await http.delete(
      newUrl + id.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      print("Response: " + response.body);
      result = response.body;
      print("Result: " + response.body);
    }
    return result;
  }

  // static Future<String> getFavorites(int pId) async {
  //   List<PublicationWithRange> favoriteList = new List();
  //   String result = "";
  //   Services.getFavoritePublicationsById().then((value) {
  //     favoriteList = value;
  //     for (PublicationWithRange p in favoriteList) {
  //       if (p.id == pId) {
  //         removeFromFavorites(pId).then((value) {
  //           result = "Removed";
  //         });
  //       }
  //     }
  //     if (result != "Removed") {
  //       addToFavorites(pId).then((value) {
  //         print("Value de adicionar " + value);
  //         result = value;
  //       });
  //       print("Entao vai adicionar");
  //     }
  //     print("Dentro da funcao getFavorites" + favoriteList.toString());
  //   });
  //   return " tt";
  // }
  static Future<String> isFavorite(int pId) async {
    List<PublicationWithRange> favoriteList = new List();
    String result = "";
    print(pId);
    Services.getFavoritePublicationsById().then((value) {
      print("Favorite list length " + value.length.toString());
      favoriteList = value;
      print(favoriteList.isEmpty);

      if (!favoriteList.isEmpty) {
        for (PublicationWithRange p in favoriteList) {
          print(p.id);
          print(pId);
          if (p.id == pId) {
            print("a enviar true");
            result = "true";
            return result;
          }
        }
      }else{
        if (result != "true") {
          result = "false";
          print(result);
          return result;
        }
      }
    });
  }
}
