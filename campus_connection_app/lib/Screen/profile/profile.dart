import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  String email = '';
  String phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Connection'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(height: 15),
          CircleAvatar(
            child: Icon(Icons.person),
            maxRadius: 40,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Chong Qi Zheng',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Text(
            'S65487',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Email: s65487@ocean.umt.edu.my'),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.edit)
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Phone Number: 0105450095'),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.edit)
            ],
          )
        ],
      )),
    );
  }
}
