import 'dart:convert';

import 'package:campus_connection_app/Data/chatDetail.dart';
import 'package:campus_connection_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatMessage extends StatefulWidget {
  State<ChatMessage> createState() => _ChatMessage(name: name);
  ChatMessage({required this.name});
  final String name;
}

class _ChatMessage extends State<ChatMessage> {
  _ChatMessage({required this.name});
  final String name;
  TextEditingController messageController = TextEditingController();

  List<ChatDetail> history = [];

  void initState() {
    super.initState();
    getChat();
  }

  void getChat() async {
    final url = Uri.https(
        'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
        'chatSaveMessage.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    List<ChatDetail> _chatHistory = [];

    setState(() {
      for (final item in listData.entries) {
        if (item.value['user'] == name) {
          _chatHistory.add(ChatDetail(
              message: item.value['message'],
              sender: item.value['sender'],
              user: item.value['user']));
        }
      }
      history = _chatHistory;
    });
  }

  void sendMessage() async {
    if (messageController.text.isEmpty || messageController.text == '') {
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    final url = Uri.https(
        'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
        'chatSaveMessage.json');
    await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'message': messageController.text, 'sender': 'me', 'user': name}));
    setState(() {
      history.add(ChatDetail(
          message: messageController.text, sender: 'me', user: name));
    });
    final update = Uri.https(
        'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
        'chatSave.json');
    final updateResponse = await http.get(update);
    final Map<String, dynamic> findKey = json.decode(updateResponse.body);
    var _key = '';
    findKey.forEach((key, value) {
      if (value['name'] == name) {
        _key = key;
      }
    });
    if (_key.isEmpty || _key == '') {
      await http.post(update,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': name,
            'lastMessage': messageController.text,
            'time': 'Today'
          }));
    } else {
      final Map<String, dynamic> updateLast = {
        _key: {
          "name": name,
          "time": "Today",
          'lastMessage': messageController.text,
        }
      };
      try {
        final response = await http.patch(
          update,
          body: json.encode(updateLast),
        );

        if (response.statusCode == 200) {
          print('Data updated successfully');
        } else {
          print('Failed to update data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error updating data: $error');
      }
    }

    messageController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MainScreen();
                      }));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    child: Icon(Icons.person),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  )
                ],
              )),
            )),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: history.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    child: Align(
                      alignment: (history[index].sender == 'me'
                          ? Alignment.topRight
                          : Alignment.topLeft),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (history[index].sender == 'me'
                              ? Colors.blue
                              : Colors.grey.shade200),
                        ),
                        padding: EdgeInsets.all(15),
                        child: Text(
                          history[index].message,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ));
              },
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                child: Row(children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                              hintText: "Write Message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none))),
                  SizedBox(width: 15),
                  FloatingActionButton(
                    onPressed: () {
                      sendMessage();
                    },
                    child: Icon(Icons.send),
                  )
                ]),
              ),
            )
          ],
        ));
  }
}
