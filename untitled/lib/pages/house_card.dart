// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/API/userServices.dart';
import 'package:untitled/pages/modules/house.dart';
import 'package:untitled/pages/house_details_page.dart';

class HouseCard extends StatefulWidget {
  final String token;
  const HouseCard({
    required super.key,
    required this.house,
    required this.onTap, required this.token,
  });

  final House house;
  final Function() onTap;

  @override
  State<HouseCard> createState() => _HouseCardState();
}

class _HouseCardState extends State<HouseCard> {
  bool isBookmarked = false;
  late List userBookMark;

  @override
  void initState() {
    super.initState();

    // Fetch user data first and then check if the house is bookmarked
    fetchUserData().then((_) {
      _checkIfBookmarked();
    });
  }

    Future<void> fetchUserData() async {
    try {
      final userData = await UserService().getUserDataByToken(widget.token);
      if (userData is Map<String, dynamic>) {
        setState(() {
          userBookMark = userData['bookMark'];
        });
      } else {
        throw Exception('Invalid user data format');
      }
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print('Failed to fetch user data: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
    }
  }

  void _checkIfBookmarked() {

    setState(() {
      isBookmarked = userBookMark.contains(widget.house.houseId);
    });
    }

 void _handleBookmarkAction() async {
  try {
    final result = await UserService.toggleBookmark( widget.token, widget.house.houseId!);
    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      isBookmarked = !isBookmarked;
    });
  } catch (error) {
    if (error is DioError && error.response != null && error.response!.statusCode == 401) {
      // Handle 401 Unauthorized error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unauthorized: Please log in again.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Handle other errors
      if (kDebugMode) {
        print('Error handling bookmark action: $error');
      }
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
              builder: (context) => HouseDetailsPage(item: widget.house, token: widget.token,),
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
                          image: NetworkImage(
                            'http://192.168.43.114:3000/${widget.house.images![0]}',
                          ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.house.price} L.E/ Month",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  IconButton(
                    onPressed: _handleBookmarkAction,
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark_added_outlined
                          : Icons.bookmark_add_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
