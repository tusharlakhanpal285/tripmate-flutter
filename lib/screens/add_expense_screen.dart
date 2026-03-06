import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExpenseScreen extends StatefulWidget {
  final String tripId;

  const AddExpenseScreen({super.key, required this.tripId});

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState
    extends State<AddExpenseScreen> {

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  Future<void> save() async {
    if (titleController.text.isEmpty ||
        amountController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.tripId)
        .collection('expenses')
        .add({
      'title': titleController.text.trim(),
      'amount': double.parse(amountController.text.trim()),
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
          "Add Expense",
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

                  /// Expense Title
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Expense Title",
                      prefixIcon: const Icon(Icons.receipt_long),
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

                  /// Amount
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount",
                      prefixIcon: const Icon(Icons.currency_rupee),
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
                            "Save Expense",
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