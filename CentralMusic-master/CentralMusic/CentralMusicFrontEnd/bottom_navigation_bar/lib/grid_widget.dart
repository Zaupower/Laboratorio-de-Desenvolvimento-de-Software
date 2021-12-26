import 'package:bottom_navigation_bar/publication_model.dart';
import 'package:bottom_navigation_bar/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/signalr_client.dart';

class GridWidget extends StatefulWidget {
  const GridWidget({Key key}) : super(key: key);

  GridViewState createState() => GridViewState();
}

class GridViewState extends State {
  //To add  publications in realTime
  final hubConnection = HubConnectionBuilder().withUrl("https://10.0.2.2:5001/chatHub").build();
  final List<String> messages = new List<String>();

  List<Publication> _publications;
  bool loading;
  num countValue = 1;
  num aspectWidth = 1;
  num aspectHeight = 1;

  @override
  void initState() {
    super.initState();
    //SignalR start/End Conection
    hubConnection.onclose((_) {
      print("Conexão perdida");
    });

    hubConnection.on("onReceivePublication", onReceivePublication);
    startConnection();
    //SignalR start/End Conection

    //Change grid view properties
    _incrementStartup();
    loading = true;
    Services.getPublications().then((publications) {
      setState(() {
        _publications = publications;
        loading = false;
      });

    });
  }

  //SignalR
  void startConnection() async {
    await hubConnection.start(); // Inicia a conexão ao servidor
  }

  void onReceivePublication(List<Object> result) {
    setState(() {
    Publication p = new Publication();
    p.description = result[0];
    p.tittle = result[1];
    _publications.insert(0, p);
     });

    print(result);
  }

  Future<int> _getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final startNumber = prefs.getInt('startNumber');
    if (startNumber == null) {
      return 0;
    }
    return startNumber;
  }

  Future<void> _incrementStartup() async {
    int lastStartupNumber = await _getIntFromSharedPref();

    if (lastStartupNumber == 0) {
      setState(() {
        countValue = 3;
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loading ? 'Loading...' : 'Publications',
        ),
      ),
      body: Container(
        child: Column(children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: countValue,
              childAspectRatio: (aspectWidth / aspectHeight),
              children: _publications == null? []: _publications
                  .map((data) => GestureDetector(
                      onTap: () {
                        getGridViewSelectedItem(context, data);
                      },
                      child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          color: Colors.lightBlueAccent,
                          child: Stack(
                              children:[FadeInImage(
                              imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                      print('Error Handler');
                      return Container(
                      width: 100.0,
                      height: 100.0,
                      child: Image.asset("images/placeholder.png"),
                      );
                      },
                        placeholder: AssetImage('images/loading.gif'),
                        image: NetworkImage("https://10.0.2.2:5001/images/Uploads/Posts/"+data.id.toString()+"/0.png"),
                        fit: BoxFit.cover,
                        height: 100.0,
                        width: 100.0,
                      ),
                                Text(data.tittle,

                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                  textAlign: TextAlign.center)
                          ])
                      )
              )).toList(),
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: RaisedButton(
                onPressed: () => _resetCounter(),
                child: Text(' Change GridView Mode To ListView '),
                textColor: Colors.white,
                color: Colors.red,
                padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              ))
        ]),
      ),
    );
  }


  getGridViewSelectedItem(BuildContext context, Publication gridItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(gridItem.description),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
