import 'package:central_music/pages/welcome_page.dart';
import 'package:central_music/widgets/navigation_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:central_music/helpers/connection_helper.dart';
import 'package:central_music/widgets/error_message_dialog.dart';
import 'package:central_music/services/login_service.dart';
import 'package:central_music/pages/user_register_page.dart';
import 'package:central_music/pages/recover_password_page_1.dart';

// import para a pagina apos o login

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/piano_login.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 30.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: new Image.asset(
                      'assets/images/centralmusic_logobranco_transparent.png',
                      height: 200,
                      width: 500,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    child: Text(
                      'O mundo da música está à sua espera',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'IndieFlower',
                      ),
                    ),
                  ),

                  //Email
                  SizedBox(height: 25.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        height: 60.0,
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),

                  //Password
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        height: 60.0,
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),

                  //Esqueceu-se da password
                  Container(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SendEmailForgotPasswordScreen()),
                        );
                      },
                      padding: EdgeInsets.only(right: 0.0),
                      child: Text(
                        'Esqueceu-se da password?',
                        style: TextStyle(
                          color: Colors.amberAccent[100],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  //Botão de Login
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: () async {
                        await actionLogin();
                      },

                      //editar para ir para página a seguir ao login
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.amberAccent[100],
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  //Don't have an account?
                  Container(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserRegisterPage()),
                        );
                      },
                      //editar para ir para a página de registo
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Não tem uma conta? ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: "Registe-se!",
                              style: TextStyle(
                                color: Colors.amberAccent[100],
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> actionLogin() async {
    if (await ConnectionHelper.checkConnection()) {
      var email = _emailController.text;
      var password = _passwordController.text;

      var statusCode = await LoginService().loginUser(email, password);
      print(statusCode);
      if (statusCode == 200) {
        print("cheguei");
        //String role = await StorageHelper.readTokenEmail();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigationBarController()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => ErrorMessageDialog(
              title: "Dados Incorretos",
              text: "Os dados inseridos não se encontram corretos!"),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => ErrorMessageDialog(
            title: "Sem conexão",
            text: "Dispositivo não consegue conectar ao servidor!"),
      );
    }
  }
}
