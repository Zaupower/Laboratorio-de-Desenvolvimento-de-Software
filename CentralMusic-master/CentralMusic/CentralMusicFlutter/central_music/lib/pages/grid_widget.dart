import 'package:central_music/helpers/sizes_helpers.dart';
import 'package:central_music/models/address.dart';
import 'package:central_music/models/publicati_with_range.dart';
import 'package:central_music/models/publication_model.dart';
import 'package:central_music/services/chat_list_service.dart';
import 'package:central_music/services/main_page_services.dart';
import 'package:central_music/services/publication_service.dart';
import 'package:central_music/widgets/multi_select_form.dart';
import 'package:central_music/widgets/number_pickerr.dart';
import 'package:central_music/widgets/publication_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/signalr_client.dart';

import '../helpers/storage_helper.dart';
import 'image_slider.dart';

class GridWidget extends StatefulWidget {
  const GridWidget({Key key}) : super(key: key);

  @override
  _GridViewState createState() => _GridViewState();
}

class _GridViewState extends State<GridWidget> {
  int range;

  //To add  publications in realTime
  final hubConnection =
      HubConnectionBuilder().withUrl("https://10.0.2.2:5001/chatHub").build();
  final List<String> messages = new List<String>();

  List<NetworkImage> imagesList = List<NetworkImage>();

  String searchString = "";

  List<String> newAnimal = [];

  String _friendsVal;
  List _friendsNmae = ['David', 'John', 'Micheal'];

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
    //SignalR start/End Conection
    hubConnection.onclose((_) {
      print("Conexão perdida");
    });
    startConnection();
    hubConnection.on("onReceivePublication", onReceivePublication);

    //SignalR start/End Conection

    //Change grid view properties
    _incrementStartup();
    //loading = true;

    if (loading == true) {
      Services.getPublications().then((publicationss) {
        setState(() {
          publications = publicationss;
          publications = publications.reversed.toList();
          loading = false;
        });
      });
    }
    startConnection();
  }

  //SignalR
  void startConnection() async {
    await hubConnection.start(); // Inicia a conexão ao servidor
    print("Conexao iniciada com o servidor");
  }

  void onReceivePublication(List<Object> result) {
    PublicationWithRange p = new PublicationWithRange();
    print("Chegou ao SignalR onreceive method");
    print("Result" + result.toString());
    print(result[0]);
    print(result[1]);
    print(result[2]);
    print(result[3]);
    print(result[4]);
    print(result[5]);
    print(result[6]);
    print(result[7].toString() + "Possivelmente distric");
    String dscpt = result[1];
    print(dscpt + " description to string");
    String tt = result[2];
    print(dscpt + " description to string");
    String cat = result[6];
    print(cat + "category");
    String distric = result[7];
    print("distric");
    p.id = int.parse(result[0]);
    p.description = dscpt;
    p.imagePath = int.parse(result[3]);
    p.initialPrice = int.parse(result[4]);
    p.utilizadorId = int.parse(result[6]);
    p.tittle = tt;
    p.category = cat;
    Address adr = new Address(
      street: "Street",
      streetNumber: 44,
      postalCode: "0000-00",
      district: distric,
      country: "Portugal",
    );
    p.userAddress = adr;

    print("Printando publicacao do signal");
    print(p.tittle);
    print(p.id.toString());
    print(p.description);
    print(p.imagePath);
    print(p.initialPrice.toString());
    print(p.utilizadorId.toString());
    print(p.userAddress.district);

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
        aspectHeight = 5;
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
            margin: EdgeInsets.only(top: displayWidth(context) * 0.1),
        padding: EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            loading ? 'Loading...' : 'Publicações',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.amber[200]),
          ),
          _searchBar(),
          ListTile(
            title: Row(children: [
              IconButton(
                icon: Icon(Icons.list),
                onPressed: () => _resetCounter(),
                color: Colors.amber[200],
                //padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              ),
              buildChoiceChip(),
              Text("  Distancia: "),
              Container(
                width: 80,
                child: TextFormField(
                  onFieldSubmitted: (String value) {
                    print(value);
                    setState(() {
                      range = int.parse(value);
                      Services.getPublicationsWithKey(
                              searchString, selectedV, range)
                          .then((
                        publicationss,
                      ) {
                        setState(() {
                          if (publicationss.length > 0) {
                            publications = publicationss;
                            publications.sort((a, b) =>  a.range.compareTo(b.range));
                          } else {
                            callEmptyListToast();
                          }
                        });
                      });
                    });
                  }, // Just a custom input decoration...
                ),
              ),
            ]),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: countValue,
              childAspectRatio: (aspectWidth / aspectHeight),
              children: publications == null ? [] : publications
                      .map((data) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        getGridViewSelectedItem2(context: context, gridItem: data)));
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
      ),

      );
  }

  String isF = "true";

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
        color: Colors.white24,
      ),
      child: Row(children: [
        Hero(
          tag: data,
          child: Container(
            width: displayWidth(context) * 0.35,
            height: displayWidth(context) * 0.40,
            padding: EdgeInsets.only(left: 30.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://10.0.2.2:5001/images/Uploads/Posts/" +
                          data.id.toString() +
                          "/main/main.png")),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.amber[200],
            ),
          ),
        ),
        Column(
            children:[
              Text("  ",
                  style: TextStyle(fontSize: 22, color: Colors.black),
                  textAlign: TextAlign.center),
             Text("  "+data.tittle,
                style: TextStyle(fontSize: 22, color: Colors.black),
                textAlign: TextAlign.start),
              Text("  "+data.initialPrice.toString() + "€",
                  style: TextStyle(fontSize: 22, color: Colors.black),
                  textAlign: TextAlign.center),
              Text("  "+data.userAddress.district,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center),
          ]),
      ]),
    );

  }

  Container buildStack(PublicationWithRange data) {
    return Container(
      width: 200,
      height: 400,
      padding: EdgeInsets.only(top: 4.0),
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
      child: Column(

            children: [
              Container(

                width: displayWidth(context) * 0.40,
              height: displayWidth(context) * 0.35,
              margin: EdgeInsets.only(top: 7),
              padding: EdgeInsets.only(left: 2.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://10.0.2.2:5001/images/Uploads/Posts/" +
                            data.id.toString() +
                            "/main/main.png")),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color:Colors.amber[200],
              ),
              ),
                    Text("  ",
                        style: TextStyle(fontSize: 22, color: Colors.black),
                        textAlign: TextAlign.center),
                    Text("  "+data.tittle,
                        style: TextStyle(fontSize: 22, color: Colors.black),
                        textAlign: TextAlign.start),
                    Text("  "+data.initialPrice.toString() + "€",
                        style: TextStyle(fontSize: 22, color: Colors.black),
                        textAlign: TextAlign.center),
                    Text("  "+data.userAddress.district,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.center),
            ],
          ),
    );

  }

  ChoiceChip buildChoiceChip() {
    return ChoiceChip(
        selected: _selected,
        label: Text('Categorias', style: TextStyle(color:Colors.black),),
        elevation: 0,
        pressElevation: 0,
        selectedColor:Colors.amber[200],
        shadowColor:Colors.amber[200],
        onSelected: (bool selected) {
          print('Fluter is pressed');
          setState(() {
            _showMultiSelect(context);
            if(selectedV.isEmpty){
              _selected = !_selected;
            }

          });
        });
  }


  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
          decoration: InputDecoration(hintText: 'Pesquise...'),
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
        backgroundColor:Colors.amber[200],
        textColor: Colors.black,
        fontSize: 10.0);
  }

  void callCostumToast(String words) {
    Fluttertoast.showToast(
        msg: words,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor:Colors.amber[200],
        textColor: Colors.black,
        fontSize: 10.0);
  }
}
