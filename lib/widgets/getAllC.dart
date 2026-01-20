import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/item.dart';

class GetAllFoodC extends StatelessWidget {

  GetAllFoodC();

  @override
  Widget build(BuildContext context) {
    CollectionReference allItems = FirebaseFirestore.instance.collection('all-items');

    return FutureBuilder<QuerySnapshot>(
  future: FirebaseFirestore.instance
      .collection('all-items')
      .get(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text("Error");
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    final docs = snapshot.data!.docs;

    return ListView.builder(
        shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;
    
        return 
          Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
               onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemScreen(item: data,)));
            },
              child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(16),
                       child: Container(
                        height: 120,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            
                            
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(data["image"],width: 120,height: 90,),
                              // SizedBox(width:10,)  ,
                              Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Text(
                                                          data["name"] , 
                                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,fontFamily: "Poppins"),
                                          ),
                                           Text(
                          data['details'].toString()
                  .split(' ')
                  .take(5)
                  .join(' ') , 
                          style: const TextStyle(fontSize:14, color: Color.fromARGB(255, 39, 38, 38),fontFamily: "Poppins"),
                                      ),
                                       Text(
                           "\$${data['price']}" , 
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,fontFamily: "Poppins"),
                                      ),
                                ],
                              ),
                                      
                          
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                       ),
                     ),
            ),
          )
       ;
      },
    );
  },
) ;

  }
}