import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:campus_connection_app/Data/userData.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class GetAppointment extends StatefulWidget {
  State<GetAppointment> createState() => _GetAppointmentState();
}

class _GetAppointmentState extends State<GetAppointment> {
  DateTime selectedDate = DateTime.now();
  var storeDate = '';
  var timeSelect = ['-', '8-10 am', '10-12 pm', '2-4 pm'];
  String selectedtime = '-';
  var timeselect2 = [];
  var name = '';

  final lecterur = UserData()
      .allUser
      .where((item) => item.position.contains('Lecturer'))
      .toList();

  Future _buildTimeDropDown(var item) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStateSB) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select a time',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButton<String>(
                      value: selectedtime,
                      onChanged: (value) {
                        setStateSB(() {
                          selectedtime = value!;
                        });
                      },
                      items: item.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          saveValue();
                        },
                        child: Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  void saveValue() async {
    final url = Uri.https(
        'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
        'appointment.json');
    await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json
            .encode({'user': name, 'date': storeDate, 'time': selectedtime}));
    Navigator.pop(context);
  }

  Future<void> select(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
    storeDate = DateFormat('dd.MM.yy').format(selectedDate);
    final url = Uri.https(
        'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
        'appointment.json');
    final response = await http.get(url);
    if (response.body == 'null') {
      _buildTimeDropDown(timeSelect);
    } else {
      final Map<String, dynamic> listData = json.decode(response.body);
      for (final item in listData.entries) {
        if (!timeSelect.contains(item.value['time'])) {
          setState(() {
            timeselect2.add(item.value['time']);
          });
        }
      }
      _buildTimeDropDown(timeselect2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Connection'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: lecterur.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              name = lecterur[index].user;
              select(context);
            },
            child: Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              child: Row(children: [
                Expanded(
                    child: Row(
                  children: [
                    CircleAvatar(
                      child: Icon(Icons.calendar_month),
                      maxRadius: 30,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                        child: Container(
                            color: Colors.transparent,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(lecterur[index].user,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 6,
                                  ),
                                ])))
                  ],
                )),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class Availability extends StatelessWidget {
  final lecterur = UserData()
      .allUser
      .where((item) => item.position.contains('Lecturer'))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Connection'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: lecterur.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 16),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Row(children: [
              Expanded(
                  child: Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.calendar_month),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 15),
                  Expanded(
                      child: Container(
                          color: Colors.transparent,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(lecterur[index].user,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    )),
                              ])))
                ],
              )),
            ]),
          );
        },
      ),
    );
  }
}
