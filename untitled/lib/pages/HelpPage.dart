
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Housing App Help Page!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'How to Use:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Browse Listings:'),
              subtitle: Text('Navigate through available housing listings.'),
            ),
            ListTile(
              leading:  Icon(Icons.bookmark_border),
              title: Text('Favorites:'),
              subtitle: Text('Save your favorite listings for quick access.'),
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search:'),
              subtitle: Text('Use search functionality to find specific listings.'),
            ),
            SizedBox(height: 16),
            Text(
              'For Further Assistance:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'If you need further assistance, please contact our support team at:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'support@housingapp.com',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
