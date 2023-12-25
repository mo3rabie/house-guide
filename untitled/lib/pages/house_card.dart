// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:untitled/pages/modules/house.dart';
import 'package:untitled/pages/house_details_page.dart'; // Import your HouseDetailsPage

class ItemCard extends StatefulWidget {
  const ItemCard({
    required super.key,
    required this.house,
    required this.onTap,
  });

  final House house;
  final Function() onTap;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      margin: const EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
          colors: [
            Color.fromARGB(159, 105, 146, 157),
            Color.fromARGB(67, 0, 135, 172),
          ],
        ),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to HouseDetailsPage when the card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HouseDetailsPage(item: widget.house),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey.shade200,
                  image: widget.house.images!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(widget.house.images![0]),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.house.name!,
                style: TextStyle(fontSize: 20.0, color: Colors.blue),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.blueGrey,
                  ),
                  Text(
                    widget.house.address!,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        color: Colors.blueGrey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.house.price} L.E/ Month",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle bookmark logic here
                    },
                    icon: const Icon(Icons.bookmark_add_outlined),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
