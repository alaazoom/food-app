import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemScreen extends StatefulWidget {
  var item;
  


   ItemScreen({super.key,required this.item});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  int count = 1;
  bool isLoading = false;

  // String price =widget.item["price"];
  @override

  Widget build(BuildContext context) {
double price = double.parse(widget.item["price"]);
double total = price * count;
String totalText = total.toStringAsFixed(2);



    return  Stack(
      children: [
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: GestureDetector(
                   onTap: () {
            Navigator.pop(context);
                },
                  child: Icon(Icons.arrow_back,color: Colors.black,
                  size: 33,),
                ),
              ),
              Center(child: Image.network(widget.item["image"],height: 350,width: 300,)),
              SizedBox(height: 20,),
              Text(widget.item["name"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 28,fontFamily: "Poppins"),)
            , SizedBox(height: 20,),
              Text(widget.item["details"],style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.bold,fontSize: 18,fontFamily: "Poppins"),)
           ,SizedBox(height: 20,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Delivery Time",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20   ,fontFamily: "Poppins"),),
                    SizedBox(width: 20,),
                    Icon(Icons.alarm,color: Colors.grey.shade700,),
                Text("30 min",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: "Poppins"),)
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        if(count>1){
                          setState(() {
                            count=count-1;
                            
                          });
                        }
                      },
                      child: Container(
                        height : 40,
                        width:40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.black),
                        child: Icon(Icons.remove,color: Colors.white,size: 28,),
                      ),
                    ),
                     SizedBox(width: 20,),
                Text(count.toString(),style: TextStyle(color: Colors.black,fontSize: 30,fontFamily: "Poppins",fontWeight: FontWeight.bold),)
                 ,SizedBox(width: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        count=count+1;
                      });
                    },
                    child: Container(
                        height : 40,
                        width:40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.black),
                        child: Icon(Icons.add,color: Colors.white,size: 28,),
                      ),
                  ),             
                  ],
                ),
              ),
              Spacer(),
        
        
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Total Price",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: "Poppins",fontSize: 20),),
                                                                  Text(totalText.toString()+"\$",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: "Poppins",fontSize: 33),),
                                  
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: ()async{
                                      DateTime now = DateTime.now();
        int hour = now.hour;
        int minute = now.minute;
        int year = now.year;
        int month = now.month;
        int day = now.day;
        String date = "${now.year}-${now.month}-${now.day}";
        
        
        String time =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
        setState(() {
          isLoading=true;
        });
        
        
                                      CollectionReference order = FirebaseFirestore.instance.collection("onOrder");
                                                     await order.add({
                                                                      'name': widget.item["name"], 
                                                                      'count': count.toString(), 
                                                                      "price":widget.item["price"],
                                                                      "total":totalText,
                                                                      "image":widget.item["image"],
                                                                      "time":time,
                                                                      "date": date,
                                                                      "id":FirebaseAuth.instance.currentUser!.uid
                                                                    });
                                                                        setState(() {
          isLoading=false;
        });
                                                                     await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Added',
        desc: "Submet the payment in order page to start delivering ypur order",
        btnOkOnPress: () {},
          ).show();
        
                                      setState(() {
                                        count=1;
        
                                      });
                                    },
                                    child: Container(height: 60,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [Text("Add to Cart",style: TextStyle(color: Colors.white,fontSize:20,fontFamily: "Poppins",fontWeight: FontWeight.bold),),SizedBox(width: 8,),Icon(Icons.shopping_cart,size: 24,color: Colors.white,)],
                                    ),
                                    width: 180,
                                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(12)),),
                                  ),
                                  SizedBox(width:8,)
                                ],
                              ),
                            ),
                            SizedBox(height:30,)
                            
        
             
           
           
           
            ],),
          ),
        ),
        
        if (isLoading)
              Container(
                height: MediaQuery.of(context).size.height,
                width:  MediaQuery.of(context).size.width,
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
      ],
    );
  }
}