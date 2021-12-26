import 'package:central_music/models/user_edit.dart';
import 'package:central_music/pages/user_profile_page.dart';
import 'package:central_music/services/user_profile_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../helpers/connection_helper.dart';
import '../models/address.dart';
import '../widgets/error_message_dialog.dart';

class UserEditPage extends StatefulWidget {
  @override
  _UserEditPage createState() => _UserEditPage();

  UserEditPage({Key key}) : super(key: key);
}

class _UserEditPage extends State<UserEditPage> {
  String _email;
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
              color:
                  myFocusNodeFirstName.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
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
        onSaved: (String value) {
          _lastName = value;
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
              color: myFocusNodeStreetNumber.hasFocus
                  ? Colors.blue
                  : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
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
              color:
                  myFocusNodePostalCode.hasFocus ? Colors.blue : Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.amber)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
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
                              color: Colors.amber[300],
                              child: Text(
                                'Alterar dados',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                _formKey.currentState.save();
                                await actionUpdateUser();
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
  Future<void> actionUpdateUser() async {
    if (await ConnectionHelper.checkConnection()) {
      var firstName = _firstName;
      var lastName = _lastName;
      var email = _email;
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

      UserEdit edit = new UserEdit(
          firstName: firstName,
          lastName: lastName,
          email: email,
          localization: address);

      var statusCode = await UserProfileService().updateUser(edit);
      print(statusCode);

      if (statusCode == 200) {
        Fluttertoast.showToast(
            msg:
            "Dados atualizados!",
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
