import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/adminhome.dart';

class AdminLogin extends StatelessWidget {
  AdminLogin({super.key});

  final GlobalKey<FormState> admin = GlobalKey();
  final TextEditingController user = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade400,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 400,
                    maxHeight: screenHeight * 0.8, // مناسب لجميع الشاشات
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                  child: Form(
                    key: admin,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Admin Panel",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: user,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Enter Your Username";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "admin",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: pass,
                          obscureText: true,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Enter Your password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            if (admin.currentState!.validate()) {
                              if (user.text == "admin" && pass.text == "12345a") {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => AdminHome()),
                                    (route) => false);
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc: "There is an error, Try again later",
                                ).show();
                              }
                            }
                          },
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Center(
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
