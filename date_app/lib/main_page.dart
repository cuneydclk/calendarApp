import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'event_page.dart';
import 'user_calendar.dart';
import 'request_page.dart';
import 'approve_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Meeting {
  final String title;
  final DateTime startTime;
  final DateTime finishTime;

  Meeting({
    required this.title,
    required this.startTime,
    required this.finishTime,
  });
}

class MainPage extends StatefulWidget {
  final token;

  const MainPage({@required this.token, Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  late String email;

  List<Meeting> _meetings = [];

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];

    _loadMeetings();
  }

  void _loadMeetings() {
    // You can add your implementation here to fetch meetings from an API or database.
    // For now, we'll add some dummy meetings for demonstration purposes.
    setState(() {
      _meetings = [
        Meeting(
          title: 'Meeting 1',
          startTime: DateTime.now().add(Duration(hours: 1)),
          finishTime: DateTime.now().add(Duration(hours: 2)),
        ),
        Meeting(
          title: 'Meeting 2',
          startTime: DateTime.now().add(Duration(hours: 3)),
          finishTime: DateTime.now().add(Duration(hours: 4)),
        ),
        Meeting(
          title: 'Meeting 3',
          startTime: DateTime.now().add(Duration(days: 3)),
          finishTime: DateTime.now().add(Duration(hours: 4)),
        ),
        // Add more meetings here as needed...
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
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
              title: Text('User Calendar Page'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to the main page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserCalendar(token: widget.token),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Request Page'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to the main page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('My meetings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to the main page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApprovePage(token: widget.token),
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
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _meetings.length,
              itemBuilder: (context, index) {
                final meeting = _meetings[index];
                return ListTile(
                  title: Text(meeting.title),
                  subtitle: Text(
                    '${meeting.startTime.hour}:${meeting.startTime.minute} - ${meeting.finishTime.hour}:${meeting.finishTime.minute}',
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

void _logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwtToken');

  // Navigate to the login page
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    (route) => false,
  );
}
