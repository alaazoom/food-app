import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food/screens/admin.dart';
import 'package:food/screens/adminhome.dart';
import 'package:food/screens/introPages/homeScroll.dart';
import 'package:food/screens/introPages/sceen1.dart';
import 'package:food/screens/introPages/screen2.dart';
import 'package:food/screens/introPages/screen3.dart';
import 'package:food/screens/navButton.dart';


void main() async {
    WidgetsFlutterBinding.ensureInitialized();


    await Firebase.initializeApp(
  );
  runApp( EcommercefoodApp());
}

class EcommercefoodApp extends StatelessWidget {
  const EcommercefoodApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: MainPage(),

    );
  }
}
