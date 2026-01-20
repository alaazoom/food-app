import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {

  OrderPage();

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<QuerySnapshot>(
  future: FirebaseFirestore.instance
      .collection('onOrder').where("id",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text("Error");
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    final docs = snapshot.data!.docs;

    return  
           Scaffold(
            backgroundColor: Colors.grey.shade200,
            body: Column(children: [
              SizedBox(height: 50,),
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                child: Center(child: Text("My Orders",
                style: TextStyle(fontSize: 32,
                fontWeight: FontWeight.bold,color: Colors.black,
                fontFamily: "Poppins"),)),
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                
                itemCount: docs.length,
                
                itemBuilder: (context,index){
                  final data = docs[index].data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Stack(
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(12),
                          elevation: 3,
                          child: Container(height: 130,width: double.infinity,
                          decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                
                                Container(height: double.infinity,width: 70,decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),border: Border.all(color: Colors.black,width: 2)),child: Center(child: Text(data["count"],style:
                                 TextStyle(color: Colors.black,fontFamily: "Poppins",fontSize: 28,fontWeight: FontWeight.bold),)),),
                                SizedBox(width: 8,),
                                Image.network(data["image"],height: 90,width: 90,),
                                SizedBox(width: 8,),
                                Column(
                                  children: [
                                  SizedBox(height:12,),
                                    Text(data["name"],style: TextStyle(color: Colors.black45,fontFamily: "Poppins",fontSize: 18,fontWeight: FontWeight.bold),),
                                                                   SizedBox(height: 8,),
                                                                    Text(data["total"]+"\$",style: TextStyle(color: Colors.black,fontFamily: "Poppins",fontSize: 21,fontWeight: FontWeight.bold),),
                        
                                  
                                  ],
                                ),
                         
                        
                              ],
                            ),
                          ),
                          
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 365,top: 60),
                          child: InkWell(
                            onTap: () async{
                              final docId = docs[index].id;


                               await FirebaseFirestore.instance
        .collection('onOrder')
        .doc(docId)
        .delete();
        setState(() {
          
        });
        
                            },
                            
                            child: Icon(Icons.delete,color: Colors.black,size: 44,)),
                        ),
                      ],
                    ),
                  );
                }),
            ),
            Container(height: 160,width: double.infinity,decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              
              
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Total Price",style: 
                      TextStyle(color: Colors.black54,fontFamily: "Poppins",fontSize: 24,fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('onOrder')
      .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return Text(
        "0",
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Poppins",
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    double totalSum = 0;

    for (var doc in snapshot.data!.docs) {
      final data = doc.data() as Map<String, dynamic>;
      totalSum += double.parse(data['total'].toString());
    }

    return Text(
      totalSum.toStringAsFixed(2)+"\$",
      style: TextStyle(
        color: Colors.black,
        fontFamily: "Poppins",
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  },
)
                      
                    ],
                  ),
                  SizedBox(height: 15,),
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: Center(child: Text("CheckOut",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),)),
                 
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(24)),
                  )
                ],
              ),
            ),
            
            
            )
            ],),
           
          );
        },

  
) ;

  }
}