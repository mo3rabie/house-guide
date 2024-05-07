// ignore_for_file: avoid_function_literals_in_foreach_calls, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class AllHousesPage extends StatelessWidget {
  const AllHousesPage({Key? key});

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
        future: _fetchHouses(),
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
                  ItemCard(
                    house: houses[index],
                    onTap: () {},
                    key: null,
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

  Future<List<House>> _fetchHouses() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.43.114:3000/api/house/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        List<House> houses = [];
        responseData.forEach((houseData) {
          houses.add(House.fromMap(houseData as Map<String, dynamic>));
        });
        return houses;
      } else {
        throw Exception('Failed to load houses');
      }
    } catch (error) {
      throw Exception('Error fetching houses: $error');
    }
  }
}
