import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'event_page.dart';
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
  late String? _participantEmails;

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
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Main Page'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to the main page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(token: widget.token),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Event Page'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to the event page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventPage(token: widget.token),
                  ),
                );
              },
            ),
          ],
        ),
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
    String? _participantEmails;

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
              TextField(
                decoration: InputDecoration(
                  labelText: 'Participant Emails (comma-separated)',
                ),
                onChanged: (value) {
                  setState(() {
                    _participantEmails = value;
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
      _getParticipantIDs(_participantEmails!, _startTime!);
    } else {
      print('Failed to save event');
    }
  }

  void _getParticipantIDs(String participantEmails, String startTime) async {
    List<String> emails = participantEmails.split(',');
    Map<String, String> participantIDs = {};

    for (String email in emails) {
      final response = await http.get(
        Uri.parse('https://calenderapp.onrender.com/getUserId?email=$email'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          String userId = responseData['userId'];
          participantIDs[email] = userId;
        }
      }
    }

    String eventSaverEmail = email;
    String formattedStartTime =
        startTime.replaceAll('-', '').replaceAll(':', '').substring(0, 15);

    // Now, we can make the GET request to get the eventID for the event saver and start time
    final eventResponse = await http.get(
      Uri.parse(
          'https://calenderapp.onrender.com/geteventId?email=$eventSaverEmail&startTime=$formattedStartTime'),
    );

    if (eventResponse.statusCode == 200) {
      Map<String, dynamic> eventData = json.decode(eventResponse.body);
      if (eventData['status'] == true) {
        String eventId = eventData['eventID'];

        // Now you have all the data you need: participantIDs and eventId
        // Perform any additional actions with this data as needed

        print('Participant IDs: $participantIDs');
        print('Event ID: $eventId');
      }
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');

    // Navigate to the login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}
