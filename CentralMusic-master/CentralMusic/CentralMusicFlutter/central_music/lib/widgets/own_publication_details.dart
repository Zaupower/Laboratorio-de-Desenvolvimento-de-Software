import 'package:central_music/helpers/storage_helper.dart';
import 'package:central_music/models/publicati_with_range.dart';
import 'package:central_music/pages/add_publication.dart';
import 'package:central_music/pages/edit_publication.dart';
import 'package:central_music/pages/image_slider.dart';
import 'package:central_music/services/chat_list_service.dart';
import 'package:central_music/services/main_page_services.dart';
import 'package:central_music/services/publication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:central_music/services/user_profile_service.dart';
import 'package:central_music/helpers/connection_helper.dart';
import 'package:central_music/pages/user_own_publications.dart';
import 'package:central_music/widgets/error_message_dialog.dart';
import 'package:central_music/pages/user_profile_page.dart';

import '../helpers/sizes_helpers.dart';

class OwnPublicationDetailsPage extends StatefulWidget {
  final PublicationWithRange gridItem;

  const OwnPublicationDetailsPage(
      {Key key, this.gridItem, BuildContext context})
      : super(key: key);

  @override
  _OwnPublicationDetailsPage createState() => _OwnPublicationDetailsPage();
}

class _OwnPublicationDetailsPage extends State<OwnPublicationDetailsPage> {
  List<String> userImgList = [];

  Color _favIconColor = Colors.black;
  String _isFavorite = "";

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  List<PublicationWithRange> favoriteList = new List();

  void getFavorites() {
    Services.getOwnPublications().then((value) {
      print("Favorite list length " + value.length.toString());
      favoriteList = value;
      print(favoriteList.isEmpty);

      if (!favoriteList.isEmpty) {
        for (PublicationWithRange p in favoriteList) {
          print(p.id);
          print(widget.gridItem.id);
          print(p.id == widget.gridItem.id);
          if (p.id == widget.gridItem.id) {
            print("a enviar true");
            setState(() {
              _favIconColor = Colors.amberAccent;
              print(_favIconColor);
              _isFavorite = "true";
            });
          }
        }
      } else {
        setState(() {
          _favIconColor = Colors.black;
          print(_favIconColor);
        });
        print(_isFavorite);
      }
    });
  }

  List<String> loadImagelist(int id, int max) {
    setState(() {
      for (int i = 0; i < max; i++) {
        userImgList.add("https://10.0.2.2:5001/images/Uploads/Posts/" +
            id.toString() +
            "/" +
            i.toString() +
            ".png");
      }
      print("max " + max.toString() + " USer list" + userImgList.toString());
    });
    return userImgList;
  }

  //

  //
  //  isFavoriteP(gridItem.id).then((value) {
  //    isFavorite = value;
  //  });
  //
  //
  // print("BBBBBB");

  // if(isFavorite == "false"){
  //   setState(() {
  //     _iconColor = Colors.black;
  //   });
  // }else{
  //   setState(() {
  //     _iconColor = Colors.amberAccent;
  //   });
  // }
  /**
      return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.black,
      centerTitle: true,
      title: Text(widget.gridItem.tittle),
      ),
      body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      Stack(alignment: Alignment.center, children: <Widget>[
      SizedBox(
      height: 200.0,
      width: 500.0,
      child: ImageSliderDemo(postList), //imgList
      ),
      ]), //Adicionar botao de gosto aqui
      Container(
      // height: 300.0,
      child: Row(children: [
      Container(
      alignment: Alignment.bottomLeft,
      child: Text("Preço: " +
      widget.gridItem.initialPrice.toString())),
      Container(
      width: 200.0,
      alignment: Alignment.bottomRight,
      child: IconButton(
      color: _favIconColor,
      onPressed: () {
      setState(() {
      _addRemoveFromFavorites(widget.gridItem.id, "false");
      });
      },
      icon: Icon(Icons.favorite),
      ),
      )
      ])),
      Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
      Text("Categoria: " + widget.gridItem.category.toString()),
      Text("Descrição: " + widget.gridItem.description.toString()),
      ],
      ),
      GestureDetector(
      onTap: () {
      createChat(widget.gridItem.utilizadorId);
      },
      child: Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
      gradient: LinearGradient(
      colors: [
      Colors.teal,
      Colors.teal[200],
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
      BoxShadow(
      color: Colors.black12,
      offset: Offset(5, 5),
      blurRadius: 10,
      )
      ],
      ),
      child: Center(
      child: Text(
      'Chat!',
      style: TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.w500,
      ),
      ),
      ),
      ),
      ),
      ],
      ),
      );
   */
  @override
  Widget build(BuildContext context) {
    print("VALOR DE _favorite" + _isFavorite);

    List<String> postList =
        loadImagelist(widget.gridItem.id, widget.gridItem.imagePath);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(top: 20),
              child: Text(
                widget.gridItem.tittle,
                style: TextStyle(fontSize: 22),
              ),
            ),

            Stack(alignment: Alignment.center, children: <Widget>[
              SizedBox(
                // height: 400.0,
                // width: 600.0,
                child: ImageSliderDemo(postList), //imgList
              ),
              Container(
                width: displayWidth(context) * 5,
                height: 450,
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.white,
                  child: Text(
                    'Eliminar anúncio',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  onPressed: () async {
                    await UserProfileService().deletePublication(widget.gridItem.id);
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfileScreen()),

                    );
                    Fluttertoast.showToast(
                        msg:
                        "Publicação eliminada com sucesso!",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.amberAccent[100],
                        textColor: Colors.black,
                        fontSize: 16.0);
                    //Send to API
                  },
                ),
              ),
              Container(
                width: displayWidth(context) * 5,
                height: 350,
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.white,
                  child: Text(
                    'Editar anúncio',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditPublication(widget.gridItem.id)),
                    );
                  },
                ),
              ),]
            ), //Adicionar botao de gosto aqui
            Container(
                // height: 300.0,
                child: Row(children: [
              Container(
                  width: displayWidth(context) * 0.3,
                  //alignment: Alignment.bottomLeft,

                  height: displayWidth(context) * 0.1,
                  margin: EdgeInsets.only(
                      top: 10, right: 10, left: displayWidth(context) * 0.05),
                  padding: EdgeInsets.only(left: 8.0, right: 8, top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.grey[350],
                  ),
                  child: Text(
                    "Initial Price: " +
                        widget.gridItem.initialPrice.toString() +
                        "€",
                    style: TextStyle(fontSize: 15),
                  )),
            ])),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: displayWidth(context) * 0.4,
                    height: displayWidth(context) * 0.1,
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(left: 8.0, right: 8, top: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Colors.grey[350],
                    ),
                    child: Text(
                        "Category: " + widget.gridItem.category.toString())),
                Container(
                    width: displayWidth(context) * 0.9,
                    height: displayWidth(context) * 0.4,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(
                        left: 10.0, top: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Colors.grey[350],
                    ),
                    child: Text("Description: ddsfgggggggggggggggggggggg"
                            "gggggggggggggggggggggggggggggggggggggggggggggggggggggg"
                            "gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg" +
                        widget.gridItem.description)),
              ],
            ),
          ],
        ),
      ),
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    print("VALOR DE _favorite" + _isFavorite);

    List<String> postList =
    loadImagelist(widget.gridItem.id, widget.gridItem.imagePath);

    //
    void _addRemoveFromFavorites(int id, String isFavorite) async {
      print(id);
      print("ISfavorite addRemoveF");
      print(isFavorite);
      if (_favIconColor == Colors.black) {
        await PublicationServices.addToFavorites(id).then((value) {
          callCostumToast("Adicionado aos favoritos");
          print("Value de add");
          print(value);
          setState(() {
            //  _isFavorite = "false";
            _favIconColor = Colors.amberAccent;
          });
        });
      } else if (_favIconColor == Colors.amberAccent) {
        await PublicationServices.removeFromFavorites(id).then((value) {
          callCostumToast("Removido dos favoritos");
          print("Value de remove");
          print(value);
          setState(() {
            _favIconColor = Colors.black;
            //  _isFavorite = "true";
          });
        });
      } else {
        callCostumToast("Sem operacoes possiveis");
      }
    }
    //

    //
    //  isFavoriteP(gridItem.id).then((value) {
    //    isFavorite = value;
    //  });
    //
    //
    // print("BBBBBB");

    // if(isFavorite == "false"){
    //   setState(() {
    //     _iconColor = Colors.black;
    //   });
    // }else{
    //   setState(() {
    //     _iconColor = Colors.amberAccent;
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(widget.gridItem.tittle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(alignment: Alignment.center, children: <Widget>[
            SizedBox(
              height: 200.0,
              width: 500.0,
              child: ImageSliderDemo(postList), //imgList
            ),
          ]),
          /*
          Container(
            child: RaisedButton(
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.white,
              child: Text(
                'Eliminar anúncio',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              onPressed: () async {
                await UserProfileService().deletePublication(widget.gridItem.id);
                Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen()),

                );
                Fluttertoast.showToast(
                    msg:
                    "Publicação eliminada com sucesso!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.amberAccent[100],
                    textColor: Colors.black,
                    fontSize: 16.0);
                //Send to API
              },
            ),
          ),
           */

          /*
          Container(
            child: RaisedButton(
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.white,
              child: Text(
                'Editar anúncio',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditPublication(widget.gridItem.id)),
                );
                //Send to API
              },
            ),
          ),
           */

          SizedBox(
            height: 100.0,
            child: Container(
              // height: 300.0,
              child: Row(children: [
                Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                        "Preço: " + widget.gridItem.initialPrice.toString())),
              ]),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Categoria: " + widget.gridItem.category.toString()),
              Text("Descrição: " + widget.gridItem.description.toString()),
            ],
          ),
        ],
      ),
    );
  }
  */

  // passar os dados
  Future<void> actionDeletePublication(int id) async {
    if (await ConnectionHelper.checkConnection()) {
      var statusCode =
          await UserProfileService().deletePublication(widget.gridItem.id);
      print(statusCode);

      if (statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserOwnPublications()),
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

  // passar os dados
  Future<void> actionUpdatePublication(int id) async {
    if (await ConnectionHelper.checkConnection()) {
      var statusCode =
          await UserProfileService().deletePublication(widget.gridItem.id);
      print(statusCode);

      if (statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserOwnPublications()),
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

void createChat2(int userId) async {
  final String token = await StorageHelper.readTokenID();
  print("TokenId: " + token + " userId:" + userId.toString());

  if (token != userId) {
    ChatListServices.createChat2(userId).then((value) {
      if (value == "Concluído!") {
        callCostumToast("Chat Criado com sucesso!");
      } else if (token == userId) {
        callCostumToast("Esta publicação é sua!");
      } else {
        callCostumToast("Chat ja existe!");
      }
    });
  }
}

void callCostumToast(String words) {
  Fluttertoast.showToast(
      msg: words,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.amberAccent[100],
      textColor: Colors.black,
      fontSize: 10.0);
}
