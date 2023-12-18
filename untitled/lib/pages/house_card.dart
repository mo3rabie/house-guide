import 'package:flutter/material.dart';
import 'package:untitled/pages/item_model.dart';


class ItemCard extends StatefulWidget {
   ItemCard(this.item,this.onTap);
    Item item;
    Function()? onTap;
  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      margin: EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
        color: Color(0xfcf9f8),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white,
        ),
    ),
     child:InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.all(12.0),
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
                  image: DecorationImage(
                    image:NetworkImage(widget.item.thumb_url!),
                    fit: BoxFit.cover,
                    )
                ),
              ),
              SizedBox(height: 8.0,),
             Text(
              widget.item.title!,
              style:TextStyle( fontSize: 20.0,color: Colors.blue[800]),
              overflow: TextOverflow.ellipsis,
             ),


           Row(
            children: [
            Icon(Icons.location_on,
            color:Colors.grey,
            ),
          Text(
              widget.item.location!,
              style:TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0,color: Colors.blueGrey),
              overflow: TextOverflow.ellipsis,
             ),
           ],
           ),
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
              Text(
                "${widget.item.price}\$/ Month",
                style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 22.0),
                  overflow: TextOverflow.ellipsis,
              ),
              IconButton(
                onPressed: (){},
                 icon: Icon( Icons.favorite_border_outlined),
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