// ignore_for_file: avoid_function_literals_in_foreach_calls, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:untitled/API/houseServices.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class AllHousesPage extends StatefulWidget {
  const AllHousesPage({Key? key, required this.token});
  final String token;

  @override
  State<AllHousesPage> createState() => _AllHousesPageState();
}

class _AllHousesPageState extends State<AllHousesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Houses'),
        titleTextStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 134, 172),
      ),
      body: FutureBuilder<List<House>>(
        future: HouseService.getAllHouses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var houses = snapshot.data ?? [];

          return ListView.builder(
            itemCount: houses.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  // Assuming ItemCard takes a House model as a parameter
                  HouseCard(
                    house: houses[index],
                    onTap: () {},
                    key: null, token: widget.token,
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
    );
  }
}
