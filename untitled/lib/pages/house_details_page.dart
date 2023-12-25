// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:untitled/pages/full_screen_image_page.dart';
import 'package:untitled/pages/modules/house.dart';

class HouseDetailsPage extends StatelessWidget {
  final House item;

  const HouseDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name ?? 'House Details'),
        elevation: 100.0,
        titleTextStyle: const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 134, 172),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display all house images in a ListView
                SizedBox(
                  height: 300.0,
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: item.images!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the FullScreenImagePage when image is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(imageUrl: item.images![index]),
                              ),
                            );
                          },
                          child: Container(
                            width: 380.0,
                            margin: const EdgeInsets.only(right: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.shade200,
                              image: DecorationImage(
                                image: NetworkImage(item.images![index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                       },
                      
                       ), 
                      
                       ),
                  ),
                const SizedBox(height: 30.0),
                Row(
                  children: [
                    Text(
                      'Name: ${item.name}',
                      style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color:Color.fromARGB(255,0, 134, 172)),
                    ),
                    const SizedBox(width: 100.0),
                    Transform.scale(
                      scale: 1.5,
                      child: Icon(Icons.bookmark_add_outlined, color: Colors.black, size: 32.0),
                    ),
                    
                  ],
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.blueGrey),
                    const SizedBox(width: 10.0),
                    Text(
                      'Address: ${item.address}',
                      style: TextStyle(fontSize: 24.0, color: Colors.blueGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Icon(Icons.phone_callback_outlined, color: Colors.blueGrey),
                    const SizedBox(width: 10.0),
                    Text(
                      'Phone: +2${item.phone}',
                      style: TextStyle(fontSize: 24.0, color: Colors.blueGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Price: ${item.price} L.E/ Month',
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color:Color.fromARGB(255,0, 134, 172)),
                ),
                const SizedBox(height: 12.0),
                    Text(
                      'Description: ${item.description}',
                      style: TextStyle(fontSize: 24.0, color: Colors.black),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
