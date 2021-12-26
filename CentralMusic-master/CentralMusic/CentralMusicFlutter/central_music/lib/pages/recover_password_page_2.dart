import 'package:central_music/services/recover_password_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:central_music/widgets/error_message_dialog.dart';
import 'package:central_music/helpers/connection_helper.dart';
import 'package:central_music/models/recover_password.dart';
import 'package:central_music/pages/login_page.dart';

class RecoverPasswordScreen extends StatefulWidget {
  @override
  _RecoverPasswordScreen createState() => _RecoverPasswordScreen();
}

class _RecoverPasswordScreen extends State<RecoverPasswordScreen> {
  String _email;
  String _password;
  String _confirmPassword;
  String _token;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode myFocusNodeEmail = new FocusNode();
  FocusNode myFocusNodePassword1 = new FocusNode();
  FocusNode myFocusNodePassword2 = new FocusNode();
  FocusNode myFocusNodeToken = new FocusNode();

  Widget emailWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        focusNode: myFocusNodeEmail,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Email',
          labelStyle: TextStyle(
              color: myFocusNodeEmail.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (String value) {
          String pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regExp = new RegExp(pattern);
          if (value.length == 0) {
            return "Insira um email";
          } else if (!regExp.hasMatch(value)) {
            return "Email inválido";
          } else {
            return null;
          }
        },
        onSaved: (String value) {
          _email = value;
        },
      ),
    );
  }

  Widget passwordWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.text,
        focusNode: myFocusNodePassword1,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Password',
          labelStyle: TextStyle(
              color:
                  myFocusNodePassword1.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        obscureText: true,
        validator: (String value) {
          String pattern =
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
          RegExp regExp = new RegExp(pattern);
          if (value.length == 0) {
            return "Insira uma password";
          } else if (!regExp.hasMatch(value)) {
            return "Uma letra maiúscula, um digito e um caracter especial";
          } else {
            return null;
          }
        },
        onSaved: (String value) {
          _password = value;
        },
      ),
    );
  }

  Widget confirmPasswordWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.text,
        focusNode: myFocusNodePassword2,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Password',
          labelStyle: TextStyle(
              color:
                  myFocusNodePassword2.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        obscureText: true,
        validator: (String value) {
          String pattern =
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
          RegExp regExp = new RegExp(pattern);
          if (value.length == 0) {
            return "Insira uma password";
          } else if (!regExp.hasMatch(value)) {
            return "Uma letra maiúscula, um digito e um caracter especial";
          } else {
            return null;
          }
        },
        onSaved: (String value) {
          _confirmPassword = value;
        },
      ),
    );
  }

  Widget tokenWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.text,
        focusNode: myFocusNodeToken,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Token',
          labelStyle: TextStyle(
              color: myFocusNodeToken.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (String value) {
          if (value.length == 0) {
            return "Introduza o token";
          }
          return null;
        },
        onSaved: (String token) {
          _token = token;
        },
      ),
    );
  }

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
            padding: EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 0.0),
            child: Text(
                'Foi enviado um e-mail com um token para verificação de identidade. \n'
                'Para alterar a palavra-passe, preencha os seguintes campos',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
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
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 100),
                            emailWidget(),
                            passwordWidget(),
                            confirmPasswordWidget(),
                            tokenWidget(),
                            SizedBox(height: 50),
                            RaisedButton(
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              color: Colors.white,
                              child: Text(
                                'Alterar password',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                _formKey.currentState.save();
                                await actionChangePassword();
                                //Send to API
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // passar os dados
  Future<void> actionChangePassword() async {
    if (await ConnectionHelper.checkConnection()) {
      var email = _email;
      var password = _password;
      var confirmPassword = _confirmPassword;
      var token = _token;

      RecoverPassword newPassword = new RecoverPassword(
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          token: token);

      var statusCode =
      await RecoverPasswordService().changePassword(newPassword);
      print(email);
      print(password);
      print(confirmPassword);
      print(token);

      if (statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        Fluttertoast.showToast(
            msg:
            "Agora pode fazer Login com os seus dados",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.amberAccent[100],
            textColor: Colors.black,
            fontSize: 16.0);
      } else {
        showDialog(
          context: context,
          builder: (context) => ErrorMessageDialog(
              title: "Dado(s) invalido(s)",
              text: "O(s) dado(s) inserido(s) encontram-se invalido(s)!"),
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

