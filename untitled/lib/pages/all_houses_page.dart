// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class AllHousesPage extends StatelessWidget {
  const AllHousesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Houses'),
        titleTextStyle:  TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        centerTitle: true,
        backgroundColor:  Color.fromARGB(255, 0, 134, 172),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('houses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var houses = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: houses.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  // Assuming ItemCard takes a House model as a parameter
                  ItemCard(
                    house: House.fromMap(houses[index].data() as Map<String, dynamic>),
                    onTap: () {},
                    key: null,
                  ),
                   SizedBox(
                    height: 16.0,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
