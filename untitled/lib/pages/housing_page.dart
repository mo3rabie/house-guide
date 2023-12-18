import "package:flutter/material.dart";
import "package:flutter_zoom_drawer/flutter_zoom_drawer.dart";
import 'package:untitled/pages/Add_House.dart';
import "package:untitled/pages/house_sugg_list.dart";
import "package:untitled/pages/item_model.dart";
//import "package:kf_drawer"

class HousingPage extends StatefulWidget {
  const HousingPage({super.key});

  @override
  State<HousingPage> createState() => _HousingPageState();
}

class _HousingPageState extends State<HousingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.grey[200], //////////////
        //backgroundColor: const Color.fromARGB(255, 234, 232, 232),
        elevation: 0.0,
        toolbarHeight: 80.0,
        leading: const MenuDrawer(), 
        // InkWell(
        // onTap: () => ZoomDrawerController().toggle,
        // child: Icon(Icons.menu),
        // backgroundColor: Colors.white,
        
        actions: [
                  Image.asset(
                    "asset/images/logo1.png",
                  ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 1),
            width: 80,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                  const Icon(
                    Icons.location_on,
                    size: 15,
                    color: Colors.blue,
                  ),
                ]),
          )
        ],
      ),
      body: Padding(
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
              SearchHousingeWidget(context),
              const SizedBox(
                height: 20,
              ),
              moreWidget(context, "Near from you"),
              HouseSuggList("Recommendation for you", Item.recommendation),
              const SizedBox(
                height: 20,
              ),
              ButtonAddHousingeWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget moreWidget(BuildContext context, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue[800],
          ),
        ),
        InkWell(
          onTap: () {},
          child: Icon(
            Icons.more_horiz,
            color: Colors.blue[800],
          ),
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget SearchHousingeWidget(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        height: 45,
        width: 330,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40)),
        child: SingleChildScrollView(
          child: TextField(
            onTap: () {
              showSearch(context: context, delegate: CustomSearch());
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: "Search address, or places...",
                hintStyle: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 13,
                )),
          ),
        ),
      ),
      Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.tune, color: Colors.grey),
      ),
    ]);
  }

  // ignore: non_constant_identifier_names
  Widget ButtonAddHousingeWidget(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
            ),
          ),
          minimumSize: MaterialStateProperty.all(const Size(330, 50)),
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          // elevation: MaterialStateProperty.all(3),
          shadowColor: MaterialStateProperty.all(Colors.blue),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AddHouse()));
        },
        child: const Text(
          "Add House",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ZoomDrawer.of(context)!.toggle();
      },
      //

      icon: const Icon(
        Icons.menu,
        color: Colors.blue,
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  List username = ["maryam", "maruuuu", "ma", "logy", "gamal", "layla"];
  List? filterList;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("Rusult : $filterList");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == "") {
      return ListView.builder(
          itemCount: username.length,
          itemBuilder: (context, i) {
            return Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "${username[i]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ));
          });
    } else {
      filterList =
          username.where((element) => element.startsWith(query)).toList();
      return ListView.builder(
          itemCount: filterList!.length,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () {
                showResults(context);
              },
              child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "${filterList![i]}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  )),
            );
          });
    }
  }
}
