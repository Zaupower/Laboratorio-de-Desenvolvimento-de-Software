import 'package:central_music/services/chat_list_service.dart';
import 'package:central_music/services/main_page_services.dart';
import 'package:central_music/widgets/multi_select_form.dart';
import 'package:central_music/widgets/own_publication_details.dart';
import 'package:central_music/widgets/number_pickerr.dart';
import 'package:central_music/widgets/publication_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/signalr_client.dart';

import '../helpers/storage_helper.dart';
import '../models/publicati_with_range.dart';
import 'image_slider.dart';

class UserOwnPublications extends StatefulWidget {
  const UserOwnPublications({Key key}) : super(key: key);

  @override
  _UserOwnPublications createState() => _UserOwnPublications();
}

class _UserOwnPublications extends State<UserOwnPublications> {
  int range;


  String searchString = "";

  List<String> newAnimal = [];

  List<PublicationWithRange> publications;
  bool loading = true;
  num countValue = 1;
  num aspectWidth = 1;
  num aspectHeight = 1;

  List<MultiSelectDialogItem<int>> multiItem = List();
  List<int> selectedV = List();

  void _showMultiSelect(BuildContext context) async {
    multiItem = [];
    populateMultiselect();
    final items = multiItem;
    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
        );
      },
    );

    print(selectedValues);
    getvaluefromkey(selectedValues);
    print("Selected values" + selectedValues.toString());
    selectedV = selectedValues.toList();
    Services.getPublicationsWithKey(searchString, selectedV, range)
        .then((publicationss) {
      setState(() {
        publications = publicationss;

        publications = publications.reversed.toList();
      });
    });
    print("SElectV " + selectedV.toString());

    selectedValues.toList();
  }

  List<String> selectedCategories;
  final valuestopopulate = {
    1: "Cordas",
    2: "Teclas",
    3: "Sopro",
    4: "Percusao",
  };

  void getvaluefromkey(Set selection) {
    if (selection != null) {
      for (int x in selection.toList()) {
        print("AQUI " + valuestopopulate[x]);
      }
    }
  }

  void populateMultiselect() {
    for (int v in valuestopopulate.keys) {
      multiItem.add(MultiSelectDialogItem(v, valuestopopulate[v]));
    }
  }

  @override
  void initState() {
    super.initState();

    //Change grid view properties
    _incrementStartup();
    //loading = true;

    if (loading == true) {
      Services.getOwnPublications().then((publicationss) {
        setState(() {
          publications = publicationss;
          publications = publications.reversed.toList();
          loading = false;
        });
      });
    }
  }

  void onReceivePublication(List<Object> result) {
    PublicationWithRange p = new PublicationWithRange();
    print("Chegou ao SignalR onreceive method");
    print(result[0]);
    print(result[1]);
    print(result[2]);
    print(result[3]);
    print(result[4]);
    print(result[5]);
    print(result[6]);
    String dscpt = result[1];
    print(dscpt + " description to string");
    String tt = result[2];
    print(dscpt + " description to string");
    String cat = result[6];
    print(cat + "category");

    p.id = int.parse(result[0]);
    p.description = dscpt;
    p.imagePath = int.parse(result[3]);
    p.initialPrice = int.parse(result[4]);
    p.utilizadorId = int.parse(result[5]);
    p.tittle = tt;
    p.category = cat;

    print("Printando publicacao do signal");
    print(p.tittle);
    print(p.id.toString());
    print(p.description);
    print(p.imagePath);
    print(p.initialPrice.toString());
    print(p.utilizadorId.toString());

    setState(() {
      publications.insert(0, p);
    });
  }

  Future<int> _getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final startNumber = prefs.getInt('startNumber');
    if (startNumber == null) {
      return 0;
    }
    return startNumber;
  }

  bool boleano = false;

  Future<void> _incrementStartup() async {
    int lastStartupNumber = await _getIntFromSharedPref();

    if (lastStartupNumber == 0) {
      setState(() {
        countValue = 2;
        aspectWidth = 3;
        aspectHeight = 3;
      });
    } else {
      setState(() {
        countValue = 1;
        aspectWidth = 2;
        aspectHeight = 1;
      });
    }
  }

  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    int lastStartupNumber = await _getIntFromSharedPref();
    if (lastStartupNumber == 0) {
      await prefs.setInt('startNumber', 1);
    } else {
      await prefs.setInt('startNumber', 0);
    }
    setState(() {
      _incrementStartup();
    });
  }

  String dropdownValue = 'One';

  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 70),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              loading ? 'Loading...' : 'Carregue para visualizar o anúncio',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500]),
            ),
            ListTile(
              title: Row(children: [
                IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () => _resetCounter(),
                  color: Colors.amber,
                  //padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                ),
              ]),
            ),

            Expanded(
              child: GridView.count(
                crossAxisCount: countValue,
                childAspectRatio: (aspectWidth / aspectHeight),
                children: publications == null
                    ? []
                    : publications
                    .map((data) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OwnPublicationDetailsPage(context: context,  gridItem: data)));
                    },
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: 15.0, bottom: 5.0, left: 5.0, right: 5.0),
                        child: countValue == 1
                            ? buildRow(data)
                            : buildStack(data))))
                    .toList(),
              ),
            ),
          ]),
        ));
  }

  Container buildRow(PublicationWithRange data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3.0,
              blurRadius: 5.0)
        ],
        color: Colors.white,
      ),
      child: Row(children: [
        Hero(
          tag: data,
          child: Container(
            width: 125.0,
            height: 125.0,
            padding: EdgeInsets.only(left: 2.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://10.0.2.2:5001/images/Uploads/Posts/" +
                          data.id.toString() +
                          "/main/main.png")),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.amberAccent,
            ),
          ),
        ),
        Text(data.tittle,
            style: TextStyle(fontSize: 22, color: Colors.black),
            textAlign: TextAlign.center)
      ]),
    );

// NetworkImage("https://10.0.2.2:5001/images/Uploads/Posts/" + data.id.toString() + "/main/main.png"),
  }

  Container buildStack(PublicationWithRange data) {
    return Container(
      child: Column(
        children: [
          FadeInImage(
            imageErrorBuilder: (BuildContext context, Object exception,
                StackTrace stackTrace) {
              print('Error Handler');
              return Container(
                width: 100.0,
                height: 100.0,
                child: Image.asset("images/placeholder.png"),
              );
            },
            placeholder: AssetImage('images/loading.gif'),
            image: NetworkImage("https://10.0.2.2:5001/images/Uploads/Posts/" +
                data.id.toString() +
                "/main/main.png"),
            fit: BoxFit.cover,
            height: 100.0,
            width: 100.0,
          ),
          Text(data.tittle,
              style: TextStyle(fontSize: 22, color: Colors.black),
              textAlign: TextAlign.center)
        ],
      ),
    );
  }

  ChoiceChip buildChoiceChip() {
    return ChoiceChip(
        selected: _selected,
        label: Text('Categories'),
        elevation: 2,
        pressElevation: 1,
        shadowColor: Colors.teal,
        onSelected: (bool selected) {
          print('Fluter is pressed');
          setState(() {
            _showMultiSelect(context);
            _selected = !_selected;
          });
        });
  }

  int photoIndex = 0;

  List<String> userImgList = [];

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

  getGridViewSelectedItem(BuildContext context, PublicationWithRange gridItem) {
    List<String> postList = loadImagelist(gridItem.id, gridItem.imagePath);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(gridItem.tittle),
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
                        child: Text(
                            "Initial Price: " + gridItem.initialPrice.toString())),
                    Container(
                      width: 200.0,
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () {
                          createChat(gridItem.utilizadorId);
                        },
                        icon: Icon(Icons.favorite),
                      ),
                    )
                  ])),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Category: " + gridItem.category.toString()),
                  Text("Description: " + gridItem.description),
                ],
              ),
              GestureDetector(
                onTap: () {
                  createChat(gridItem.utilizadorId);
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
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
      },
    );
  }

  void createChat(int userId) async {
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

  List<PublicationWithRange> emptyListPublication =
  new List<PublicationWithRange>();

  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
          decoration: InputDecoration(hintText: 'Search...'),
          onSubmitted: (text) {
            //
            setState(() {
              searchString = text;
            });
            print("SearchString " + searchString);
            Services.getPublicationsWithKey(searchString, selectedV, range)
                .then((
                publicationss,
                ) {
              setState(() {
                if (publications.length > 0) {
                  publications = publicationss;
                  publications = publications.reversed.toList();
                } else {
                  callEmptyListToast();
                }
              });
            });
          }),
    );
  }

  void callEmptyListToast() {
    Fluttertoast.showToast(
        msg: "Não foram encontrados resultados da sua pesquisa",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.amberAccent[100],
        textColor: Colors.black,
        fontSize: 10.0);
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
}