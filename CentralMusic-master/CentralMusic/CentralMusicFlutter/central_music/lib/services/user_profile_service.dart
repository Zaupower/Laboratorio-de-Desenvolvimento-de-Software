import 'dart:async';
import 'dart:convert';
import 'package:central_music/models/publicati_with_range.dart';
import 'package:central_music/models/publication_create.dart';
import 'package:central_music/models/publication_update_model.dart';
import 'package:central_music/models/user_edit.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:http/http.dart' as https;
import '../helpers/storage_helper.dart';

class UserProfileService {
  Future<int> updateUser([UserEdit updateUser]) async {
    final url = "https://10.0.2.2:5001/api/User/update";

    final String token = await StorageHelper.readToken();
    print(token);

    final response = await https.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'email': updateUser.email,
        'firstName': updateUser.firstName,
        'lastName': updateUser.lastName,
        'localization': updateUser.localization.toJson()
      }),
    );

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception("Request Failed");
    }

    return response.statusCode;
  }

  Future<String> deletePublication(int id) async {
    final String token = await StorageHelper.readToken();
    final url = "https://10.0.2.2:5001/api/User/DeletePublication/" + id.toString();
    print (id);
    String result = "";
    final response = await https.delete(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Response: " + response.body);
      result = response.body;
      print("Result: " + response.body);
    }
    return result;
  }

  static Future<List<String>> updatePublication(PublicationUpdate p) async {
    final urlUpdate = "https://10.0.2.2:5001/api/User/UpdatePublication";
    final String token = await StorageHelper.readToken();
    List<String> resultList = new List();
    print(p);
    final String userId = await StorageHelper.readTokenID();
    final response = await https.put(urlUpdate,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          "id": p.id,
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
}
