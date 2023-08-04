import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  List<String> userIds = [];
  Map<String, bool> expandedStates = {};
  Map<String, List<String>> userWorkingHours = {};
  Map<String, List<String>> userUnavailableTimes = {};

  Future<void> fetchUserIds() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/getAllUserIds'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        userIds = data.cast<String>();
      });
    } else {
      throw Exception('Failed to load user IDs');
    }
  }

  Future<void> fetchWorkingHours(String userId) async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/getHours?userId=$userId'));

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> workingHoursList =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      final formattedAvailability = formatWorkingHours(workingHoursList);
      fetchUnavailableTimes(userId); // Fetch and update unavailable times
      setState(() {
        userWorkingHours[userId] = formattedAvailability;
      });
    } else {
      throw Exception('Failed to load working hours for user: $userId');
    }
  }

  Future<void> _requestMeeting(String userEmail) async {
    TextEditingController emailController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay finishTime = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Request Meeting'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Please write a contact addres like Email'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (selected != null) {
                    setState(() {
                      selectedDate = selected;
                    });
                  }
                },
                child: Text('Select Date'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final selected = await showTimePicker(
                    context: context,
                    initialTime: startTime,
                  );

                  if (selected != null) {
                    setState(() {
                      startTime = selected;
                    });
                  }
                },
                child: Text('Select Start Time'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final selected = await showTimePicker(
                    context: context,
                    initialTime: finishTime,
                  );

                  if (selected != null) {
                    setState(() {
                      finishTime = selected;
                    });
                  }
                },
                child: Text('Select Finish Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final startTimeUTC = DateTime.utc(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  startTime.hour,
                  startTime.minute,
                );
                final finishTimeUTC = DateTime.utc(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  finishTime.hour,
                  finishTime.minute,
                );
                final response = await http.post(
                  Uri.parse('http://localhost:3000/saveevent'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode({
                    'userID': userEmail,
                    'eventTitle': emailController.text,
                    'startTime': startTimeUTC.toIso8601String(),
                    'finishTime': finishTimeUTC.toIso8601String(),
                  }),
                );

                if (response.statusCode == 200) {
                  // Successfully saved event
                  Navigator.of(context).pop();

                  // Handle error
                }
              },
              child: Text('Request'),
            ),
          ],
        );
      },
    );
  }

  List<String> formatWorkingHours(List<Map<String, dynamic>> workingHoursList) {
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final availability = List<String>.filled(9, '');

    workingHoursList.forEach((item) {
      final dayOfWeek = item['dayOfWeek'];
      final startTime = item['startTime'];
      final endTime = item['endTime'];

      if (dayOfWeek >= 0 && dayOfWeek < 7) {
        availability[dayOfWeek] =
            'Available from $startTime to $endTime on ${daysOfWeek[dayOfWeek]}';
      } else if (dayOfWeek == 7) {
        availability[7] = 'Available on weekends from $startTime to $endTime';
      } else if (dayOfWeek == 8) {
        availability[8] = 'Available on weekdays from $startTime to $endTime';
      }
    });

    return availability.where((item) => item.isNotEmpty).toList();
  }

  Future<void> fetchUnavailableTimes(String userId) async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/getTime?userId=$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final formattedUnavailableTimes = formatUnavailableTimes(data);
      setState(() {
        userUnavailableTimes[userId] = formattedUnavailableTimes;
      });
    } else {
      throw Exception('Failed to load unavailable times for user: $userId');
    }
  }

  List<String> formatUnavailableTimes(List<dynamic> unavailableTimesList) {
    final formattedUnavailableTimes = <String>[];

    unavailableTimesList.forEach((item) {
      final startDateTime = DateTime.parse(item['startDate']);
      final endDateTime = DateTime.parse(item['endDate']);

      final formattedTime =
          'Unavailable from ${_formatDateTime(startDateTime)} to ${_formatDateTime(endDateTime)}';

      formattedUnavailableTimes.add(formattedTime);
    });

    return formattedUnavailableTimes;
  }

  String _formatDateTime(DateTime dateTime) {
    final timeFormat = DateFormat('hh:mm a');
    return timeFormat.format(dateTime.toLocal());
  }

  @override
  void initState() {
    super.initState();
    fetchUserIds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Page'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: userIds.length,
          itemBuilder: (context, index) {
            final userId = userIds[index];
            final isExpanded = expandedStates[userId] ?? false;
            return GestureDetector(
              onTap: () async {
                if (!isExpanded) {
                  // Call fetchWorkingHours only if not already expanded
                  await fetchWorkingHours(userId);
                }
                setState(() {
                  expandedStates[userId] =
                      !isExpanded; // Toggle the expansion state
                });
              },
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userIds[index],
                          style: TextStyle(fontSize: 18),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _requestMeeting(userIds[index]);
                          },
                          child: Text('Request Meeting'),
                        ),
                      ],
                    ),
                    if (isExpanded && userWorkingHours.containsKey(userId))
                      ...userWorkingHours[userId]!
                          .map(
                            (availability) => Text(
                              availability,
                              style: TextStyle(color: Colors.green),
                            ),
                          )
                          .toList(),
                    if (isExpanded && userUnavailableTimes.containsKey(userId))
                      ...userUnavailableTimes[userId]!
                          .map(
                            (unavailability) => Text(
                              unavailability,
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                          .toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RequestPage(),
  ));
}
