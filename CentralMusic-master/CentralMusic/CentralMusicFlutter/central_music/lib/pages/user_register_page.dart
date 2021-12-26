import 'package:central_music/services/user_register_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:central_music/helpers/connection_helper.dart';
import 'package:central_music/models/address.dart';
import 'package:central_music/models/user_register.dart';
import 'package:central_music/pages/login_page.dart';
import 'package:central_music/widgets/error_message_dialog.dart';

class UserRegisterPage extends StatefulWidget {
  @override
  _UserRegisterPage createState() => _UserRegisterPage();
}

class _UserRegisterPage extends State<UserRegisterPage> {
  String _email;
  String _password;
  String _firstName;
  String _lastName;
  String _street;
  String _streetNumber;
  String _postalCode;
  String _disctrict;
  String _country;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode myFocusNodeFirstName = new FocusNode();
  FocusNode myFocusNodeLastName = new FocusNode();
  FocusNode myFocusNodeEmail = new FocusNode();
  FocusNode myFocusNodePassword = new FocusNode();
  FocusNode myFocusNodeStreet = new FocusNode();
  FocusNode myFocusNodeStreetNumber = new FocusNode();
  FocusNode myFocusNodePostalCode = new FocusNode();
  FocusNode myFocusNodeDistrict = new FocusNode();
  FocusNode myFocusNodeCountry = new FocusNode();

  Widget firstNameWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.name,
        focusNode: myFocusNodeFirstName,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Primeiro nome',
          labelStyle: TextStyle(
              color: myFocusNodeFirstName.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (String value) {
          String patttern = r'(^[a-zA-Z ]*$)';
          RegExp regExp = new RegExp(patttern);
          if (value.length == 0) {
            return "Introduza um nome";
          } else if (!regExp.hasMatch(value)) {
            return "O nome deve conter caracteres de a-z ou A-Z";
          }
          return null;
        },
        onSaved: (String value) {
          _firstName = value;
        },
      ),
    );
  }

  Widget lastNameWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.name,
        focusNode: myFocusNodeLastName,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Último nome',
          labelStyle: TextStyle(
              color: myFocusNodeLastName.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (String value) {
          String patttern = r'(^[a-zA-Z ]*$)';
          RegExp regExp = new RegExp(patttern);
          if (value.length == 0) {
            return "Introduza um nome";
          } else if (!regExp.hasMatch(value)) {
            return "O nome deve conter caracteres de a-z ou A-Z";
          }
          return null;
        },
        onSaved: (String value) {
          _lastName = value;
        },
      ),
    );
  }

  Widget passwordWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.text,
        focusNode: myFocusNodePassword,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Password',
          labelStyle: TextStyle(
              color: myFocusNodePassword.hasFocus ? Colors.blue : Colors.black),
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

  Widget streetWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.streetAddress,
        focusNode: myFocusNodeStreet,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Rua',
          labelStyle: TextStyle(
              color: myFocusNodeStreet.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (String value) {
          String patttern = r'(^[a-zA-Z ]*$)';
          RegExp regExp = new RegExp(patttern);
          if (value.length == 0) {
            return "Introduza uma rua";
          } else if (value.length < 5) {
            return "A rua deve ter no mínimo 6 caracteres";
          }
          return null;
        },
        onSaved: (String street) {
          _street = street;
        },
      ),
    );
  }

  Widget streetNumberWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.number,
        focusNode: myFocusNodeStreetNumber,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Número de rua',
          labelStyle: TextStyle(
              color: myFocusNodeStreetNumber.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (String value) {
          String patttern = r'(^[a-zA-Z ]*$)';
          RegExp regExp = new RegExp(patttern);
          if (value.length == 0) {
            return "Introduza o número da rua";
          }
          return null;
        },
        onSaved: (String streetNumber) {
          _streetNumber = streetNumber;
        },
      ),
    );
  }

  Widget postalCodeWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.streetAddress,
        focusNode: myFocusNodePostalCode,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Código postal',
          labelStyle: TextStyle(
              color: myFocusNodePostalCode.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (String value) {
          String patttern = r'(^[a-zA-Z ]*$)';
          RegExp regExp = new RegExp(patttern);
          if (value.length == 0) {
            return "Introduza o seu código postal";
          } else if (value.length < 3) {
            return "O código postal deve ter no minimo 4 caracteres";
          }
          return null;
        },
        onSaved: (String postalCode) {
          _postalCode = postalCode;
        },
      ),
    );
  }

  Widget districtWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.streetAddress,
        focusNode: myFocusNodeDistrict,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Distrito',
          labelStyle: TextStyle(
              color: myFocusNodeDistrict.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (String value) {
          String patttern = r'(^[a-zA-Z ]*$)';
          RegExp regExp = new RegExp(patttern);
          if (value.length == 0) {
            return "Introduza uma morada";
          } else if (value.length < 5) {
            return "O distrito deve ter no mínimo 6 caracteres";
          }
          return null;
        },
        onSaved: (String district) {
          _disctrict = district;
        },
      ),
    );
  }

  Widget countryWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      child: TextFormField(
        keyboardType: TextInputType.streetAddress,
        focusNode: myFocusNodeCountry,
        style: TextStyle(
          color: Colors.black,
          decorationColor: Colors.black, //Font color change
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'País',
          labelStyle: TextStyle(
              color: myFocusNodeCountry.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (String value) {
          String patttern = r'(^[a-zA-Z ]*$)';
          RegExp regExp = new RegExp(patttern);
          if (value.length == 0) {
            return "Introduza um país";
          } else if (value.length < 3) {
            return "O país deve ter no mínimo 3 caracteres";
          }
          return null;
        },
        onSaved: (String country) {
          _country = country;
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
                            emailWidget(),
                            passwordWidget(),
                            firstNameWidget(),
                            lastNameWidget(),
                            streetWidget(),
                            streetNumberWidget(),
                            postalCodeWidget(),
                            districtWidget(),
                            countryWidget(),
                            SizedBox(height: 30),
                            RaisedButton(
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              color: Colors.white,
                              child: Text(
                                'Registar',
                                style:
                                    TextStyle(color: Colors.black, fontSize: 16),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                _formKey.currentState.save();
                                await actionRegisterUser();

                                Fluttertoast.showToast(
                                    msg:
                                        "Agora pode fazer Login com os seus dados",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: Colors.amberAccent[100],
                                    textColor: Colors.black,
                                    fontSize: 16.0);
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
  Future<void> actionRegisterUser() async {
    if (await ConnectionHelper.checkConnection()) {
      var firstName = _firstName;
      var lastName = _lastName;
      var email = _email;
      var password = _password;
      var street = _street;
      var streetNumber = _streetNumber;
      var postalCode = _postalCode;
      var district = _disctrict;
      var country = _country;

      Address address = new Address(
          street: street,
          streetNumber: int.parse(streetNumber.toString()),
          postalCode: postalCode,
          district: district,
          country: country);

      UserRegister register = new UserRegister(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          localization: address);

      var statusCode = await UserRegisterService().createUserRegister(register);

      if (statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
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
