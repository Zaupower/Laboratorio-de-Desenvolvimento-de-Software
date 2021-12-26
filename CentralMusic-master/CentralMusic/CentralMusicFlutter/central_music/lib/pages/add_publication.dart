import 'package:central_music/enums/categories.dart';
import 'package:central_music/enums/condition.dart';
import 'package:central_music/helpers/storage_helper.dart';
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

import '../helpers/sizes_helpers.dart';
import '../widgets/navigation_bar_controller.dart';
import 'grid_widget.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPage createState() => _SecondPage();

  SecondPage({Key key}) : super(key: key);
}

class _SecondPage extends State<SecondPage> {
  bool finalized = false;
  List<Asset> images = List<Asset>();
  final hubConnection =
      HubConnectionBuilder().withUrl("https://10.0.2.2:5001/chatHub").build();

  @override
  void initState() {
    super.initState();
    hubConnection.onclose((_) {
      print("Conexão perdida");
    });

    //hubConnection.on("sendMessage", onReceiveMessage);
    startConnection();
  }

  void startConnection() async {
    await hubConnection.start();
  }

  void sendMessage(
      String id, String description, String tittle, String imagePath, String price, String userId, String cat, String district) async {
    print("SEND MESSAGE"+district);
    await hubConnection.invoke("SendMessage", args: <Object>[
      id,
      description,
      tittle,
      imagePath,
      price,
      userId,
      cat,
      district,
    ]).catchError((err) {
      print(err);
    });
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  PublicationCreate post = new PublicationCreate();

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
          actionBarTitle: "FlutterCorner.com",
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
    var utilizadorId = 0;

    var tittle = _titleController.text;
    //var tittle = "_titleController.text";
    var description = _descriptionController.text;
    //var description = "_descriptionController.text";
    var tradable = isTradable;
    var category = Categories.Percusao;
    var imagePath = images.length;
    var initialPrice = int.parse(_priceController.text);
    //var initialPrice = 111;
    var instrumentCondition = conditionsValue;

    var street = _streetController.text;

    //var street = "Rua nova";
    var streetNumber = int.parse(_streetNumberController.text);
    //var streetNumber = 22;
    var postalCode = _postalCodeController.text;
    //var postalCode = "4444-222";
    var district = _districtController.text;
    //var district = "Suiça";
    var country = _countryController.text;
    //var country = "Portugal";

    Address address = new Address(
        street: street,
        streetNumber: int.parse(streetNumber.toString()),
        postalCode: postalCode,
        district: district,
        country: country);

    PublicationCreate p = new PublicationCreate(
        utilizadorId: utilizadorId,
        tittle: tittle,
        description: description,
        tradable: tradable,
        category: category,
        imagePath: imagePath,
        initialPrice: initialPrice,
        instrumentCondition: instrumentCondition,
        localization: address);
    // print("OPPPPPPPPPPP : " + p.tittle);
    // print("OPPPPPPPPPPP : " + p.description);
    // print("OPPPPPPPPPPP : " + p.localization.toString());
    // print("OPPPPPPPPPPP : " +
    //     EnumToString.convertToString(p.instrumentCondition));
    // print("OPPPPPPPPPPP : " + p.initialPrice.toString());
    // print("OPPPPPPPPPPP : " + p.imagePath.toString());
    // print("OPPPPPPPPPPP : " + EnumToString.convertToString(p.category));
    // print("OPPPPPPPPPPP : " + p.tradable.toString());
    // print("OPPPPPPPPPPP : " + p.utilizadorId.toString());

    PublicationWithRange pResult = new PublicationWithRange();

    if (mainImageValue != null) {
      PublicationServices.postPublications(p).then((value) {
        List<String> listResult = new List();
        listResult = value;
        print("pResultID: " +listResult.toString());
        CallCostumToast("Publicação criada com sucesso!");

     //   print("Main Image Value : " + mainImageValue.toString());

          print("Chegou aqui!"+listResult[0]);
          String puu = listResult[1];
          int pubId = int.parse(puu);
          print(pubId);
          ImagePublicationServices.postImagesPublications(pubId, images, images[int.parse(mainImageValue)],
          ).then((value) {
            print("Enviando pelo signalR");
            sendMessage(listResult[1], listResult[2], listResult[0], images.length.toString(), listResult[3], listResult[4], listResult[5], listResult[7]);



          });

      });

    } else {
    CallCostumToast("Erro, por favor preencha todos os campos");
    }

  }

  CallCostumToast(String words) {
    Fluttertoast.showToast(
        msg: words,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.amberAccent[100],
        textColor: Colors.black,
        fontSize: 10.0);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
          appBar: new AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0,
            backgroundColor: Colors.amber[200],
            title: const Text('Crie uma publicação'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.save),
                color: Colors.black,
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
                      margin: EdgeInsets.only(left:  (displayWidth(context) * 0.05), right: (displayWidth(context) * 0.05)),
                        child: AssetThumb(
                          asset: asset,
                          width: (displayWidth(context) * 0.35).toInt(),
                          height: (displayWidth(context) * 0.40).toInt(),
                        ),
                      );
                    }),
                  ),
                ),
                RaisedButton(
                  child: Text("Pick images"),
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
                  height: 70.0,
                ),
                Text(
                  "Preencha os dados abaixo: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  controller: _titleController,
                  cursorColor: Colors.white,
                  style: TextStyle(decorationColor: Colors.white),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  controller: _descriptionController,
                  cursorColor: Colors.white,
                  style: TextStyle(decorationColor: Colors.white),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Preço Inicial',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Rua',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  cursorColor: Colors.white,
                  controller: _streetController,
                  style: TextStyle(decorationColor: Colors.white),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Número de Porta',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  cursorColor: Colors.white,
                  controller: _streetNumberController,
                  style: TextStyle(decorationColor: Colors.white),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Código postal',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  cursorColor: Colors.white,
                  controller: _postalCodeController,
                  style: TextStyle(decorationColor: Colors.white),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Cidade',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  cursorColor: Colors.white,
                  controller: _districtController,
                  style: TextStyle(decorationColor: Colors.white),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'País',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  cursorColor: Colors.white,
                  controller: _countryController,
                  style: TextStyle(decorationColor: Colors.white),
                ),
                SizedBox(
                  height: 10.0,
                ),
                DropdownButtonFormField<Categories>(
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  value: categoryValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  isExpanded: true,
                  elevation: 16,
                  items: Categories.values.map((Categories category) {
                    return DropdownMenuItem<Categories>(
                      value: category,
                      child: Text(
                          new ReCase(EnumToString.convertToString(category))
                              .titleCase),
                    );
                  }).toList(),
                  onChanged: (Categories newValue) {
                    setState(() {
                      categoryValue = newValue;
                    });
                  },
                ),
                DropdownButtonFormField<Conditions>(
                  decoration: InputDecoration(
                    labelText: 'Condição',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  value: conditionsValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  isExpanded: true,
                  elevation: 16,
                  items: Conditions.values.map((Conditions conditions) {
                    return DropdownMenuItem<Conditions>(
                      value: conditions,
                      child: Text(
                          new ReCase(EnumToString.convertToString(conditions))
                              .titleCase),
                    );
                  }).toList(),
                  onChanged: (Conditions newValue) {
                    setState(() {
                      conditionsValue = newValue;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                CheckboxListTile(
                  title: Text(
                    "Negociável",
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                  activeColor: Colors.black,
                  contentPadding: EdgeInsets.zero,
                  value: isTradable,
                  onChanged: (newValue) {
                    setState(() {
                      isTradable = newValue;
                    });
                  }, //  <-- leading Checkbox
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 25.0,
                ),
              ],
            ),
          ])),
        );
  }
}
