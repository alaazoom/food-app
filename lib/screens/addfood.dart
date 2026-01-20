import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddFoodItems extends StatefulWidget {
  const AddFoodItems({super.key});

  @override
  State<AddFoodItems> createState() => _AddFoodItemsState();
}

class _AddFoodItemsState extends State<AddFoodItems> {
  String category = "";
  GlobalKey<FormState> itemsKey = GlobalKey();
  bool CategorySelected = false;
  bool CategorySelected2 = false;
  bool imageSelected = false;
  bool imageSelected2 = false;
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController decription = TextEditingController();
  bool isLoading = false;
  XFile? image;

  Future<String?> uploadToImgBB(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(
            'https://api.imgbb.com/1/upload?key=621dbc3ec83d71c2444fd401a88c408d'),
        body: {
          'image': base64Image,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['url'];
      } else {
        throw Exception(
            'Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Upload Error: $e");
      return null;
    }
  }

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Add Items",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    fontFamily: "Poppins"),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: itemsKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upload Image
                      const Text(
                        "Upload the Item Picture",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            fontFamily: "Poppins"),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            final image1 = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            setState(() {
                              image = image1;
                              imageSelected = true;
                              imageSelected2 = false;
                            });
                          },
                          child: Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: image == null
                                ? const Icon(Icons.camera_alt, size: 33)
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Image.file(
                                      File(image!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      imageSelected2
                          ? const Text(
                              "Add item picture",
                              style: TextStyle(color: Colors.red),
                            )
                          : const SizedBox.shrink(),

                      // Item Name
                      const SizedBox(height: 20),
                      const Text(
                        "Item Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            fontFamily: "Poppins"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: name,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Enter Item Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Item Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),

                      // Item Price
                      const SizedBox(height: 20),
                      const Text(
                        "Item Price",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            fontFamily: "Poppins"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: price,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Enter Item Price";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Item Price",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),

                      // Item Details
                      const SizedBox(height: 20),
                      const Text(
                        "Item Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            fontFamily: "Poppins"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: decription,
                        maxLines: 4,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Enter Item details";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Item Details",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),

                      // Category
                      const SizedBox(height: 20),
                      const Text(
                        "Select Category",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            fontFamily: "Poppins"),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _categoryButton("Ice Cream", "ice-cream"),
                          _categoryButton("Pizza", "pizza"),
                          _categoryButton("Salad", "salad"),
                          _categoryButton("Burger", "burger"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CategorySelected2
                          ? const Text(
                              "Select Category",
                              style: TextStyle(color: Colors.red),
                            )
                          : const SizedBox.shrink(),

                      const SizedBox(height: 28),
                      GestureDetector(
                        onTap: () async {
                          // Validation
                          if (!imageSelected) {
                            setState(() {
                              imageSelected2 = true;
                            });
                            return;
                          }
                          if (!CategorySelected) {
                            setState(() {
                              CategorySelected2 = true;
                            });
                            return;
                          }
                          if (itemsKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });

                            final url = await uploadToImgBB(File(image!.path));

                            if (url == null) {
                              setState(() {
                                isLoading = false;
                              });
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Upload Error',
                                desc:
                                    "Failed to upload image. Please check your internet connection.",
                                btnOkOnPress: () {},
                              ).show();
                              return;
                            }

                            try {
                              CollectionReference cat =
                                  FirebaseFirestore.instance.collection(category);
                              await cat.add({
                                'name': name.text,
                                'price': price.text,
                                'details': decription.text,
                                "cat": category,
                                "image": url,
                              });

                              CollectionReference catAll = FirebaseFirestore
                                  .instance
                                  .collection("all-items");
                              await catAll.add({
                                'name': name.text,
                                'price': price.text,
                                'details': decription.text,
                                "cat": category,
                                "image": url,
                              });

                              setState(() {
                                isLoading = false;
                              });

                              await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Added',
                                desc:
                                    "The item has been successfully added to the menu",
                              ).show();

                              Navigator.pop(context);
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: e.toString(),
                              ).show();
                            }
                          }
                        },
                        child: Container(
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12)),
                          child: const Center(
                              child: Text(
                            "Add Item",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins"),
                          )),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            height: screenHeight,
            width: MediaQuery.of(context).size.width,
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _categoryButton(String text, String catKey) {
    bool isSelected = category == catKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          category = catKey;
          CategorySelected = true;
          CategorySelected2 = false;
        });
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 79,
          width: 90,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins"),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
