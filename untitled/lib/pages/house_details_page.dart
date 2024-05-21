// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/API/userServices.dart';
import 'package:untitled/pages/full_screen_image_page.dart';
import 'package:untitled/pages/modules/house.dart';
import 'package:untitled/pages/user_details_page.dart';

class HouseDetailsPage extends StatefulWidget {
  final House item;
  final String token;
  const HouseDetailsPage({super.key, required this.item, required this.token});

  @override
  State<HouseDetailsPage> createState() => _HouseDetailsPageState();
}

class _HouseDetailsPageState extends State<HouseDetailsPage> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    checkIfBookmarked();
  }

  Future<void> checkIfBookmarked() async {
    try {
      final userData = await UserService().getUserDataByToken(widget.token);
      if (userData is Map<String, dynamic>) {
        final List userBookmarks = userData['bookMark'];
        setState(() {
          isBookmarked = userBookmarks.contains(widget.item.houseId);
        });
      } else {
        throw Exception('Invalid user data format');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch user data: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
    }
  }

  void handleBookmarkAction() async {
    try {
      final result = await UserService.toggleBookmark(widget.token, widget.item.houseId!);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
        setState(() {
          isBookmarked = !isBookmarked;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (error is DioError && error.response != null && error.response!.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unauthorized: Please log in again.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        if (kDebugMode) {
          print('Error handling bookmark action: $error');
        }
      }
    }
  }

  double parsePrice(String price) {
    try {
      return double.parse(price);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing price: $e');
      }
      return 0.0; // Default value in case of error
    }
  }

  double calculateTransactionFee(double price) {
    return price * 0.10; // 10% transaction fee
  }

  double calculateTotalCost(double price) {
    return price + calculateTransactionFee(price);
  }

  @override
  Widget build(BuildContext context) {
    late String? widgetPrice = widget.item.price;
    double price = parsePrice(widgetPrice!);
    double transactionFee = calculateTransactionFee(price);
    double totalCost = calculateTotalCost(price);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name ?? 'House Details'),
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
                FutureBuilder<Map<String, dynamic>>(
                  future: UserService().getUserById(widget.item.ownerId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error fetching user data: ${snapshot.error}');
                    } else if (snapshot.data == null) {
                      return const Text('No user data available.');
                    }

                    late Map<String, dynamic>? user = snapshot.data;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailsPage(userId: user['_id'], token: widget.token),
                          ),
                        );
                      },
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: user!['profilePicture'] != null
                                  ? NetworkImage('http://192.168.43.114:3000/${user['profilePicture']}')
                                  : null,
                              radius: 50,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              user['username'],
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 134, 172)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20.0),
                SizedBox(
                  height: 300.0,
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.item.images!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(
                                  imageUrl: widget.item.images![index],
                                ),
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
                                image: NetworkImage('http://192.168.43.114:3000/${widget.item.images![index]}'),
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
                      '${widget.item.name}',
                      style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 134, 172)),
                    ),
                    const SizedBox(width: 5.0),
                    Transform.scale(
                      scale: 1.5,
                      child: IconButton(
                        onPressed: handleBookmarkAction,
                        icon: Icon(
                          isBookmarked
                              ? Icons.bookmark_added_outlined
                              : Icons.bookmark_add_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.blueGrey),
                    const SizedBox(width: 10.0),
                    Text(
                      'Address: ${widget.item.address}',
                      style: const TextStyle(fontSize: 24.0, color: Colors.blueGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    const Icon(Icons.phone_callback_outlined, color: Colors.blueGrey),
                    const SizedBox(width: 10.0),
                    Text(
                      'Phone: +2${widget.item.phone}',
                      style: const TextStyle(fontSize: 24.0, color: Colors.blueGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Price: ${widget.item.price} L.E/ Month',
                  style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 134, 172)),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Transaction Fee: $transactionFee L.E',
                  style: const TextStyle(fontSize: 24.0, color: Colors.black),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Total Cost: $totalCost L.E/ Month',
                  style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Description: ${widget.item.description}',
                  style: const TextStyle(fontSize: 24.0, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
