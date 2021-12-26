import 'dart:io';

import 'package:central_music/widgets/navigation_bar_controller.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:central_music/helpers/connection_helper.dart';
import 'package:central_music/helpers/storage_helper.dart';
import 'package:central_music/pages/login_page.dart';

final storage = FlutterSecureStorage();

Future main() async {
  HttpOverrides.global = new MyHttpOverrides();
  await loadSettings();
  runApp(CentralMusicApp());
}

Future loadSettings() async {
  await DotEnv().load("env/dev.env");
  HttpOverrides.global = new MyHttpOverrides();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class CentralMusicApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CentralMusicAppState();
  }
}

class _CentralMusicAppState extends State<CentralMusicApp> {
  bool isDeviceConnected = true;
  String role;
  var token;
  int statusCode;
  var internetConnection;

  @override
  void initState() {
    super.initState();

    StorageHelper.readToken().then((value) {if (value != null) {
      statusCode = 200;}});

    //Ativar listener para caso a conectividade mude
    internetConnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        isDeviceConnected = await DataConnectionChecker().hasConnection;
        if (isDeviceConnected) {
          statusCode = await ConnectionHelper.checkTokenValidaty();
          setState(() async {statusCode = await ConnectionHelper.checkTokenValidaty();});
        }
      } else {
        isDeviceConnected = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("is device Conected"+isDeviceConnected.toString());
    if (isDeviceConnected) {
      return buildOnlineApp(context);
    } else {
      return buildOfflineApp(context);
    }
  }

  Widget buildOfflineApp(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "CentralMusic",
        home: Center(
            child: Scaffold(
                body: Center(
                    child:
                        Stack(alignment: Alignment.center, children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFE0E0E0),
            ),
          ),
          Container(
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: new Image.asset(
                    'assets/images/centralmusic_logonormal.png',
                    height: 200.0,
                  ),
                ),
                Container(
                    child: FutureBuilder(
                        future: ConnectionHelper.checkConnection(),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return Column(
                              children: <Widget>[
                                Text(
                                  "Iniciando....",
                                  style: TextStyle(
                                      fontSize: 20, color: Color(0xFF5B82AA)),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: <Widget>[
                                Text(
                                  "Dispositivo Offline!",
                                  style: TextStyle(
                                      fontSize: 20, color: Color(0xFF5B82AA)),
                                ),
                              ],
                              // ignore: missing_return
                            );
                          }
                        })),
              ],
            ),
          ),
        ])))));
  }

  Widget buildOnlineApp(BuildContext context) {
    internetConnection.cancel();
    if (statusCode == 200) {
      return MaterialApp(
          localizationsDelegates: [GlobalMaterialLocalizations.delegate],
          supportedLocales: [const Locale('pt')],
          debugShowCheckedModeBanner: false,
          title: "CentralMusic",
          home:  BottomNavigationBarController());
      // alterar para pagina inicial do utilizador
    } else {
      return MaterialApp(
          localizationsDelegates: [GlobalMaterialLocalizations.delegate],
          supportedLocales: [const Locale('pt')],
          debugShowCheckedModeBanner: false,
          title: "CentralMusic",
          home: LoginScreen());
    }
  }

  @override
  void dispose() {
    if (internetConnection != null) {
      internetConnection.cancel();
    }
    super.dispose();
  }
}
