import 'package:flutter/material.dart';
import 'country_packages_screen.dart';


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
    return SizedBox(
      height: 200, // important for horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];

          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CountryPackagesScreen(country: country),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    country,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,


                  ),
                ),
              ),
            ),
            ),
          );
        },
      ),
    );
  }
}
