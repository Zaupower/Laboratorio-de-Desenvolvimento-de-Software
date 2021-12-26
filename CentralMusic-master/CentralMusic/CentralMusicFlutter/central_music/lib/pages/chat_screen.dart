import 'dart:convert';

import 'package:central_music/models/message.dart';
import 'package:central_music/services/chat_list_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:http/http.dart' as http;
import 'package:central_music/models/chat.dart';

import '../helpers/storage_helper.dart';



class MessageListPage extends StatefulWidget {
  MessageListPage({Key key,@required this.chatInfo}) : super(key: key);
  Chat chatInfo;
  String publicationName;
  final String title = "titulo";

  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {

  final controller = new TextEditingController();
  final hubConnection =
      HubConnectionBuilder().withUrl("https://10.0.2.2:5001/chatHub").build();
  List<Message> messages = [];
  List<String> userd = [];
  List<Message> serverMessages;
  bool isOngroup = false;
  int myId = null;

  @override
  void initState() {
    super.initState();


    hubConnection.onclose((_) {
      print("Conexão perdida");
    });

    hubConnection.on("ReceiveMessage", onReceiveMessage);
    hubConnection.on("ReceiveGroupMessage", onReceiveMessage);
    startConnection();
      fetchMessages(widget.chatInfo.chatId).then((value) {
        setState(() {
          messages = value;
          messages = messages.reversed.toList();
        });

      });

    _getMyIdFromToken();

  }

  void _getMyIdFromToken()async{
    final String token = await StorageHelper.readTokenID();
    int tmpId = null;
    tmpId = int.parse(token);
    setState(() {
      myId = tmpId;
    });
  }

  Future<List<Message>> fetchMessages(int chatId) async {
    var url = 'https://10.0.2.2:5001/Chat/getMessagesFromChat?id=' +
        chatId.toString();
    var response = await http.get(url);
    var messagesDec = [];
    if (response.statusCode == 200) {
      debugPrint("response body marcelo " + response.body);
      var messagesd = json.decode(response.body);
      for (var messageJson in messagesd) {
        messages.add(Message.fromJson(messageJson));
      }
    }
    return messages;
  }

  void onReceiveMessage(List<Object> result) {
    setState(() {
      print(result);
      int senderIdN = int.parse(result[0]);
      Message newMessage = Message(
          id: 2,
          senderId: senderIdN,
          messageSend: result[1],
          time: DateTime.now());

      messages.add(newMessage);
      messages = messages.reversed.toList();
    });
  }

  void addToScreen() {
    setState(() {
      for (Message message in serverMessages) {
        messages.add(message);
      }
    });
  }

  void startConnection() async {
    await hubConnection.start();
  }

  Future<void> addtoGroup() async {
    final String token = await StorageHelper.readTokenID();
    userd.add(widget.chatInfo.chatId.toString());

    //ALTERAR USER ID
    userd.add(token);
    isOngroup = true;
    hubConnection.invoke("AddToGroup", args: userd).catchError((err) {
      print(err);
    });
  }

  void sendMessage() async {
    if (!isOngroup) {
      addtoGroup();
    }
    Message newMessage = new Message(
        chatId: widget.chatInfo.chatId,
        messageSend: controller.text.toString(),
        senderId: myId);
    print(newMessage.chatId);
    print(newMessage.messageSend);
    print(newMessage.senderId.toString());

    ChatListServices.addMessage(newMessage);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      fetchMessages(widget.chatInfo.chatId).then((value) {
        messages = value;
        List<Message> reversed = messages.reversed.toList();
        print("Messages dento do widget"+ messages[0].time.toString());
      });
    });

    print("Messages AQUI "+messages.toString());
    print("Messages AQUI "+messages.toString());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.amber[200],
        title: Text(widget.chatInfo.publicationName),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
                child: Container(
                 // padding: EdgeInsets.only(bottom: 200.0),
                  child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.only(top: 15.0, bottom: 100),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: messages[index].senderId == myId
                            ? EdgeInsets.only(
                                top: 8.0, bottom: 8.0, right: 10.0, left: 80.0)
                            : EdgeInsets.only(
                                top: 8.0, bottom: 8.0, right: 80.0, left: 10.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 15.0),
                        decoration: BoxDecoration(
                          color: messages[index].senderId == myId
                              ? Color(0xFFFFEFEE)
                              : Colors.brown[100],
                          borderRadius: messages[index].senderId == myId
                              ? BorderRadius.only(
                                  topRight: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                )
                              : BorderRadius.only(
                                  topRight: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(messages[index].messageSend),
                              Text(messages[index].time.toString(),style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10.0) ),
                            ]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        height: 70.0,
        color: Colors.white,
        child: Container(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: "Mensagem..."),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.message),
        onPressed: () {
          sendMessage();
        },
      ),
    );
  }
}
