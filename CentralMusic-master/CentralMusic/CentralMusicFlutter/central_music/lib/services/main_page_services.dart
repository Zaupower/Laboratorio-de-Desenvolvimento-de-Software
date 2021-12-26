import 'dart:io';

import 'package:central_music/enums/categories.dart';
import 'package:central_music/helpers/storage_helper.dart';
import 'package:central_music/models/publicati_with_range.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:http/http.dart' as http;

class Services {
  static const String urlWithKey = 'https://10.0.2.2:5001/api/Publication/GetPublication?key=';
  static const String url = 'https://10.0.2.2:5001/api/Publication/GetPublication';
  static const String urlOwnPublications =
      "https://10.0.2.2:5001/api/User/GetOwnPublications";
  static const String urlFavoritePublications =
      "https://10.0.2.2:5001/api/User/getPublicationFromFavorites";
  static const String address = "&address=Rua%20de%20real%2C%2055%2C%204615-423%2C%20porto%2C%20portugal%20&distance=";

  //Metodo de pesquisa de todas as publicacoes sem parametros
  static Future<List<PublicationWithRange>> getPublications() async{
    final String token  = await StorageHelper.readToken();

    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: token},
    );
    if(response.statusCode ==200){
      print('response body : ${response.body}');
      final List<PublicationWithRange> publications = publicationWRFromJson(response.body);
      return publications;
    }else{
      return List<PublicationWithRange>();
    }
  }

  //Metodo de pesquisa com parametros
  static Future<List<PublicationWithRange>> getPublicationsWithKey(String key, [List<int> categories, int range]) async{
    List<String> catList = List();
    String categoriesKey = "";
    print("CHEGOU AO SERVICE categories length"+categories.length.toString());
    if(categories.isNotEmpty){
      for(int i = 0; i < categories.length;i++){
        if(categories[i] == 1){
          catList.add(EnumToString.convertToString(Categories.Cordas));
        }else if(categories[i] == 2){
          catList.add(EnumToString.convertToString(Categories.Teclas));
        }if(categories[i] == 3){
          catList.add(EnumToString.convertToString(Categories.Sopro));
        }else if(categories[i] == 4){
          catList.add(EnumToString.convertToString(Categories.Percusao));
        }
        key+= "&categories="+catList[i];
        print(categoriesKey);
      }
    } else{
      print("Categoris null");
    }
    if(range != null){
      key += address+ range.toString();
      print(key);
    }else{
      print("range nulll");
    }

    final String token  = await StorageHelper.readToken();
    final response = await http.get(
      urlWithKey+ key,
      headers: {HttpHeaders.authorizationHeader: token},
    );
    if(response.statusCode ==200){
      print('response body : ${response.body}');
      final List<PublicationWithRange> publications = publicationWRFromJson(response.body);
      return publications;
    }else{
      return List<PublicationWithRange>();
    }
  }

  static Future<List<PublicationWithRange>> getOwnPublications() async {
    final String token = await StorageHelper.readToken();

    final response = await http.get(
      urlOwnPublications,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('response body : ${response.body}');
      final List<PublicationWithRange> publications =
      publicationWRFromJson(response.body);
      return publications;
    } else {
      return List<PublicationWithRange>();
    }
  }

  static Future<List<PublicationWithRange>> getFavoritePublications() async {
    final String token = await StorageHelper.readToken();

    final response = await http.get(
      urlFavoritePublications,
      headers: {HttpHeaders.authorizationHeader: token},
    );
    if (response.statusCode == 200) {
      print('response body : ${response.body}');
      final List<PublicationWithRange> publications =
      publicationWRFromJson(response.body);
      return publications;
    } else {
      return List<PublicationWithRange>();
    }
  }

  static Future<List<PublicationWithRange>> getFavoritePublicationsById() async{
    String newUrl = "https://10.0.2.2:5001/api/User/getPublicationFromFavorites";
    final String token  = await StorageHelper.readToken();

    final response = await http.get(
      newUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if(response.statusCode ==200){
      print('response body : ${response.body}');
      final List<PublicationWithRange> publications = publicationWRFromJson(response.body);
      return publications;
    }else{
      return List<PublicationWithRange>();
    }
  }
}
