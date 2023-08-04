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

  @override
  void initState() {
    super.initState();
    _fetchEvents(); // Fetch events when the page is loaded
  }

  Future<void> _fetchEvents() async {
    // Get the user ID from the JWT token
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    String? userID = jwtDecodedToken['email'];
    if (userID == null) {
      print('Failed to fetch events: User ID is null.');
      return;
    }

    // Fetch events for the user by userID
    final response = await http.get(
      Uri.parse('http://localhost:3000/events/user/$userID'),
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
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return _buildEventCard(events[index]);
        },
      ),
    );
  }

  Widget _buildEventCard(dynamic event) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Title: ${event['eventTitle']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Start Time: ${event['startTime']}'),
            Text('Finish Time: ${event['finishTime']}'),
            // Add more event details here as needed
          ],
        ),
      ),
    );
  }
}
