import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/pages/modules/house.dart';
import 'package:untitled/pages/house_details_page.dart';

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
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    // Check if the house is bookmarked when the widget is initialized
    _checkIfBookmarked();
  }

  void _checkIfBookmarked() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        // Check if the 'bookmarks' field exists
        if (userDoc.exists && userDoc.data() != null && userDoc.data()!['bookmarks'] != null) {
          // Check if the house is in the 'bookmarks' array
          setState(() {
            isBookmarked = userDoc.data()!['bookmarks'].contains(widget.house.houseId);
          });
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error checking if bookmarked: $error');
      }
    }
  }

  void _handleBookmarkAction() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get user's document reference
        DocumentReference<Map<String, dynamic>> userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Get user's current bookmarks
        List<dynamic> bookmarks = [];

        DocumentSnapshot<Map<String, dynamic>> userDoc = await userDocRef.get();

        if (userDoc.exists && userDoc.data() != null && userDoc.data()!['bookmarks'] != null) {
          bookmarks = List.from(userDoc.data()!['bookmarks']);
        }

        // Update bookmarks based on user's action
        if (isBookmarked) {
          // Remove house UID from bookmarks
          bookmarks.remove(widget.house.houseId);
        } else {
          // Add house UID to bookmarks
          bookmarks.add(widget.house.houseId);
        }

        // Update 'bookmarks' field in the user's document
        await userDocRef.update({'bookmarks': bookmarks});

        // Update local state
        setState(() {
          isBookmarked = !isBookmarked;
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error handling bookmark action: $error');
      }
    }
  }
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
                style: const TextStyle(fontSize: 20.0, color: Colors.blue),
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
              // Toggle bookmark state and perform the corresponding action
              setState(() {
                isBookmarked = !isBookmarked;
                _handleBookmarkAction();
              });
            },
            icon: Icon(
              isBookmarked
                  ? Icons.bookmark_added_outlined
                  : Icons.bookmark_add_outlined,
            ),
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
