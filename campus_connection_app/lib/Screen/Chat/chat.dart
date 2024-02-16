import 'dart:convert';
import 'searchUser.dart';
import 'package:campus_connection_app/Data/chatUsers.dart';
import 'chatMessage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {
  List<ChatUsers> _outputChat = [];

  var lowerIndex = 0;

  void initState() {
    super.initState();
    getChat();
  }

  void getChat() async {
    final url = Uri.https(
        'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
        'chatSave.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    List<ChatUsers> _chatUser = [];
    setState(() {
      for (final item in listData.entries) {
        _chatUser.add(ChatUsers(
            name: item.value['name'],
            messageText: item.value['lastMessage'],
            time: item.value['time']));
      }
      _outputChat = _chatUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text("Nothing here"));
    setState(() {
      if (_outputChat.isNotEmpty) {
        getChat();
        content = ListView.builder(
          itemCount: _outputChat.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 16),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChatMessage(
                    name: _outputChat[index].name,
                  );
                }));
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                child: Row(children: [
                  Expanded(
                      child: Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person),
                        maxRadius: 30,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: Container(
                              color: Colors.transparent,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_outputChat[index].name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(_outputChat[index].messageText,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.normal)),
                                  ])))
                    ],
                  )),
                  Text(
                    _outputChat[index].time,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ]),
              ),
            );
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Connection'),
        centerTitle: true,
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SearchUser();
            }));
          }),
    );
  }
}
