import 'package:flutter/material.dart';
import 'package:food/screens/addfood.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50,),
            Text("Home Admin",style: TextStyle(color: Colors.black,fontFamily: "Poppins",fontSize: 24,fontWeight: FontWeight.bold),)
        , SizedBox(height: 50,),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(24),
          child: GestureDetector(
            onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFoodItems()));

            },

            child: Container(
              height: 100,width: double.infinity,
              decoration: BoxDecoration(color:Colors.black,borderRadius: BorderRadius.circular(24)),
              child: Center(child: Text("Add New Food Items",style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),fontFamily: "Poppins",fontSize: 28,fontWeight: FontWeight.bold))),
            ),
          ),
        )
        
         
          ],
        ),
      ),
    );
  }
}