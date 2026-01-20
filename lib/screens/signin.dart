import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/home.dart';
import 'package:food/screens/navButton.dart';
import 'package:food/screens/singup.dart';
import 'package:food/screens/ver.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn>
    with SingleTickerProviderStateMixin {

  bool isPressed = false;
  bool isPressed2 = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  bool isLoading = false;
  bool passwordError = false;
  bool emailError = false;
  bool view = true;
  bool view2 = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

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
    _shakeController.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},
      child: Scaffold(
        backgroundColor: Colors.red,
        body: Stack(
          children: [
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
      
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Material(
                  elevation: 7,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: h / 1.8,
                    width: w,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: key,
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Text("SIGN IN",
                                              style: TextStyle(
                                                  color: Colors.grey.shade900,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Poppins",
                                                  fontSize: w * 0.06)),
      SizedBox(height: 30),
                       
      
                          // SizedBox(height: h * 0.02),
      
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
                                if (!v.endsWith("@gmail.com") || v.contains(" ")  ) {
                                  setState(() {
                                    isLoading=false;
                                  });
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
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(_shakeAnimation.value, 0),
                                      child: child,
                                    );
                                  },
                                  child: SizedBox(
                                    height: passwordError
                                        ? screenHeight * 0.1
                                        : screenHeight * 0.08,
                                    child: TextFormField(
                                      controller: password,
                                      validator: (value) {
                                        if (password.text == "") {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          _shakeController.forward(from: 0);
                                          return "Enter your password";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        view2 = true;
                                        if (passwordError) passwordError = false;
                                      },
                                      obscureText: view,
                                      decoration: InputDecoration(
                                        suffixIcon: view2
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    view = !view;
                                                  });
                                                },
                                                icon: Icon(view
                                                    ? Icons.visibility_off
                                                    : Icons.visibility))
                                            : null,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: screenHeight * 0.02,
                                            horizontal: screenWidth * 0.02),
                                        hint: Row(
                                          children: [
                                            Icon(Icons.lock,
                                                color: Colors.grey,
                                                size: screenWidth * 0.06),
                                            SizedBox(width: screenWidth * 0.015),
                                            Text("Password",
                                                style: TextStyle(
                                                    fontSize: screenWidth * 0.035)),
                                          ],
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(screenWidth * 0.025)),
                                        fillColor: Colors.white,
                                        filled: true,
                                        helperText: " ",
                                        errorText: passwordError
                                            ? "The email or password you entered is incorrect\n Please try again"
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
      
                          SizedBox(height: h * 0.03),
      
                          /// SIGN UP BUTTON
                          GestureDetector(
                             onTap: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (key.currentState!.validate()) {
                                      try {
                                        final credential = await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: email.text,
                                                password: password.text);
                                                if (!mounted) return;
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (FirebaseAuth.instance.currentUser!
                                            .emailVerified) {
                                          Navigator.pushAndRemoveUntil(
                                              context, MaterialPageRoute(builder: (context)=>CurvedNav()), (route) => false);
                                        } else {
                                          FirebaseAuth.instance.currentUser!
                                              .sendEmailVerification();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VerifyScreen()));
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        if (!mounted) return;
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (e.code == 'user-not-found') {
                                          _shakeController.forward(from: 0);
                                          emailError = true;
                                        } else if (e.code == 'wrong-password' ||
                                            e.code == 'invalid-credential' ||
                                            e.code == 'too-many-requests') {
                                          _shakeController.forward(from: 0);
                                          passwordError = true;
                                        }else if (e.code == 'invalid-email'){
                                          _shakeController.forward(from: 0);
                                          emailError = true;
      
                                        }
                                        
                                        
                                         else {
                                          setState(() {
                                    isLoading=false;
                                  });
                                          _shakeController.forward(from: 0);
                                         
                                        print("==============================");
                                        print(e.toString());
                                        
      
                                        print("==============================");
      
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.rightSlide,
                                          title: 'Error',
                                          desc: "Check your internet connection",
                                        ).show();
                                       
                                        }
                                      }
                                      catch (e) {
                                        setState(() {
                                    isLoading=false;
                                  });
        if (!mounted) return;
        _shakeController.forward(from: 0);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: "Check your internet connection",
        ).show();
        
      }
                                    }return;
                                  },
                            child: Container(
                              height: h * 0.07,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.05,
                                  ),
                                ),
                              ),
                            ),
                          ),
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
                           SizedBox(height: screenHeight * 0.015),
                                // Continue with Google
                                GestureDetector(
                                  onTap: () async {
                                    try{
                                       setState(() {
                                isLoading=true;
                              });
                              final GoogleSignIn googleSignIn = GoogleSignIn();
                              
                              final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
                                                                    if (googleUser == null) {
                                          // المستخدم ألغى تسجيل الدخول
                                          setState(() {
                                            isLoading = false;
                                          });
                                          return;
      
                                        }
                                        final GoogleSignInAuthentication googleAuth =
                                            await googleUser.authentication;
                                            final OAuthCredential credential = GoogleAuthProvider.credential(
                                          idToken: googleAuth.idToken,
                                          accessToken: googleAuth.accessToken,
                                        );
      
                                        // Sign in to Firebase
                                        await FirebaseAuth.instance.signInWithCredential(credential);
      
                                        setState(() {
                                          isLoading = false;
                                        });
                                        
       
      
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      
                                    }catch(e){
                                          _shakeController.forward(from: 0);
                                          setState(() => isLoading = false);
      
                                          print("==============================");
                                          print(e.toString());
                                          print("==============================");
      
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.rightSlide,
                                            title: 'Error',
                                            desc: "Check your internet connection",
                                          ).show();
      
                                    }
      
      
      },
      
                                  child: Container(
                                   height: h * 0.07,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(screenWidth * 0.05),
                                      color: Colors.red
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Continue with Google",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth * 0.045)),
                                          SizedBox(width: screenWidth * 0.02),
                                          Image.asset(
                                            "images/im/sticker (65).webp",
                                            height: screenWidth * 0.06,
                                            width: screenWidth * 0.06,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.015),
                                // Forgot Password
                                Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(email: email.text);
                                            setState(() {
                                        isLoading = false;
                                      });
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          title: 'Sent',
                                          desc: 'Check your email to reset your password.',
                                        ).show();
                                      } catch (e) {
                                        setState(() {
                                        isLoading = false;
                                      });
                                        _shakeController.forward(from: 0);
                                        
                                      }
                                    },
                                    child: Text("Forgot Password ?",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.05)),
                                  ),
                                ),
                       
                                
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.only(top: 70, right: 10, left: 10),
              child: Image.asset("images/logo.png"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 690,left: 40,right: 40),
              child: Center(
                                    child: Row(
                                      children: [
                                        SizedBox(width: w * 0.075),
                                        Text("Don’t have an account?  ",
                                            style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.bold,
                                                fontSize: w * 0.045)),
                                        GestureDetector(
                                          onTap: () {
                                                                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignUp()), (route) => false);
      
                                          },
                                          child: Text("SIGN UP",
                                              style: TextStyle(
                                                  color: Colors.grey.shade900,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: w * 0.047)),
                                        ),
                                       
                                      ],
                                    ),
                                  ),
            ),
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
    Widget? suffix,
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
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
