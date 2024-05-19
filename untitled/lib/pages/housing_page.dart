// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import "package:flutter_zoom_drawer/flutter_zoom_drawer.dart";
import "package:provider/provider.dart";
import "package:untitled/API/houseServices.dart";
import 'package:untitled/pages/Add_House.dart';
import "package:untitled/pages/house_details_page.dart";
import "package:untitled/pages/house_sugg_list.dart";
import "package:untitled/pages/lowest_price_page.dart";
import "package:untitled/pages/modules/house.dart";
import "package:untitled/pages/setting.dart";

class HousingMainPage extends StatelessWidget {
  const HousingMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ThemeProvider>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }
}

class HousingPage extends StatefulWidget {
  final String token; // User token parameter

  const HousingPage({super.key, required this.token});

  @override
  State<HousingPage> createState() => _HousingPageState();
}

class _HousingPageState extends State<HousingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 80.0,
        backgroundColor: Colors.white,
        leading: IconButton(
           onPressed: () {
             if(ZoomDrawer.of(context)!.isOpen()) {
              
              ZoomDrawer.of(context)!.close(); 
              //ZoomDrawer.of(context)!.toggle();
            }else{
            ZoomDrawer.of(context)!.open();
            }
           },

            icon: const Icon(
              Icons.menu,
              size: 32,
              color: Color.fromARGB(255, 0, 134, 172),
            ),
            
          ),
        
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .97,
            child: Image.asset(
              "asset/images/logo1.png",
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15.0),
        
        child: SingleChildScrollView(
          
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 120,
              ),
              const Text(
                "Choose Your",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 134, 172),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Comfortble housing!",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 134, 172),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SearchHousingeWidget(context, token: widget.token),
              const SizedBox(
                height: 10,
              ),
              HouseSuggList("Recommendation for you", token: widget.token),
              const SizedBox(
                height: 10,
              ),
              ButtonAddHousingeWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget SearchHousingeWidget(BuildContext context, {required String token}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        height: 60,
        width: 315,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40)),
        child: SingleChildScrollView(
          child: TextField(
            onTap: () {
              showSearch(context: context, delegate: CustomSearch(token));
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 0, 134, 172)),
                hintText: "Search address, or places...",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 13,
                )),
          ),
        ),
      ),
      Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: InkWell(
          onTap: () {
            _showFilterDialog(context, widget.token); // Show the filter dialog
          },
          child: const Icon(Icons.tune, color: Colors.grey),
        ),
      ),
    ]);
  }

  // ignore: non_constant_identifier_names
  Widget ButtonAddHousingeWidget(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(330, 50)),
          backgroundColor:
              MaterialStateProperty.all(Color.fromARGB(255, 0, 134, 172)),
          shadowColor: MaterialStateProperty.all(Colors.blue),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddHouse(token: widget.token)));
        },
        child: const Text(
          "Add House",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

Future<void> _showFilterDialog(BuildContext context, String token) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Filter Options'),
        alignment: Alignment.center,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption(
              context,
              'Lowest Price',
              () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LowestPricedHousesPage(token: token),
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildFilterOption(
    BuildContext context, String title, VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blue, // Customize the text color
          fontSize: 18,
        ),
      ),
    ),
  );
}

class CustomSearch extends SearchDelegate {
  final String token;

  CustomSearch(this.token);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context, token);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context, token);
  }

  Widget _buildSearchResults(BuildContext context, String token) {
    return FutureBuilder<List<House>>(
      future: HouseService.searchHousesByAddress(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          // Check if the error is a NetworkException
          if (snapshot.error is NetworkException) {
            // Handle the NetworkException
            return Center(
              child: Text(
                'No matching addresses found.',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            return Text('Error: ${snapshot.error}');
          }
        }

        var houses = snapshot.data ?? [];

        if (houses.isEmpty) {
          // No matching addresses found
          return Center(
            child: Text(
              'No matching addresses found',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: houses.length,
          itemBuilder: (context, index) {
            var house = houses[index];
            return InkWell(
              onTap: () {
                // Navigate to the details page or perform any action
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HouseDetailsPage(item: house, token: token),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    house.address!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
