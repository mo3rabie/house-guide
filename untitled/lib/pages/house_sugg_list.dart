import 'package:flutter/material.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/item_model.dart';

// ignore: must_be_immutable
class HouseSuggList extends StatefulWidget {
  HouseSuggList(this.title, this.items);
  String? title;
  List<Item> items;

  @override
  State<HouseSuggList> createState() => _HouseSuggListState();
}

class _HouseSuggListState extends State<HouseSuggList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              TextButton(onPressed: () {}, child: Text("See All"))
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Container(
            height: 340.0,
            width: double.infinity,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.items.length,
                itemBuilder: (context, index) => 
                ItemCard(widget.items[index],(){}),
          )
          ),
          
        ],
      ),
    );
  }
}
