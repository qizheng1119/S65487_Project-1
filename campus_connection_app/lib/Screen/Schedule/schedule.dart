import 'package:flutter/material.dart';
import 'getAppointment.dart';
import 'upcoming.dart';

class Schedule extends StatefulWidget {
  State<Schedule> createState() => _Schedule();
}

class _Schedule extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Connection'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Card(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return GetAppointment();
                                }));
                              },
                              icon: Icon(Icons.calendar_month)),
                          Text('Appointment')
                        ]));
                  case 1:
                    return Card(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Upcoming();
                                }));
                              },
                              icon: Icon(Icons.upcoming)),
                          Text('Upcoming')
                        ]));
                  case 2:
                    return Card(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return History();
                                }));
                              },
                              icon: Icon(Icons.history)),
                          Text('History')
                        ]));
                  case 3:
                    return Card(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Availability();
                                }));
                              },
                              icon: Icon(Icons.event_available)),
                          Text('Availability')
                        ]));
                  default:
                }
                return null;
              })),
    );
  }
}
