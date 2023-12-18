import 'package:flutter/material.dart';
import 'package:untitled/pages/loginScreen.dart';
import 'package:untitled/pages/regScreen.dart';
 
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity, 
          width: double.infinity,
          color: Colors.white,
          child:SingleChildScrollView(
          child: Column(
            children: [
            Container( 
            width: 1280,
            height: 650,
            padding: const EdgeInsets.only(top: 100.0),
            child :  Image.asset('asset/images/logo.png',

             )
            ),      
          

        const SizedBox(height: 30,),
          GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  LoginScreen()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                
                color: Color.fromARGB(255,0, 134, 172),
              ),
              child: const Center(child: Text('Login',style: TextStyle(
                  fontSize: 20,
                  
                  color: Colors.white
              ),),),
            ),
          ),
           const SizedBox(height: 30,),
           GestureDetector(
             onTap: (){
               Navigator.push(context,
                   MaterialPageRoute(builder: (context) => const RegScreen()));
             },
          child: Container(
            
            
            height: 53,
            width: 320,
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(20),
              border: Border.all(color: Color.fromARGB(255,0, 134, 172)), 
            ),
            child: Center(child: Text('Sign up', style: TextStyle(
              fontSize: 20,
              
              color: const Color.fromARGB(255,0, 134, 172),
            ),)),
          ),
        )
        ,
        const SizedBox(height: 30,),
            ],
           
          ),
        ),
     )
     );
     
  }
}
