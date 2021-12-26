import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/storage_helper.dart';


class Profile extends StatelessWidget {

  Profile({Key key,});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
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

        //Foto de perfil
        child: Container(
          width: double.infinity,
          height: 150,
          child: Container(
            alignment: Alignment(0, 15.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://10.0.2.2:5001/images/Uploads/Users/16/main.png"),
              radius: 70.0,
            ),
          ),
        ),
      ),
    ]);
  }
}