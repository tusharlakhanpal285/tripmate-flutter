import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/travel_package.dart';


class CountryPackagesScreen extends StatelessWidget {
  final String country;

  const CountryPackagesScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$country Packages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('countries')
            .doc(country)
            .collection('packages')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final packages = snapshot.data!.docs;

          return ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final data =
              packages[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(data['title'] ?? ''),
                  subtitle: Text(
                    "${data['duration']} - ₹${data['price']}",
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
