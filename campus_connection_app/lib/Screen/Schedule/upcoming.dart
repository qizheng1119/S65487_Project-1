import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:campus_connection_app/Data/appointment.dart';

class Upcoming extends StatefulWidget {
  State<Upcoming> createState() => _Upcoming();
}

class _Upcoming extends State<Upcoming> {
  List<Appointment> appointment = [];

  var lowerIndex = 0;

  void initState() {
    super.initState();
    getChat();
  }

  void getChat() async {
    final url = Uri.https(
        'campusconnect-81143-default-rtdb.asia-southeast1.firebasedatabase.app',
        'appointment.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    List<Appointment> _appoint = [];
    setState(() {
      for (final item in listData.entries) {
        _appoint.add(Appointment(
            name: item.value['user'],
            date: item.value['date'],
            time: item.value['time']));
      }
      appointment = _appoint;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text("Nothing here"));
    setState(() {
      if (appointment.isNotEmpty) {
        content = Column(children: [
          Text(
            'Upcoming Appointment',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            itemCount: appointment.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 16),
            itemBuilder: (context, index) {
              return Container(
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
                                    Text(appointment[index].name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: [
                                        Text(appointment[index].date,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.normal)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(appointment[index].time,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    )
                                  ])))
                    ],
                  )),
                ]),
              );
            },
          )
        ]);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Connection'),
        centerTitle: true,
      ),
      body: content,
    );
  }
}

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Connection'),
        centerTitle: true,
      ),
      body: Center(child: Text('No history...')),
    );
  }
}
