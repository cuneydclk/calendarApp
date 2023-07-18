import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class MainPage extends StatefulWidget {
  final token;

  const MainPage({@required this.token, Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String? _eventTitle;
  String? _startTime;
  String? _finishTime;

  late String email;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showAddEventDialog,
            child: Text('Add Event'),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Event Title',
                ),
                onChanged: (value) {
                  setState(() {
                    _eventTitle = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Start Time as (2023-07-12T10:00:00Z)',
                ),
                onChanged: (value) {
                  setState(() {
                    _startTime = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Finish Time as (2023-07-12T10:00:00Z)',
                ),
                onChanged: (value) {
                  setState(() {
                    _finishTime = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Perform the necessary actions with the event data
                // For example, save the event to a database
                // or update the UI with the new event
                _saveEvent();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _saveEvent() async {
    // Prepare the request payload
    final payload = jsonEncode({
      "email": email,
      "eventTitle": _eventTitle,
      "startTime": _startTime,
      "finishTime": _finishTime,
    });

    // Send the POST request
    final response = await http.post(
      Uri.parse('https://calenderapp.onrender.com/saveevent'),
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );

    // Check the response status code
    if (response.statusCode == 200) {
      print('Event saved successfully');
    } else {
      print('Failed to save event');
    }
  }
}
