// import 'dart:convert';
// import 'dart:io';

// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

// class AddCarPage extends StatefulWidget {
//   const AddCarPage({super.key});

//   @override
//   State<AddCarPage> createState() => _AddCarPageState();
// }

// class _AddCarPageState extends State<AddCarPage> {
//   final GlobalKey<FormState> itemsKey = GlobalKey<FormState>();

//   // Controllers
//   TextEditingController model = TextEditingController();
//   TextEditingController price = TextEditingController();
//   TextEditingController engine = TextEditingController();
//   TextEditingController speed = TextEditingController();
//   TextEditingController seats = TextEditingController();

//   // Dropdown
//   String? selectedBrand;
//   List<String> brands = ["BMW", "Lamborghini", "Audi"];

//   // Image
//   XFile? image;
//   bool imageSelected = false;
//   bool imageSelected2 = false;

//   bool isLoading = false;

//   // Upload Image to ImgBB
//   Future<String?> uploadToImgBB(File imageFile) async {
//     try {
//       final bytes = await imageFile.readAsBytes();
//       final base64Image = base64Encode(bytes);

//       final response = await http.post(
//         Uri.parse(
//             'https://api.imgbb.com/1/upload?key=621dbc3ec83d71c2444fd401a88c408d'),
//         body: {'image': base64Image},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['data']['url'];
//       } else {
//         throw Exception(
//             'Failed to upload image. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Upload Error: $e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: Scaffold(
//             appBar: AppBar(
//               title: const Text(
//                 "Add Car",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 28,
//                     fontFamily: "Poppins"),
//               ),
//               centerTitle: true,
//             ),
//             body: Padding(
//               padding: const EdgeInsets.all(20),
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: itemsKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Upload Image
//                       const Text(
//                         "Upload the Car Picture",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 24,
//                             fontFamily: "Poppins"),
//                       ),
//                       const SizedBox(height: 15),
//                       Center(
//                         child: GestureDetector(
//                           onTap: () async {
//                             final picked = await ImagePicker()
//                                 .pickImage(source: ImageSource.gallery);
//                             setState(() {
//                               image = picked;
//                               imageSelected = true;
//                               imageSelected2 = false;
//                             });
//                           },
//                           child: Container(
//                             height: 160,
//                             width: 160,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(24),
//                               border: Border.all(color: Colors.black, width: 2),
//                             ),
//                             child: image == null
//                                 ? const Icon(Icons.camera_alt, size: 33)
//                                 : ClipRRect(
//                                     borderRadius: BorderRadius.circular(24),
//                                     child: Image.file(
//                                       File(image!.path),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       imageSelected2
//                           ? const Text(
//                               "Add car picture",
//                               style: TextStyle(color: Colors.red),
//                             )
//                           : const SizedBox.shrink(),

//                       const SizedBox(height: 20),

//                       // Engine, Speed, Seats
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _field(engine, "Engine"),
//                           _field(speed, "Speed"),
//                           _field(seats, "Seats"),
//                         ],
//                       ),

//                       const SizedBox(height: 20),

//                       // Model
//                       const Text(
//                         "Car Model",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 24,
//                             fontFamily: "Poppins"),
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: model,
//                         validator: (v) =>
//                             v == null || v.isEmpty ? "Enter Model" : null,
//                         decoration: _dec("Car Model"),
//                       ),

//                       const SizedBox(height: 20),

//                       // Price
//                       const Text(
//                         "Rent Price",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 24,
//                             fontFamily: "Poppins"),
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: price,
//                         keyboardType: TextInputType.number,
//                         validator: (v) =>
//                             v == null || v.isEmpty ? "Enter Price" : null,
//                         decoration: _dec("Price per hour"),
//                       ),

//                       const SizedBox(height: 25),

//                       // Brand
//                       DropdownButtonFormField2(
//                         hint: const Text("Car Brand"),
//                         value: selectedBrand,
//                         items: brands
//                             .map((b) =>
//                                 DropdownMenuItem(value: b, child: Text(b)))
//                             .toList(),
//                         validator: (v) =>
//                             v == null ? "Select brand" : null,
//                         onChanged: (v) =>
//                             setState(() => selectedBrand = v as String),
//                       ),

//                       const SizedBox(height: 28),

//                       // Submit
//                       GestureDetector(
//                         onTap: () async {
//                           if (!imageSelected) {
//                             setState(() => imageSelected2 = true);
//                             return;
//                           }
//                           if (!itemsKey.currentState!.validate()) return;

//                           setState(() => isLoading = true);

//                           final imageUrl =
//                               await uploadToImgBB(File(image!.path));

//                           if (imageUrl == null) {
//                             setState(() => isLoading = false);
//                             AwesomeDialog(
//                               context: context,
//                               dialogType: DialogType.error,
//                               title: "Upload Error",
//                               desc: "Failed to upload image",
//                               btnOkOnPress: () {},
//                             ).show();
//                             return;
//                           }

//                           // Save to Firestore in collection 'car'
//                           try {
//                             await FirebaseFirestore.instance
//                                 .collection("car")
//                                 .add({
//                               "brand": selectedBrand,
//                               "model": model.text,
//                               "engine": engine.text,
//                               "speed": speed.text,
//                               "seats": seats.text,
//                               "price_per_hour": price.text,
//                               "image": imageUrl,
//                               "createdAt": FieldValue.serverTimestamp(),
//                             });

//                             setState(() => isLoading = false);

//                             await AwesomeDialog(
//                               context: context,
//                               dialogType: DialogType.success,
//                               title: "Added",
//                               desc: "Car has been added successfully",
//                               btnOkOnPress: () {
//                                 Navigator.pop(context);
//                               },
//                             ).show();
//                           } catch (e) {
//                             setState(() => isLoading = false);
//                             AwesomeDialog(
//                               context: context,
//                               dialogType: DialogType.error,
//                               title: "Error",
//                               desc: e.toString(),
//                               btnOkOnPress: () {},
//                             ).show();
//                           }
//                         },
//                         child: Container(
//                           height: 70,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                               color: Colors.black,
//                               borderRadius: BorderRadius.circular(12)),
//                           child: const Center(
//                             child: Text(
//                               "Add Car",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: "Poppins"),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         if (isLoading)
//           Container(
//             height: screenHeight,
//             width: double.infinity,
//             color: Colors.black26,
//             child: const Center(child: CircularProgressIndicator()),
//           ),
//       ],
//     );
//   }

//   // Helper field
//   Widget _field(TextEditingController c, String hint) {
//     return SizedBox(
//       width: 120,
//       child: TextFormField(
//         controller: c,
//         validator: (v) => v == null || v.isEmpty ? "$hint required" : null,
//         decoration: _dec(hint),
//       ),
//     );
//   }

//   InputDecoration _dec(String hint) => InputDecoration(
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       );
// }
