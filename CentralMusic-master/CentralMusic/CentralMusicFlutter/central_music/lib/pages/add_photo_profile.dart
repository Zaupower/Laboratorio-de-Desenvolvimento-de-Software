import 'package:central_music/enums/categories.dart';
import 'package:central_music/enums/condition.dart';
import 'package:central_music/models/add_photo_model.dart';
import 'package:central_music/models/address.dart';
import 'package:central_music/models/publicati_with_range.dart';
import 'package:central_music/models/publication_create.dart';
import 'package:central_music/models/publication_model.dart';
import 'package:central_music/services/image_publication_upload.dart';
import 'package:central_music/services/publication_service.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:recase/recase.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_client/utils.dart';

import '../widgets/custom_toast.dart';

class AddPhoto extends StatefulWidget {
  @override
  _AddPhoto createState() => _AddPhoto();

  AddPhoto({Key key}) : super(key: key);
}

class _AddPhoto extends State<AddPhoto> {
  List<Asset> images = List<Asset>();
  String mainImageValue = null;

  List<String> mainImagePick = new List<String>();
  Categories categoryValue = null;
  Conditions conditionsValue = null;
  bool isTradable = false;

  Future<void> pickImages() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Adicionar foto de perfil",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      images = resultList;
      mainImagePick = new List<String>();
      for (int i = 0; i < images.length; i++) {
        mainImagePick.add(i.toString());
      }
    });
  }

  Future<void> save() async {
    var imagePath = images.length;

    print("Main Image Value : " + mainImageValue.toString());
    if (mainImageValue != null) {
      ImagePublicationServices.addImageProfile(
        images[0],
      ).then((value) {
        print("Enviando pelo signalR");
      });
    } else {
      CallCostumToast("Por favor carregue a sua imagem");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          appBar: new AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0,
            backgroundColor: Colors.amber[200],
            title: const Text('Adicionar imagem'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.save),
                tooltip: 'Guardar',
                onPressed: () {
                  save();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
              child: Column(children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      height: 300.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(images.length, (index) {
                          Asset asset = images[index];
                          return Container(
                            width: 160,
                            height: 200,
                            child: AssetThumb(
                              asset: asset,
                              width: 160,
                              height: 199,
                            ),
                          );
                        }),
                      ),
                    ),
                    RaisedButton(
                      child: Text("Escolher imagem"),
                      onPressed: pickImages,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Imagem Principal',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      value: mainImageValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      isExpanded: true,
                      elevation: 16,
                      items: mainImagePick.map((String mianImage) {
                        return DropdownMenuItem<String>(
                          value: mianImage,
                          child: Text(new ReCase(mianImage).titleCase),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        //post.category = newValue as String;
                        setState(() {
                          mainImageValue = newValue;
                        });
                      },
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                  ],
                ),
              ])),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
