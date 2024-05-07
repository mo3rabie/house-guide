import 'package:flutter/material.dart';
import 'package:untitled/API/apiServices.dart';
import 'package:untitled/pages/all_houses_page.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class HouseSuggList extends StatefulWidget {
  const HouseSuggList(this.title, {super.key});
  final String? title;

  @override
  State<HouseSuggList> createState() => _HouseSuggListState();
}

class _HouseSuggListState extends State<HouseSuggList> {
  late Future<List<House>> _housesFuture;

  @override
  void initState() {
    super.initState();
    _housesFuture = HouseService.getAllHouses();
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
                      color: Color.fromARGB(255, 0, 134, 172)),
                ),
                const SizedBox(width: 70.0),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllHousesPage()),
                      );
                    },
                    child: const Text("See All"))
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 1.0,
        ),
        SizedBox(
          height: 450.0,
          width: double.infinity,
          child: FutureBuilder<List<House>>(
            future: _housesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              List<House>? houses = snapshot.data;

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: houses?.length ?? 0,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ItemCard(
                        house: houses![index],
                        onTap: () {},
                        key: null,
                      ),
                      const SizedBox(
                        height: 30.0,
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
