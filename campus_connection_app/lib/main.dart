import 'dart:async';
import 'dart:convert';
import 'package:campus_connection_app/Data/userData.dart';
import 'package:http/http.dart' as http;
import 'Data/userChatData.dart';
import 'Data/chatData.dart';
import 'Screen/Chat/chat.dart';
import 'package:flutter/material.dart';
import 'Screen/Schedule/schedule.dart';
import 'Screen/profile/profile.dart';

void main() async {
  runApp(MyApp());
  final chaturl = Uri.https(
      'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
      'chatSave.json');
  final chatresponse = await http.get(chaturl);
  final saveMessageurl = Uri.https(
      'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
      'chatSaveMessage.json');
  final saveMessageresponse = await http.get(saveMessageurl);
  final userurl = Uri.https(
      'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
      'chatSaveUser.json');
  final userresponse = await http.get(userurl);
  if (chatresponse.body == 'null' ||
      saveMessageresponse.body == 'null' ||
      userresponse.body == 'null') {
    Timer(Duration(seconds: 5), () {
      runApp(MaterialApp(
        home: MainScreen(),
      ));
    });
  } else {
    runApp(MaterialApp(
      home: MainScreen(),
    ));
  }
}

class MyApp extends StatefulWidget {
  State<MyApp> createState() => _homePage();
}

class _homePage extends State<MyApp> {
  void initState() {
    super.initState();
    saveChat();
    saveChatMessage();
    saveChatUser();
  }

  void saveChat() async {
    final url = Uri.https(
        'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
        'chatSave.json');
    final response = await http.get(url);
    if (response.body == 'null') {
      for (final item in UserChatData().allUser) {
        await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'name': item.name,
              'lastMessage': item.messageText,
              'time': item.time
            }));
      }
    }
  }

  void saveChatMessage() async {
    final url = Uri.https(
        'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
        'chatSaveMessage.json');
    final response = await http.get(url);
    if (response.body == 'null') {
      for (final item in ChatData().messages) {
        await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'message': item.message,
              'sender': item.sender,
              'user': item.user
            }));
      }
    }
  }

  void saveChatUser() async {
    final url = Uri.https(
        'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
        'chatSaveUser.json');
    final response = await http.get(url);
    if (response.body == 'null') {
      for (final item in UserData().allUser) {
        await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'user': item.user,
              'position': item.position,
            }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Campus Connection',
        home: Center(child: CircularProgressIndicator()));
  }
}

class MainScreen extends StatefulWidget {
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  var lowerIndex = 0;
  final screens = [Chat(), Schedule(), Profile()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: screens[lowerIndex],
          bottomNavigationBar: BottomNavigationBar(
              onTap: (value) {
                setState(() {
                  lowerIndex = value;
                });
              },
              currentIndex: lowerIndex,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey.shade600,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.message), label: 'Chats'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today), label: 'Schedule'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_box), label: 'Profile'),
              ])),
    );
  }
}
