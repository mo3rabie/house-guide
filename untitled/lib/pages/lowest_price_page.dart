import 'package:flutter/material.dart';
import 'package:untitled/API/houseServices.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class LowestPricedHousesPage extends StatefulWidget {
  const LowestPricedHousesPage({super.key, required this.token});
  final String token;

  @override
  State<LowestPricedHousesPage> createState() => _LowestPricedHousesPageState();
}

class _LowestPricedHousesPageState extends State<LowestPricedHousesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lowest Price of Houses'),
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

          // Convert price to double and handle sorting
          houses.sort((a, b) {
            final priceA = double.tryParse(a.price ?? '0') ?? 0;
            final priceB = double.tryParse(b.price ?? '0') ?? 0;
            return priceA.compareTo(priceB);
          });

          return ListView.builder(
            itemCount: houses.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  // Display the house details using HouseCard
                  HouseCard(
                    house: houses[index],
                    onTap: () {},
                    key: null, // Optional: Replace with a unique key if necessary
                    token: widget.token,
                  ),
                  const SizedBox(height: 16.0),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
