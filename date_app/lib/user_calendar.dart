import 'dart:html';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserCalendar extends StatefulWidget {
  final String token;

  const UserCalendar({required this.token, Key? key}) : super(key: key);

  @override
  _UserCalendarState createState() => _UserCalendarState();
}

class _UserCalendarState extends State<UserCalendar> {
  String userEmail = ''; // To store the email extracted from the token
  String userId = ''; // To store the userId retrieved from the server
  List<bool> selectedDays = List.generate(9, (index) => false);

  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTimeforevent;
  TimeOfDay? endTimeforevent;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    _extractEmailFromToken();
  }

  void _selectDate(String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        if (type == 'start') {
          startDate = picked;
        } else if (type == 'end') {
          endDate = picked;
        }
      });
    }
  }

  void _selectTimeforevent(String type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (type == 'start') {
          startTimeforevent = picked;
        } else if (type == 'end') {
          endTimeforevent = picked;
        }
      });
    }
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

  String _getDayLabel(int dayNumber) {
    switch (dayNumber) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      case 7:
        return 'Weekends';
      case 8:
        return 'Weekdays';
      default:
        return '';
    }
  }

  void _selectTime(bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      if (isStartTime) {
        startTime = pickedTime;
      } else {
        endTime = pickedTime;
      }
    });
  }

  Future<void> saveMeeting(DateTime? startDate, DateTime? endDate,
      TimeOfDay? startTimeforevent, TimeOfDay? endTimeforevent) async {
    final url = 'http://localhost:3000/saveMeeting';

    // Combine the selected dates and times
    final adjustedStartDate = DateTime(startDate!.year, startDate.month,
        startDate.day, startTimeforevent!.hour, startTimeforevent.minute);
    final adjustedEndDate = DateTime(endDate!.year, endDate.month, endDate.day,
        endTimeforevent!.hour, endTimeforevent.minute);

    // Get the local timezone offset
    final timezoneOffset = DateTime.now().timeZoneOffset;
    final adjustedStartDateWithOffset = adjustedStartDate.add(timezoneOffset);
    final adjustedEndDateWithOffset = adjustedEndDate.add(timezoneOffset);

    final formattedStartDate =
        adjustedStartDateWithOffset.toUtc().toIso8601String();
    final formattedEndDate =
        adjustedEndDateWithOffset.toUtc().toIso8601String();

    print(formattedStartDate);
    print(formattedEndDate);
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'startDate': formattedStartDate,
        'endDate': formattedEndDate,
      }),
    );

    if (response.statusCode == 200) {
      print('Meeting time saved successfully.');
    } else {
      print('Failed to save meeting time.');
    }
  }

  Future<void> _saveWorkingHours() async {
    List<int> selectedDaysList = [];
    for (int i = 0; i < 9; i++) {
      if (selectedDays[i] == true) {
        selectedDaysList.add(i);
      }
    }

    if (startTime == null || endTime == null) {
      print('Please select both start and end times.');
      return;
    }

    String startTimeFormatted =
        '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}';
    String endTimeFormatted =
        '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';

    try {
      for (int i = 0; i < selectedDaysList.length; i++) {
        final response = await http.post(
          Uri.parse('http://localhost:3000/saveHours'),
          headers: {
            'Content-Type': 'application/json', // Set the content type here
          },
          body: jsonEncode({
            'userId': userId,
            'dayOfWeek': selectedDaysList[i].toString(),
            'startTime': startTimeFormatted,
            'endTime': endTimeFormatted,
          }),
        );

        if (response.statusCode == 200) {
          print(
              'Working hours for day ${selectedDaysList[i]} saved successfully.');
        } else {
          print('Failed to save working hours for day ${selectedDaysList[i]}.');
        }
      }
    } catch (error) {
      print('Error saving working hours: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Calendar'),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please enter your available time',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'User Email: $userEmail',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'User ID: $userId',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Select working days:',
                      style: TextStyle(fontSize: 18),
                    ),
                    for (int i = 0; i < 9; i++)
                      CheckboxListTile(
                        title: Text(_getDayLabel(i)),
                        value: selectedDays[i],
                        onChanged: (bool? newValue) {
                          setState(() {
                            selectedDays[i] = newValue ?? false;
                          });
                        },
                      ),
                    SizedBox(height: 16),
                    Text(
                      'Select start time:',
                      style: TextStyle(fontSize: 18),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _selectTime(true);
                      },
                      child: Text('Select Start Time'),
                    ),
                    if (startTime != null)
                      Text(
                        'Start Time: ${startTime!.format(context)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    SizedBox(height: 16),
                    Text(
                      'Select end time:',
                      style: TextStyle(fontSize: 18),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _selectTime(false);
                      },
                      child: Text('Select End Time'),
                    ),
                    if (endTime != null)
                      Text(
                        'End Time: ${endTime!.format(context)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _saveWorkingHours();
                      },
                      child: Text('Save Working Hours'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select start date:',
                    style: TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _selectDate('start');
                    },
                    child: Text('Select Start Date'),
                  ),
                  if (startDate != null)
                    Text(
                      'Start Date: ${DateFormat('yyyy-MM-dd').format(startDate!)}',
                      style: TextStyle(fontSize: 18),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Select end date:',
                    style: TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _selectDate('end');
                    },
                    child: Text('Select End Date'),
                  ),
                  if (endDate != null)
                    Text(
                      'End Date: ${DateFormat('yyyy-MM-dd').format(endDate!)}',
                      style: TextStyle(fontSize: 18),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Select start time:',
                    style: TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _selectTimeforevent('start');
                    },
                    child: Text('Select Start Time'),
                  ),
                  if (startTimeforevent != null)
                    Text(
                      'Start Time: ${startTimeforevent!.format(context)}',
                      style: TextStyle(fontSize: 18),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Select end time:',
                    style: TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _selectTimeforevent('end');
                    },
                    child: Text('Select End Time'),
                  ),
                  if (endTimeforevent != null)
                    Text(
                      'End Time: ${endTimeforevent!.format(context)}',
                      style: TextStyle(fontSize: 18),
                    ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      saveMeeting(startDate, endDate, startTimeforevent,
                          endTimeforevent);
                    },
                    child: Text('Save Meeting Time'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserCalendar(
        token: 'your_example_token_here'), // Replace with your actual token
  ));
}
