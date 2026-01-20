import 'package:flutter/material.dart';
import 'package:food/screens/introPages/sceen1.dart';
import 'package:food/screens/introPages/screen2.dart';
import 'package:food/screens/introPages/screen3.dart';
import 'package:food/screens/singup.dart';

class MainPage extends StatefulWidget {

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController = PageController();
   int currentPage = 0;
  List<Widget> screens= [
    Screen1(),
    Screen2(),
    Screen3(),

  ];
 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (value){
                setState(() {
                  currentPage=value;
                });
              },
              controller: pageController,
              itemCount: screens.length,
              itemBuilder: (context,index){
                return screens[index];
              }),
          ),
           Dot(currentPage: currentPage,),
           SizedBox(height: 30,),
          GestureDetector(
            onTap: (){
            
  if (currentPage < screens.length - 1) {
    pageController.animateToPage(
      currentPage + 1,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  } else {
    // هنا تروح للـ Home
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
  }


            },
            
            child: Container(
              height: 60,
              width: 250,
              child: currentPage==screens.length-1 ?Center(child: Text("Start",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),)) : Center(child: Text("Next",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),)),
            decoration: BoxDecoration(color: Colors.red,borderRadius:BorderRadius.circular(24) ),          
            ),
          ),
          SizedBox(height: 80,),
         
          

        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final int currentPage;

  const Dot({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          height: 10,
          width: currentPage == index ? 20 : 10,
          decoration: BoxDecoration(
            color: currentPage == index ? Colors.red : Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}
