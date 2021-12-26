import 'dart:convert';
import 'dart:io';

import 'package:bottom_navigation_bar/publication_model.dart';
import 'package:http/http.dart' as http;
import 'publication_model.dart';

class Services {
  static const String url = 'https://10.0.2.2:5001/api/Publication/GetPublication?key=Piana&categories=Cordas';
  static const String token  =  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjZXJ0c2VyaWFsbnVtYmVyIjoiMTUiLCJlbWFpbCI6Im1hcmNlbG8xQGdtYWlsLmNvbW0iLCJuYmYiOjE2MTM0MTE0NDIsImV4cCI6MTYxMzQxNTA0MiwiaWF0IjoxNjEzNDExNDQyfQ.8H4qOaY_jN5vawLvYUhRguaxNdINYry-CQpAUIsY-UY";
  static Future<List<Publication>> getPublications() async{


      final response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: token},
      );
      if(response.statusCode ==200){
        print('response body : ${response.body}');
        final List<Publication> publications = publicationFromJson(response.body);
        return publications;
      }else{
        return List<Publication>();
      }
  }
}
