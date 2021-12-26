import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:central_music/models/forgot_password.dart';
import 'package:central_music/services/send_token_recover_password_service.dart';
import 'package:central_music/widgets/error_message_dialog.dart';
import 'package:central_music/helpers/connection_helper.dart';
import 'package:central_music/pages/recover_password_page_2.dart';

class SendEmailForgotPasswordScreen extends StatefulWidget {
  @override
  _SendEmailForgotPasswordScreen createState() => _SendEmailForgotPasswordScreen();
}

class _SendEmailForgotPasswordScreen extends State<SendEmailForgotPasswordScreen> {
  String _email;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode myFocusNodeEmail = new FocusNode();

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
            padding: EdgeInsets.fromLTRB(16.0, 85.0, 16.0, 0.0),
            child: new Image.network(
                'https://onetwopixel.com/wp-content/uploads/2018/02/animat-lock-color.gif'),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 0.0),
            child: Text(
                'Para alterar a palavra-passe, por favor insira um e-mail válido e registado na aplicação',
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
                            SizedBox(height: 350),
                            emailWidget(),
                            SizedBox(height: 50),
                            RaisedButton(
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              color: Colors.white,
                              child: Text(
                                'Seguinte',
                                style:
                                TextStyle(color: Colors.black, fontSize: 16),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                _formKey.currentState.save();
                                await actionSendToken();
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
  Future<void> actionSendToken() async {
    if (await ConnectionHelper.checkConnection()) {
      var email = _email;

      ForgotPassword password = new ForgotPassword(email: email);

      var statusCode = await SendTokenService().sendToken(password);

      if (statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecoverPasswordScreen()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => ErrorMessageDialog(
              title: "Email inválido",
              text: "O e-mail inserido não se encontra registado na aplicação!"),
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
