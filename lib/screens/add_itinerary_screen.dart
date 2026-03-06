import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItineraryScreen extends StatefulWidget {
  final String tripId;

  const AddItineraryScreen({super.key, required this.tripId});

  @override
  State<AddItineraryScreen> createState() =>
      _AddItineraryScreenState();
}

class _AddItineraryScreenState
    extends State<AddItineraryScreen> {

  final controller = TextEditingController();

  Future<void> save() async {
    if (controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter activity")),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.tripId)
        .collection('itinerary')
        .add({
      'activity': controller.text.trim(),
      'createdAt': Timestamp.now(),
    });

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
        title: const Text(
          "Add Itinerary",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// 🔹 White Card
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

                  /// Activity Field
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Activity",
                      prefixIcon: const Icon(Icons.event_note),
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

                  /// 🔥 Gradient Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: GestureDetector(
                      onTap: save,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF42A5F5),
                              Color(0xFF1E88E5),
                            ],
                          ),
                          borderRadius:
                          BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color:
                              Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset:
                              const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "Save Activity",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight:
                              FontWeight.bold,
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