import 'package:flutter/material.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  final List<String> countries = const [
    'Thailand',
    'Dubai',
    'Singapore',
    'Italy',
    'Malaysia',
    'Vietnam',
    'Bali',
    'Maldives',
    'Germany',
    'France',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: const Icon(Icons.public, size: 32),
            title: Text(
              country,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigation will come next
            },
          ),
        );
      },
    );
  }
}
