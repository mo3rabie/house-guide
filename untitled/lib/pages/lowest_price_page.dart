// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class DatabaseService {
  final CollectionReference housesRef =
      FirebaseFirestore.instance.collection('houses');

  Future<List<DocumentSnapshot>> getLowestPricedHouses() async {
    QuerySnapshot querySnapshot = await housesRef
        .orderBy('price')
        .get();

    return querySnapshot.docs;
  }
}

class LowestPricedHousesPage extends StatefulWidget {
  @override
  _LowestPricedHousesPageState createState() => _LowestPricedHousesPageState();
}

class _LowestPricedHousesPageState extends State<LowestPricedHousesPage> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lowest Priced Houses'),
        titleTextStyle:  TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        centerTitle: true,
        backgroundColor:  Color.fromARGB(255, 0, 134, 172),
      ),
      body: FutureBuilder(
        future: _databaseService.getLowestPricedHouses(),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<DocumentSnapshot> houses = snapshot.data ?? [];

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
