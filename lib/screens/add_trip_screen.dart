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
      appBar: AppBar(
        title: Text(isEdit ? "Edit Trip" : "Add Trip"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: destinationController,
              decoration: const InputDecoration(labelText: "Destination"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Budget"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: "Notes"),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: saveTrip,
              child: Text(isEdit ? "Update Trip" : "Save Trip"),
            ),
          ],
        ),
      ),
    );
  }
}