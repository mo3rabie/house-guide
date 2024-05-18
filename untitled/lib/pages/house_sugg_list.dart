
import 'package:flutter/material.dart';
import 'package:untitled/API/houseServices.dart';
import 'package:untitled/pages/all_houses_page.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class HouseSuggList extends StatefulWidget {
  
  const HouseSuggList(this.title, {super.key, required this.token});
  final String? title;
  final String token;
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
        Row(
          verticalDirection: VerticalDirection.up,
          children: [
            Expanded(
              child: Text(
                widget.title!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Color.fromARGB(255, 0, 134, 172),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  AllHousesPage(token: widget.token)),
                );
              },
              child: const Text("See All"),
            ),
          ],
        ),
        const SizedBox(height: 1.0),
        SizedBox(
          height: 450.0,
          width: double.infinity,
          child: FutureBuilder<List<House>>(
            future: _housesFuture,
            builder: (BuildContext context, AsyncSnapshot<List<House>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return const Center(
                  child: Text(
                    'Error fetching houses. Please try again later.',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              List<House> houses = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: houses.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      HouseCard(
                        house: houses[index],
                        onTap: () {},
                        key: null,
                        token:widget.token,
                      ),
                      const SizedBox(height: 30.0),
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
