// ignore_for_file: file_names

import 'dart:convert';
import "dart:io";
import 'dart:io';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class AddHouse extends StatelessWidget {
  File? myfile;
  String? ownername;
  String? phone;
  String? address;
  String? photos;
  String? price;
  String? desciption;
  //هتعملي لكل الفيلدز متغير زي كده ده بتاع ال onsaved
  GlobalKey<FormState> formsstate = GlobalKey();
  //هنا/// TextEditingController D = TextEditingController();
  String? textval; //القيمة الهكتبها في الفيلد هتتخزن في المتغير ده
  AddHouse({super.key});

  static const screenRoute = '/Add';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 100.0,
        title: const Text('Add New House'),
        titleTextStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
      ),

      body: Container(
          color: const Color.fromARGB(255, 247, 246, 246),
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formsstate,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " the feild is Empty";
                    }
                    if (value.length < 3) {
                      return "The name cannot be less than 3";
                    }
                  },
                  maxLines: 1,
                  maxLength: 12,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      // borderRadius: BorderRadius.circular(40),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    //icon: Icon(Icons.person),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.person),
                    suffixIconColor: Colors.blue,
                    labelText: "Owner Name",
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ), //fontWeight: FontWeight.bold),
                    hintStyle: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                  //هنا//controller: D,
                  onSaved: (val) {
                    ownername = val; //اعطيناه القيمة val
                    //كده اي قيمة هكتبها في الفيلد هتتخزن في textval
                  },
                ),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " the feild is Empty";
                    }
                    if (value.length < 11) {
                      return "The name cannot be less than 11";
                    }
                    if (value.length > 11) {
                      return "The name cannot be more than 11";
                    }
                  },
                  maxLines: 1,
                  maxLength: 11,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      // borderRadius: BorderRadius.circular(40)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    //icon: Icon(Icons.person),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.call),
                    suffixIconColor: Colors.blue,
                    labelText: "Phone",
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ), //fontWeight: FontWeight.bold),
                    hintStyle: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                  //هنا//controller: D,

                  onSaved: (val) {
                    phone = val; //اعطيناه القيمة val
                    //كده اي قيمة هكتبها في الفيلد هتتخزن في textval
                  },
                ),
                // هنا //MaterialButton(
                // color: Colors.blue,
                // textColor: Colors.white,
                // onPressed: () {
                //  print(D.text);
                // },
                //  child: Text("Send"),
                // ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " the feild is Empty";
                    }
                    //if (value.length < 11) {
                    // return "The name cannot be less than 11";
                    //}
                    // if (value.length > 11) {
                    // return "The name cannot be more than 11";
                    // }
                  },
                  maxLines: 2,
                  //maxLength: 30,
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      // borderRadius: BorderRadius.circular(40)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    //icon: Icon(Icons.person),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.location_on),
                    suffixIconColor: Colors.blue,
                    labelText: "Address",
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ), //fontWeight: FontWeight.bold),
                    hintStyle: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                  //هنا//controller: D,
                  onSaved: (val) {
                    address = val; //اعطيناه القيمة val
                    //كده اي قيمة هكتبها في الفيلد هتتخزن في textval
                  },
                ),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " the feild is Empty";
                    }
                    if (value.length < 1) {
                      return "The name cannot be less than 1";
                    }
                  },
                  maxLines: 1,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      // borderRadius: BorderRadius.circular(40)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    //icon: Icon(Icons.person),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.price_change),
                    suffixIconColor: Colors.blue,
                    labelText: "Price",
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ), //fontWeight: FontWeight.bold),
                    hintStyle: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                  //هنا//controller: D,
                  onSaved: (val) {
                    price = val; //اعطيناه القيمة val
                    //كده اي قيمة هكتبها في الفيلد هتتخزن في textval
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " the feild is Empty";
                    }
                    // if (value.length <) {
                    // return "The name cannot be less than 2";
                    // }
                  },
                  maxLines: 3,
                  maxLength: 70,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      // borderRadius: BorderRadius.circular(40)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    //icon: Icon(Icons.person),
                    fillColor: Colors.white,
                    filled: true,
                    //suffixIcon: Icon(Icons.text_fields),
                    suffixIconColor: Colors.blue,
                    labelText: "Desciption",
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ), //fontWeight: FontWeight.bold),
                    hintStyle: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                  //هنا//controller: D,
                  onSaved: (val) {
                    desciption = val; //اعطيناه القيمة val
                    //كده اي قيمة هكتبها في الفيلد هتتخزن في textval
                  },
                ),
                MaterialButton(
                  color: Colors.white,
                  textColor: Colors.blue,
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Please choose image ",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    XFile? xFile = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    File myfile = File(xFile!.path);
                                    //فيه هنا exception erorr
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      "from Gallery",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    XFile? xFile = await ImagePicker()
                                        .pickImage(source: ImageSource.camera);
                                    File myfile = File(xFile!.path);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      " from Camera",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                )
                              ],
                            )));
                  },
                  // ignore: avoid_print

                  child: const Text("Choose image"),
                ),

                MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    if (formsstate.currentState!.validate()) {
                      formsstate.currentState!.save();
                      print(ownername);
                      print(phone);
                      print(address);
                      print(price);
                      print(desciption);
                    } else {
                      // ignore: avoid_print
                      print(" not valid");
                    }
                  },
                  // ignore: avoid_print
                  //child: const Text("not valid"),
                  child: const Text("Send"),

                  //لما ادوس علي البوتون هيطبعلي القيمة الكتبتها
                ),
              ],
            ),
          )),
      // body: const Center(
      // child: Text(
      // 'Add Your House',
      //style: TextStyle(
      //  fontFamily: 'ElMessiri',
      // fontSize: 24,
      // fontWeight: FontWeight.bold),
      //),
      // ),
    );
  }

  // postRequestWithFile(String url, Map data, File file) async {
  // var request = http.MultipartRequest("POST", Uri.parse(url));
  // var length = await file.length();
  //var stream = http.ByteStream(file.openRead());
  // var multipartFile = http.MultipartFile("file", stream, length,
  //     filename: basename(file.path));
  // request.files.add(multipartFile);
  // data.forEach((key, value) {
  // request.fields[key] = value;
  //  });
  // var myrequest = await request.send();
  // var response = await http.Response.fromStream(myrequest);
  // if (myrequest.statusCode == 200) {
  //  return jsonDecode(response.body);
  // } else {
  //   print("ُErorr ${myrequest.statusCode}");
  // }
  //اسم file ده
  //اسم ال request
  //لازم نلتزم بنفس الاسم في ال backend بتاع الhttp
  // }
}

//class Test extends StatefulWidget {
  //Test({required Key key}) : super(key: key);

  //@override
  ////TestState createState() => TestState();
//}

//class TestState extends State<Test> {
 // @override
 //// Widget build(BuildContext context) {
   // return Scaffold(
     // appBar: AppBar(
       // title: Text('Upload'),
     // ),
///body: Container(),
   //// );
 // }
//}
