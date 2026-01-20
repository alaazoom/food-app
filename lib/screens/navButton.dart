import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/home.dart';
import 'package:food/screens/order.dart';
import 'package:food/screens/profile.dart';
import 'package:food/screens/wallet.dart';

class CurvedNav extends StatefulWidget {
  const CurvedNav({super.key});

  @override
  State<CurvedNav> createState() => _CurvedNavState();
}

class _CurvedNavState extends State<CurvedNav> {
  List<Widget> screens = [HomePage(), OrderPage(), WalletPage(), ProfilePage()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double iconSize = MediaQuery.of(context).size.width * 0.07; // أيقونات متناسبة

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65, // ثابت ≤ 75
        backgroundColor: Colors.white,
        color: Colors.black,
        buttonBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        animationDuration: const Duration(milliseconds: 300),
        items: [
          Icon(Icons.home_outlined, size: iconSize, color: Colors.white),
          Icon(Icons.shopping_bag_outlined, size: iconSize, color: Colors.white),
          Icon(Icons.wallet, size: iconSize, color: Colors.white),
          Icon(Icons.person, size: iconSize, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: screens[currentIndex],
    );
  }
}
