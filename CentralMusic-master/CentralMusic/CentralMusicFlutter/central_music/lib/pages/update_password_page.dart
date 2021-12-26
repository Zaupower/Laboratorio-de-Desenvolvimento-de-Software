import 'package:central_music/models/update_password.dart';
import 'package:central_music/services/update_password_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../helpers/connection_helper.dart';
import '../widgets/error_message_dialog.dart';
import 'user_profile_page.dart';

class UserUpdatePasswordScreen extends StatefulWidget {
  const UserUpdatePasswordScreen({Key key}) : super(key: key);

  @override
  _UserUpdatePasswordScreen createState() => _UserUpdatePasswordScreen();
}

class _UserUpdatePasswordScreen extends State<UserUpdatePasswordScreen> {
  String _actualPassword;
  String _newPassword;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode myFocusNodeActualPassword = new FocusNode();
  FocusNode myFocusNodeNewPassword = new FocusNode();

  Widget actualPasswordWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.text,
        focusNode: myFocusNodeActualPassword,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Password atual',
          labelStyle: TextStyle(
              color: myFocusNodeActualPassword.hasFocus ? Colors.blue : Colors
                  .black),
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
          _actualPassword = value;
        },
      ),
    );
  }

  Widget newPasswordWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.text,
        focusNode: myFocusNodeNewPassword,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Nova password',
          labelStyle: TextStyle(
              color: myFocusNodeNewPassword.hasFocus ? Colors.blue : Colors
                  .black),
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
          _newPassword = value;
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
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 300.0,
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
                            actualPasswordWidget(),
                            newPasswordWidget(),
                            SizedBox(height: 30),
                            RaisedButton(
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              color: Colors.amber[300],
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
                                await actionUpdatePassword();
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
  Future<void> actionUpdatePassword() async {
    if (await ConnectionHelper.checkConnection()) {
      var actualPassword = _actualPassword;
      var newPassword = _newPassword;

      UpdatePassword updatePassword = new UpdatePassword(
          actualPassword: actualPassword,
          newPassword: newPassword);

      var statusCode = await UpdatePasswordService().updatePassword(updatePassword);

      if (statusCode == 200) {
        Fluttertoast.showToast(
            msg:
            "Password atualizada!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.amberAccent[100],
            textColor: Colors.black,
            fontSize: 16.0);
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => UserProfileScreen()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => ErrorMessageDialog(
              title: "Dado(s) invalido(s)",
              text: "A password atual não combina!"),
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