import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/widgets/burgerC.dart';
import 'package:food/widgets/detIceCream.dart';
import 'package:food/widgets/getAll.dart';
import 'package:food/widgets/getAllC.dart';
import 'package:food/widgets/getBurger.dart';
import 'package:food/widgets/getPizza.dart';
import 'package:food/widgets/getSalad.dart';
import 'package:food/widgets/iceCreamC.dart';
import 'package:food/widgets/pizzaC.dart';
import 'package:food/widgets/saladS.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  late final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance
      .collection('users')
      .where('id', isEqualTo: uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('حدث خطأ ما'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لا توجد بيانات"));
          }

          final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          return _Body(data: data);
        },
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final Map<String, dynamic> data;
  const _Body({super.key, required this.data});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool ice = false;
  bool pizza = false;
  bool burger = false;
  bool salad = false;

  Widget theRow = GetAllFood();
  Widget theColumn = GetAllFoodC();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.09),
            Text(
              "Hello ${widget.data['name']} ,",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            const Text(
              "Delicious Food",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: "Poppins"),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "Discover and Get Great Food",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700, fontFamily: "Poppins"),
            ),
            SizedBox(height: screenHeight * 0.05),

            // خيارات الطعام
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFoodIcon("ice-cream.png", ice, () {
                  setState(() {
                    ice = true;
                    pizza = false;
                    burger = false;
                    salad = false;
                    theRow = GetIceCream();
                    theColumn = IceCreamC();
                  });
                }),
                _buildFoodIcon("pizza.png", pizza, () {
                  setState(() {
                    ice = false;
                    pizza = true;
                    burger = false;
                    salad = false;
                    theRow = GetPizza();
                    theColumn = Pizzac();
                  });
                }),
                _buildFoodIcon("salad.png", salad, () {
                  setState(() {
                    ice = false;
                    pizza = false;
                    burger = false;
                    salad = true;
                    theRow = GetSalad();
                    theColumn = Saladc();
                  });
                }),
                _buildFoodIcon("burger.png", burger, () {
                  setState(() {
                    ice = false;
                    pizza = false;
                    burger = true;
                    salad = false;
                    theRow = GetBurger();
                    theColumn = Burgerc();
                  });
                }),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
            theRow,
            SizedBox(height: 10),
            theColumn,
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodIcon(String asset, bool active, VoidCallback onTap) {
    return Material(
      elevation: 7,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: active ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Image.asset(
              "images/im/$asset",
              height: 60,
              width: 60,
              color: active ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
