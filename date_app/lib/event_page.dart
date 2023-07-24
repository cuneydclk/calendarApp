import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class EventPage extends StatefulWidget {
  final String token;

  const EventPage({required this.token, Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<dynamic> events = []; // List to store events
  String userEmail = ''; // Variable to store the user's email

  @override
  void initState() {
    super.initState();
    _fetchUserEmailFromToken(); // Fetch user's email from the JWT token
  }

  Future<void> _fetchUserEmailFromToken() async {
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    String email = jwtDecodedToken['email'];

    setState(() {
      userEmail = email;
    });

    _fetchUserIDAndEvents(); // Fetch UserID and events after getting the email
  }

  Future<void> _fetchUserIDAndEvents() async {
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    String email = jwtDecodedToken['email'];

    // Fetch UserID using the 'getUserId' route
    final response = await http.get(
      Uri.parse(
          'https://calenderapp.onrender.com/getUserId?email=$email'), // Replace with your API URL
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      String userID = data['userId'];
      _fetchEvents(userID); // Fetch events after getting the UserID
    } else {
      print('Failed to get UserID');
    }
  }

  Future<void> _fetchEvents(String userID) async {
    // Fetch events for the user by UserID
    final response = await http.get(
      Uri.parse(
          'https://your-api-url/events/user/$userID'), // Replace with your API URL
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      List<dynamic> fetchedEvents = json.decode(response.body);
      setState(() {
        events = fetchedEvents;
      });
    } else {
      print('Failed to fetch events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue,
            child: Text(
              'Events of $userEmail',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(events[index]['eventTitle']),
                  subtitle: Text('Start Time: ${events[index]['startTime']}'),
                  // Add more event details here as needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
