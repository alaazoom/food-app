import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/signin.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Stream للبحث عن المستخدم بناءً على الحقل 'id'
  late final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance
      .collection('users')
      .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _userStream,
        builder: (context, snapshot) {
          // التعامل مع الأخطاء
          if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ ما'));
          }

          // أثناء التحميل
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // إذا لم توجد بيانات
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لا توجد بيانات"));
          }

          // استخراج بيانات أول مستند (المستخدم الحالي)
          final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;

          return body(data: data);
        },
      ),
    );
  }
}

















class body extends StatefulWidget {
   body({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;


  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> {
  TextEditingController amount = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(height: 220,width: double.infinity,
                             child: Center(
                                  child: 
                                   Text(widget.data["name"].toString().toUpperCase(),style: TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 28,fontWeight: FontWeight.bold,letterSpacing: 4),
                                   ),
                                  ),
                decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100),bottomRight: Radius.circular(100))),),
                Padding(
                  padding: const EdgeInsets.only(top: 150,left: 150),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadiusGeometry.circular(70) ,
                    child: ClipRRect(
                      
                                    borderRadius:BorderRadiusGeometry.circular(70) ,
                                    child: Container(
                                      height: 150,width: 150,
                                      child: Image.asset("images/im/person.jpg",height: 70,width: 80,fit: BoxFit.cover,))),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Material(
                    elevation: 7,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        
                        
                        children: [
                          SizedBox(width: 12,),
                        Icon(Icons.person,color: Colors.black,size: 44,),
                        SizedBox(width: 18,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
        
                          children: [
                          Text("Name",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24),),
                          
                          Text(widget.data["name"],style:TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.bold,fontSize: 24),),
        
                        ],)
        
                      ],),
                    
                    ),
                  ),
        
        
        
        
        
        SizedBox(height: 20,),
        
                  Material(
                    elevation: 7,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        
                        
                        children: [
                          SizedBox(width: 12,),
                        Icon(Icons.email,color: Colors.black,size: 44,),
                        SizedBox(width: 18,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text("Email",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:24),),
                          
                          Text(widget.data["email"],style:TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.bold,fontSize: 18),),
        
                        ],)
        
                      ],),
                    
                    ),
                  ),
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
                  SizedBox(height: 20,),
        
                  Material(
                    elevation: 7,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        
                        
                        children: [
                          SizedBox(width: 12,),
                        Icon(Icons.file_copy_sharp,color: Colors.black,size: 44,),
                        SizedBox(width: 18,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text("Terms and Conditions",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:24),),
                          
        
                        ],)
        
                      ],),
                    
                    ),
                  ),
        
        
        
        
        
        
        
        
        
        
        
                  SizedBox(height: 20,),
        
                  GestureDetector(
                    onTap:()async{
                      AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.rightSlide,
                                          title: 'Warning',
                                          desc: "You are about to Delete this account.\n Do you want to continue?",
                                          btnCancelText: "Yes",
                                          btnCancelOnPress: ()async {
                                            await FirebaseAuth.instance.currentUser!.delete(); 
                                            // 
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignIn()),(route) => false, );
                      
                                            
                                          },
                                          btnOkText: "Cancle",
                                          btnOkOnPress: (){}
                                        ).show();
                 
                    },
                    child: Material(
                      elevation: 7,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: double.infinity,
                        height: 130,
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(24)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          
                          
                          children: [
                            SizedBox(width: 12,),
                          Icon(Icons.delete,color: Colors.black,size: 44,),
                          SizedBox(width: 18,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text("Delete Account",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:24),),
                            
                            
                          ],)
                            
                        ],),
                      
                      ),
                    ),
                  ),











                   SizedBox(height: 20,),
        
                  GestureDetector(
                    onTap:()async{
                      AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.rightSlide,
                                          title: 'Warning',
                                          desc: "You are about to log out. Do you want to continue?",
                                          btnCancelText: "Yes",
                                          btnCancelOnPress: ()async {

                                            if (FirebaseAuth.instance.currentUser!.providerData.any((p) => p.providerId == 'google.com')) {
    await GoogleSignIn().signOut();
  }

  // تسجيل الخروج من Firebase
  await FirebaseAuth.instance.signOut();     





                                            
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignIn()),(route) => false, );
                      
                                            
                                          },
                                          btnOkText: "Cancle",
                                          btnOkOnPress: (){}
                                        ).show();
                 
                    },
                    child: Material(
                      elevation: 7,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: double.infinity,
                        height: 130,
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(24)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          
                          
                          children: [
                            SizedBox(width: 12,),
                          Icon(Icons.logout,color: Colors.black,size: 44,),
                          SizedBox(width: 18,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text("LogOut",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:24),),
                            
                            
                          ],)
                            
                        ],),
                      
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
      
    );
  }
}
                  