import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_trip_screen.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Safety check
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("User not logged in"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Trips")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('trips')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {

          // 🔴 If Firestore throws error (like index required)
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          // ⏳ Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 📭 No trips
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Trips Added Yet",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final trips = snapshot.data!.docs;

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {

              final tripDoc = trips[index];
              final data = tripDoc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(
                    data['destination'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Budget: ₹${data['budget'] ?? ''}",
                  ),

                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddTripScreen(
                              docId: tripDoc.id,
                              existingData: data,
                            ),
                          ),
                        );
                      }
                      else if (value == 'delete') {
                        await FirebaseFirestore.instance
                            .collection('trips')
                            .doc(tripDoc.id)
                            .delete();
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text("Edit"),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text("Delete"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTripScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}