import 'dart:convert';
import 'package:campus_connection_app/Data/systemUser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'chatMessage.dart';

class SearchUser extends StatefulWidget {
  State<SearchUser> createState() => _SearchUser();
}

class _SearchUser extends State<SearchUser> {
  List<SystemUser> _userList = [];
  List<SystemUser> _searchChat = [];
  bool searchText = true;

  void initState() {
    super.initState();
    getChat();
  }

  void getChat() async {
    final url = Uri.https(
        'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
        'chatSaveUser.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    List<SystemUser> getList = [];
    setState(() {
      for (final item in listData.entries) {
        getList.add(SystemUser(
            user: item.value['user'], position: item.value['position']));
      }
      _userList = getList;
      _searchChat = getList;
    });
  }

  void searchChat(String value) {
    if (value.isEmpty || value == '') {
      setState(() {
        _searchChat = _userList;
      });
    } else {
      setState(() {
        _searchChat = [];
        _searchChat = _userList
            .where(
                (item) => item.user.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchText
            ? AppBar(
                flexibleSpace: SafeArea(
                    child: Center(
                  child: Row(children: [
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      'Select Contact',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ]),
                )),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          searchText = false;
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ))
                ],
              )
            : AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: SafeArea(
                    child: Container(
                        padding:
                            EdgeInsets.only(left: 10, top: 10, bottom: 10))),
                title: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchChat(value);
                    });
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              searchText = true;
                              getChat();
                            });
                          },
                          icon: Icon(Icons.arrow_back, color: Colors.black)),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Search or start a new chat',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                )),
        body: ListView.builder(
          itemCount: searchText ? _userList.length : _searchChat.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 16),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChatMessage(
                    name: searchText
                        ? _userList[index].user
                        : _searchChat[index].user,
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
                                    Text(
                                        searchText
                                            ? _userList[index].user
                                            : _searchChat[index].user,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                        searchText
                                            ? _userList[index].position
                                            : _searchChat[index].position,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.normal)),
                                  ])))
                    ],
                  )),
                ]),
              ),
            );
          },
        ));
  }
}
