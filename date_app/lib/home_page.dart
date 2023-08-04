import 'package:flutter/material.dart';
import 'login_page.dart';
import 'request_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MeetLunch'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
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
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CompanyLogo(), // Add the CompanyLogo widget here
            SizedBox(height: 30),
            Expanded(
              child: Container(
                alignment: Alignment
                    .center, // Center the boxes both vertically and horizontally
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    BoxItem(
                      image: 'assets/image1.png',
                      name: 'Item 1',
                      cost: '\$10/hour',
                    ),
                    SizedBox(width: 20),
                    BoxItem(
                      image: 'assets/image2.png',
                      name: 'Item 2',
                      cost: '\$15/hour',
                    ),
                    SizedBox(width: 200),
                    // Add more BoxItem widgets here with different images, names, and costs
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Image.asset('assets/company_logo.png'),
    );
  }
}

class BoxItem extends StatelessWidget {
  final String image;
  final String name;
  final String cost;

  const BoxItem({required this.image, required this.name, required this.cost});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30, // Add a fixed height to each BoxItem
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              child: Image.asset(image),
            ),
            SizedBox(width: 20), // Add spacing between the image and text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(cost),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
