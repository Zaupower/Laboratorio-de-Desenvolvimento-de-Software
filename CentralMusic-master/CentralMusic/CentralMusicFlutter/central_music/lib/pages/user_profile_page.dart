import 'package:central_music/pages/update_password_page.dart';
import 'package:central_music/pages/user_edit_page.dart';
import 'package:central_music/pages/user_own_publications.dart';
import 'package:central_music/pages/user_favorite_publications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:central_music/helpers/connection_helper.dart';
import 'package:central_music/widgets/error_message_dialog.dart';
import 'package:central_music/services/user_profile_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';

import '../helpers/storage_helper.dart';
import '../models/profile_model.dart';
import '../services/main_page_services.dart';
import '../services/user_profile_service.dart';
import '../widgets/profile.dart';
import 'add_photo_profile.dart';
import 'grid_widget.dart';
import 'login_page.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key key}) : super(key: key);

  @override
  _UserProfileScreen createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  Future<ProfileModel> fetchPerson;
  bool isDeviceConnected = false;
  var internetConnection;

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchPerson = getData();
    });
  }

  Future<ProfileModel> getData() async {
    final String token = await StorageHelper.readToken();

    final String id = await StorageHelper.readTokenID();
    String userID = id;

    final url = "https://10.0.2.2:5001/api/User/GetUserById/" + id;

    final response = await https.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    Map<String, dynamic> responseJson = json.decode(response.body);
    ProfileModel.fromJson(responseJson);

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(responseJson);
    } else {
      throw Exception("Request Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Fundo amarelo
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.amber[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),

            // Foto de perfil
            FutureBuilder(
                future: fetchPerson,
                builder: (context, snapshot) {
                  print(snapshot);
                  if (snapshot.hasData) {
                    return Container(
                      width: double.infinity,
                      height: 150,
                      child: Container(
                        alignment: Alignment(0, 15.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://10.0.2.2:5001/images/Uploads/Users/" +
                                  '${snapshot.data.id}' +
                                  "/main.png"),
                          radius: 70.0,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    Text(
                      snapshot.error.toString(),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),


            // Alterar dados pessoais do utilizador
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 100.0,
              ),
              alignment: Alignment.bottomLeft,
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserEditPage()),
                  );
                },
                padding: EdgeInsets.symmetric(),
                child: Text(
                  'Atualizar perfil >',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // Primeiro nome e ultimo nome da pessoa
            FutureBuilder(
                future: fetchPerson,
                builder: (context, snapshot) {
                  print(snapshot);
                  if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(140, 230, 0, 0),
                      child: Text(
                        '${snapshot.data.firstName} ${snapshot.data.lastName}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    Text(
                      snapshot.error.toString(),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),

            // Divider
            Row(
              children: <Widget>[
                Expanded(
                    child: new Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 570.0),
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ))
              ],
            ),

            // Alterar password do utilizador
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 150.0,
              ),
              alignment: Alignment.bottomLeft,
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserUpdatePasswordScreen()),
                  );
                },
                padding: EdgeInsets.symmetric(),
                child: Text(
                  'Alterar password >',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(38, 300, 0, 0),
              child: Text(
                'Os meus anúncios ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            // Divider
            Row(
              children: <Widget>[
                Expanded(
                    child: new Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 390.0),
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ))
              ],
            ),

            // Publicações do utilizador
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 350.0,
              ),
              alignment: Alignment.bottomLeft,
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserOwnPublications()
                    ),
                  );
                },
                padding: EdgeInsets.symmetric(),
                child: Text(
                  'Ver anúncios ativos >',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(38, 400, 0, 0),
              child: Text(
                'Os meus anúncios favoritos ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            // Divider
            Row(
              children: <Widget>[
                Expanded(
                    child: new Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 480.0),
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ))
              ],
            ),

            // Publicações favoritas do utilizador
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 240.0,
              ),
              alignment: Alignment.bottomLeft,
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserFavoritePublications()
                    ), // ALTERAR PARA PUBLICAÇÔES FAVORITAS DO UTILIZADOR
                  );
                },
                padding: EdgeInsets.symmetric(),
                child: Text(
                  'Ver os meus anúncios favoritos >',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // Logout
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 60.0,
              ),
              alignment: Alignment.topRight,
              child: FlatButton(
                onPressed: () {
                  StorageHelper.deleteAllTokenData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                padding: EdgeInsets.symmetric(),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // Adicionar foto
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 100.0,
              ),
              alignment: Alignment.topRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPhoto()),
                  );
                },
                padding: EdgeInsets.symmetric(),
                child: Text(
                  'Adicionar foto',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    internetConnection.cancel();
    super.dispose();
  }
}