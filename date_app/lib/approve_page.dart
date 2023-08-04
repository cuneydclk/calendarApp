import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApprovePage extends StatefulWidget {
  final String token;

  ApprovePage({required this.token});

  @override
  _ApprovePageState createState() => _ApprovePageState();
}

class _ApprovePageState extends State<ApprovePage> {
  List<dynamic> events = [];
  String userEmail = ''; // To store the email extracted from the token
  String userId = ''; // To store the userId retrieved from the server
  @override
  void initState() {
    super.initState();
    _extractEmailFromToken();
  }

  void _extractEmailFromToken() {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      String? email = decodedToken['email'];
      if (email != null) {
        setState(() {
          userEmail = email;
        });
        _fetchUserId(email); // Call function to fetch the userId
      } else {
        print('Failed to extract email from token.');
      }
    } catch (e) {
      print('Error decoding token: $e');
    }
  }

  Future<void> _fetchUserId(String email) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/getUserId?email=$email'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String fetchedUserId = data['userId'];

        setState(() {
          userId = fetchedUserId;
        });
        fetchEvents();
      } else {
        setState(() {
          userId = 'User not found';
        });
        print('Failed to fetch userId');
      }
    } catch (error) {
      print('Error fetching userId: $error');
    }
  }

  Future<void> fetchEvents() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/getallevents?userID=${userId}'),
      headers: {
        'Authorization': 'Bearer ${userId}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('events') &&
          responseData['events'] is List<dynamic>) {
        setState(() {
          events = responseData['events'];
        });
      } else {
        // Handle unexpected response format
        print('Unexpected response format: $responseData');
      }
    } else {
      // Handle error
      print('Failed to fetch events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Meetings'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['eventTitle'],
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                    'Start Time: ${event['startTime']}, Finish Time: ${event['finishTime']}'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add your approve logic here for this specific event
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text('Approve'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Add your unapprove logic here for this specific event
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text('Unapprove'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
