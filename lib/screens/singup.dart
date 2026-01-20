import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/signin.dart';
import 'package:food/screens/ver.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>
    with SingleTickerProviderStateMixin {

  TextEditingController user = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> key = GlobalKey<FormState>();

  bool isLoading = false;
  bool passwordError = false;
  bool emailError = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  bool view = true;
  bool view2 = false;

  @override
  void initState() {
    super.initState();
    _shakeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 0), weight: 1),
    ]).animate(_shakeController);
  }

  @override
  void dispose() {
    user.dispose();
    email.dispose();
    password.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},
      child: Scaffold(
        backgroundColor: Colors.red,
        body: Stack(
          children: [
      
            /// الخلفية البيضاء
            Padding(
              padding: EdgeInsets.only(top: h / 2.9),
              child: Container(
                height: h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
            ),
      
            /// الكارد
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Material(
                  elevation: 7,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: h / 1.7,
                    width: w,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: key,
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Colors.grey.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.06),
                          ),
                          SizedBox(height: 40),
      
                          /// USERNAME
                          AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (_, child) => Transform.translate(
                              offset: Offset(_shakeAnimation.value, 0),
                              child: child,
                            ),
                            child: TextFormField(
                              controller: user,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  _shakeController.forward(from: 0);
                                  return "Enter your name";
                                }
                                return null;
                              },
                              decoration: _inputDecoration(
                                icon: Icons.account_circle,
                                text: "Username",
                                w: w,
                                h: h,
                              ),
                            ),
                          ),
      
                          SizedBox(height: h * 0.02),
      
                          /// EMAIL
                          AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (_, child) => Transform.translate(
                              offset: Offset(_shakeAnimation.value, 0),
                              child: child,
                            ),
                            child: TextFormField(
                              controller: email,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  _shakeController.forward(from: 0);
                                  return "Enter your email";
                                }
                                if (!v.endsWith("@gmail.com")|| v.contains(" ")) {
                                  _shakeController.forward(from: 0);
                                  return "Invalid email";
                                }
                                return null;
                              },
                              decoration: _inputDecoration(
                                icon: Icons.email,
                                text: "Email",
                                w: w,
                                h: h,
                              ),
                            ),
                          ),
      
                          SizedBox(height: h * 0.02),
      
                          /// PASSWORD
                          AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (_, child) => Transform.translate(
                              offset: Offset(_shakeAnimation.value, 0),
                              child: child,
                            ),
                            child: TextFormField(
                              controller: password,
                              obscureText: view,
                              onChanged: (_) => setState(() => view2 = true),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  _shakeController.forward(from: 0);
                                  return "Enter your password";
                                }
                                if (v.length < 6) {
                                  _shakeController.forward(from: 0);
                                  return "Password too short";
                                }
                                if (v == email.text) {
                                  _shakeController.forward(from: 0);
                                  return "Password cant be your email";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                helperText: " ",
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: h * 0.018,
                                    horizontal: w * 0.02),
                                hint: Row(
                                  children: [
                                    Icon(Icons.lock,
                                        color: Colors.grey, size: w * 0.06),
                                    SizedBox(width: w * 0.015),
                                    Text("Password",
                                        style:
                                            TextStyle(fontSize: w * 0.035)),
                                  ],
                                ),
                                suffixIcon: view2
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() => view = !view);
                                        },
                                        icon: Icon(view
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      )
                                    : null,
                                errorText: passwordError
                                    ? "The password is too weak"
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
      
                          SizedBox(height: h * 0.03),
      
                          /// BUTTON
                          GestureDetector(
                            onTap: () async {
                                    if (key.currentState!.validate()) {
                                      setState(() => isLoading = true);
                                      try {
                                        final credential = await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: email.text, password: password.text);
                                        if (!mounted) return;
                                        setState(() => isLoading = false);
                                        FirebaseAuth.instance.currentUser
                                            ?.sendEmailVerification();
                                            CollectionReference users = FirebaseFirestore.instance.collection('users');
                                            await users.add({
                                                              'name': user.text, // John Doe
                                                              'email': email.text, // Stokes and Sons
                                                              'wallet': 0 ,
                                                              "id" : FirebaseAuth.instance.currentUser!.uid,
                                                              
                                                              // 42
                                                            })
                                                            
                                                            .then((value) => print("User Added=====================================================================================================\n==================================================================="))
                                                            .catchError((error) => print("Failed to add user: $error"));
      
      
      
      
      
      
      
      
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => VerifyScreen()));
                                      } on FirebaseAuthException catch (e) {
                                        setState(() => isLoading = false);
                                        _shakeController.forward(from: 0);
                                        if (e.code == 'weak-password') passwordError = true;
                                        else if (e.code == 'invalid-email'){
                                          _shakeController.forward(from: 0);
                                          emailError = true;
      
                                        }
                                        else if (e.code == 'email-already-in-use') {
                                          _shakeController.forward(from: 0);
                                          AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.rightSlide,
                                          title: 'Error',
                                          desc: "This email is already in use",
                                        ).show();
      
      
                                        }
                                        else {        print("==============================");
                                        print(e.toString());
      
                                        print("==============================");
      
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.rightSlide,
                                          title: 'Error',
                                          desc: " Check your internet connection",
                                        ).show();}
                                
                                      } catch (e) {
                                        setState(() => isLoading = false);
                                        print("==============================");
                                        print(e.toString());
      
                                        print("==============================");
      
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.rightSlide,
                                          title: 'Error',
                                          desc: "Try again later ..",
                                        ).show();
                                      }
                                    }
                                  },
                            child: Container(
                              height: h * 0.07,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Center(
                                child: Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: w * 0.05),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      
            /// LOGO
            Padding(
              padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
              child: Image.asset("images/logo.png"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 830),
              child: Row(
                children: [
                  Row(
                                          children: [
                                            SizedBox(width: w * 0.075),
                                            Text("            Already have an account ?  ",
                                                style: TextStyle(
                                                    color: Colors.grey.shade800,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: w * 0.035)),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushAndRemoveUntil(
                                                    context, MaterialPageRoute(builder: (context)=>SignIn()), (route) => false);
                                              },
                                              child: Text("SIGN IN",
                                                  style: TextStyle(
                                                      color: Colors.grey.shade900,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: w * 0.047)),
                                            ),
                                          ],
                                        ),
                ],
              ),
            ),
      
            /// LOADING
            if (isLoading)
              Container(
                height: h,
                width: w,
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

























































  InputDecoration _inputDecoration({
    required IconData icon,
    required String text,
    required double w,
    required double h,
  }) {
    return InputDecoration(
      helperText: " ",
      isDense: true,
      contentPadding:
          EdgeInsets.symmetric(vertical: h * 0.018, horizontal: w * 0.02),
      hint: Row(
        children: [
          Icon(icon, color: Colors.grey, size: w * 0.06),
          SizedBox(width: w * 0.015),
          Text(text, style: TextStyle(fontSize: w * 0.035)),
        ],
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
