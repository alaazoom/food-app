import 'package:flutter/material.dart';

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

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
              "images/scrollPages/screen3.png",
              height: height / 1.8,
              width: width / 1.12,
              fit: BoxFit.fill,
            ),
          ),

          const SizedBox(height: 20),

          /// العنوان الكبير
          Text(
            "Deliver your food at your \nDoorstep",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),

          const SizedBox(height: 30),

          /// العنوان الصغير
          Center(
            child: Text(
              "Quick Delivery at Your \n   Doorstep",
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
