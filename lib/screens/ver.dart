import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/home.dart';
import 'package:food/screens/navButton.dart';
import 'package:food/widgets/resend.dart';



class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        timer.cancel(); // وقف التايمر
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context)=>CurvedNav()),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // إضافة MediaQuery للأبعاد النسبية
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/im/sticker (67).webp",
              height: screenHeight * 0.18, // كان 150
              width: screenHeight * 0.18,
            ),
            SizedBox(height: screenHeight * 0.05), // كان 40
            Text(
              "Verify your email",
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: screenWidth * 0.06, // كان 24
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.025), // كان 20
            Center(
              child: Text(
                "Please verify your email \n  address by clicking on the\n   verification link in the \n    confirmation email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenWidth * 0.05, // كان 20
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05), // كان 40
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: ResendButton(),
            ),
            SizedBox(height: screenHeight * 0.035), // كان 30
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: screenHeight * 0.06, // كان 60
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.06), // كان 24
                    color: const Color.fromARGB(255, 4, 8, 68),
                  ),
                  child: Center(
                    child: Text(
                      "Back to Signup page",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.06, // كان 24
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


























































































// class VerifyScreen extends StatefulWidget {
//   const VerifyScreen({super.key});

//   @override
//   State<VerifyScreen> createState() => _VerifyScreenState();
// }

// class _VerifyScreenState extends State<VerifyScreen> {
//   Timer? timer;
//   @override
// void initState() {
//     super.initState();

//     timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
//       await FirebaseAuth.instance.currentUser?.reload();
//       final user = FirebaseAuth.instance.currentUser;

//       if (user != null && user.emailVerified) {
//         timer.cancel(); // وقف التايمر
//         if (!mounted) return;

//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           'home',
//           (route) => false,
//         );
//       }
//     });
//   }
//   @override
//   void dispose() {
//     timer?.cancel();
//     // TODO: implement dispose
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       body: Center(child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset("image/sticker (67).webp",height: 150,width: 150,),
//           SizedBox(height: 40,),
//           Text("Verify your email",style: TextStyle(color: Colors.grey.shade800,fontSize: 24,fontWeight: FontWeight.bold),),
//           SizedBox(height: 20,),
//           Center(child: Text("Please verify your email \n  address by clicking on the\n   verification link in the \n    confirmation email",style: TextStyle(color: Colors.grey.shade600,fontSize:20),)),
//           SizedBox(height: 40,),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: ResendButton(),
//           ),
//           SizedBox(height: 30,),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: GestureDetector(
//               onTap: (){
//                 Navigator.pop(context);
//               },
//               child: Container(
//                                   height: 60,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(24),
//                                     color: const Color.fromARGB(255, 4, 8, 68) ),
//                                     child: Center(child: Text("Back to Signup page",style: TextStyle(
//                                       color: Colors.white,fontWeight: FontWeight.bold,
//                                       fontSize: 24),)),
//                                 ),
//             ),
//           ),
          




//         ],
//       )),
//     );
//   }
// }