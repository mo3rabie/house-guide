// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/pages/all_houses_page.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class HouseSuggList extends StatefulWidget {
  const HouseSuggList(this.title,  {super.key});
  final String? title;

  @override
  State<HouseSuggList> createState() => _HouseSuggListState();
}

class _HouseSuggListState extends State<HouseSuggList> {
  late Stream<QuerySnapshot> _dataStream;
  bool _isDataStreamInitialized = false;

  @override
  void initState() {
    super.initState();
    // Get data from Firestore
    _dataStream = FirebaseFirestore.instance.collection('houses').snapshots();

    // Set the flag to true once the stream is initialized
    _dataStream.listen((_) {
      setState(() {
        _isDataStreamInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              verticalDirection: VerticalDirection.up,
              children: [
                Text(
                  widget.title!,
                  style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 18.0,
                  color:Color.fromARGB(255,0, 134, 172)),
                ),
                const SizedBox(width: 70.0),
                TextButton(onPressed: () {Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AllHousesPage()),
    );}, child: const Text("See All"))
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 12.0,
        ),
        SizedBox(
          height: 340.0,
          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
            stream: _dataStream,
            builder: (context, snapshot) {
              if (!_isDataStreamInitialized) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              var houses = snapshot.data?.docs ?? [];

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: houses.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      // Assuming ItemCard takes a House model as a parameter
                      ItemCard(
                            house: House.fromMap(houses[index].data() as Map<String, dynamic>),
                                 onTap: () {}, key: null,
                                   ),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}


