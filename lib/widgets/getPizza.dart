import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/item.dart';

class GetPizza extends StatelessWidget {

  GetPizza();

  @override
  Widget build(BuildContext context) {
    CollectionReference allItems = FirebaseFirestore.instance.collection('pizza');

    return FutureBuilder<QuerySnapshot>(
  future: FirebaseFirestore.instance
      .collection('pizza')
      .get(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text("Error");
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    final docs = snapshot.data!.docs;

    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (context, index) {
          final data = docs[index].data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.only(right: 16,bottom: 16),
            child: GestureDetector(
               onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemScreen(item: data,)));
            },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  // margin: EdgeInsets.all(24),
                  width: 230,
                  height: 290,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(data['image'], height: 120),
                      SizedBox(height: 8),
                      Text(
                        data['name'],
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(data['details'].toString()
                  .split(' ')
                  .take(3)
                  .join(' ')),
                      Text(
                        "\$${data['price']}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  },
) ;

  }
}