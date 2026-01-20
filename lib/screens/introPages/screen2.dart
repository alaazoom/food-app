import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: height / 15),

          /// الصورة
          Center(
            child: Image.asset(
              "images/scrollPages/screen2.png",
              height: height / 1.8,
              width: width / 1.12,
              fit: BoxFit.fill,
            ),
          ),

          const SizedBox(height: 30),

          /// العنوان الكبير
          Text(
            "You can pay cash on delivery and \n        Card payment is available",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 40),

          /// العنوان الصغير
          Center(
            child: Text(
              "Easy and Online Payment",
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
