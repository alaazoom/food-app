import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: height / 20),

          /// الصورة
          Center(
            child: Image.asset(
              "images/scrollPages/screen1.png",
              height: height / 1.8,
              width: width / 1.12,
              fit: BoxFit.fill,
            ),
          ),

          const SizedBox(height: 20),

          /// العنوان الكبير
          Text(
            "Pick your food from our menu \n        More than 35 times",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),

          const SizedBox(height: 40),

          /// العنوان الصغير
          Center(
            child: Text(
              "Select from our \n   Best Menu",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
