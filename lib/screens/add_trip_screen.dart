import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTripScreen extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? existingData;

  const AddTripScreen({super.key, this.docId, this.existingData});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final destinationController = TextEditingController();
  final budgetController = TextEditingController();
  final notesController = TextEditingController();

  bool get isEdit => widget.docId != null;

  @override
  void initState() {
    super.initState();

    if (isEdit && widget.existingData != null) {
      destinationController.text = widget.existingData!['destination'];
      budgetController.text = widget.existingData!['budget'];
      notesController.text = widget.existingData!['notes'] ?? "";
    }
  }

  Future<void> saveTrip() async {
    final user = FirebaseAuth.instance.currentUser;

    if (destinationController.text.isEmpty ||
        budgetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill required fields")),
      );
      return;
    }

    final data = {
      'destination': destinationController.text.trim(),
      'budget': budgetController.text.trim(),
      'notes': notesController.text.trim(),
      'userId': user!.uid,
      'createdAt': Timestamp.now(),
    };

    if (isEdit) {
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.docId)
          .update(data);
    } else {
      await FirebaseFirestore.instance
          .collection('trips')
          .add(data);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E88E5),
        centerTitle: true,
        title: Text(
          isEdit ? "Edit Trip" : "Add Trip",
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// 🔹 FORM CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [

                  /// Destination
                  TextField(
                    controller: destinationController,
                    decoration: InputDecoration(
                      labelText: "Destination",
                      prefixIcon: const Icon(Icons.location_on),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// Budget
                  TextField(
                    controller: budgetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Budget",
                      prefixIcon: const Icon(Icons.attach_money),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// Notes
                  TextField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Notes",
                      prefixIcon: const Icon(Icons.note),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🔥 Gradient Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: GestureDetector(
                  onTap: saveTrip,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.black,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isEdit ? "Update Trip" : "Save Trip",
                        style: const TextStyle(
                          color: Colors.white,  // 👈 white kar de
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}