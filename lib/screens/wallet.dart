import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
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
          return _WalletBody(data: data);
        },
      ),
    );
  }
}

class _WalletBody extends StatefulWidget {
  final Map<String, dynamic> data;
  const _WalletBody({super.key, required this.data});

  @override
  State<_WalletBody> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<_WalletBody> {
  TextEditingController amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.07),

              // عنوان المحفظة
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  child: const Center(
                    child: Text(
                      "Wallet",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // رصيد المستخدم
              Container(
                width: double.infinity,
                height: 100,
                color: const Color.fromARGB(255, 242, 242, 243),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Image.asset(
                      "images/im/wallet.png",
                      width: 90,
                      height: 90,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Wallet",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                            color: const Color.fromARGB(255, 54, 83, 64),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${widget.data["wallet"]} \$",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                            color: const Color.fromARGB(255, 0, 12, 4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // حقل إدخال المبلغ
              TextFormField(
                controller: amount,
                keyboardType: TextInputType.number,
                maxLines: 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintText: "enter amount",
                  hintStyle: const TextStyle(fontSize: 24),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // أزرار المبالغ السريعة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [10, 20, 50, 100].map((val) {
                  return GestureDetector(
                    onTap: () => setState(() => amount.text = val.toString()),
                    child: Material(
                      elevation: 3,
                      child: Container(
                        height: 60,
                        width: 80,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            "$val\$",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: screenHeight * 0.05),

              // زر إضافة الأموال
              GestureDetector(
                onTap: () async {
                  // تنفيذ عملية الدفع هنا
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text(
                      "Add Money",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
