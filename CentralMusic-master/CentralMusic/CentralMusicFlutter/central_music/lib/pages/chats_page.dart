
import 'package:central_music/models/chat.dart';
import 'package:central_music/services/chat_list_service.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'edit_publication.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<Chat> chats = new List<Chat>();

  //
  @override
  void initState() {
    super.initState();
    _getChats();
  }

  Future<void> _getChats() async{
    ChatListServices.getChats().then((value) {
      setState(() {
        print(value);
        chats = value;
        print(chats.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
          onRefresh: _getChats,
          child: Container(
            padding: EdgeInsets.only(top: 30.0),
            child: ListView.builder(
              itemCount: chats.length,
                itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.amber[100],
                  child: new ListTile(
                    title: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    MessageListPage(chatInfo: chats[index],)
                            ),
                          ),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.amber[100],
                              borderRadius: BorderRadius.circular(60 / 2),
                              image: DecorationImage(
                                image: NetworkImage("https://10.0.2.2:5001/images/Uploads/Posts/" +
                                    chats[index].publicationId.toString() +
                                    "/main/main.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: <Widget>[
                            Text( chats[index].publicationName,
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MessageListPage(chatInfo: chats[index],),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ));
  }
}
