import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'country_packages_screen.dart';
import 'packages_detail_screen.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> allCountries = const [
    {"country": "Thailand", "image": "assests/images/thailand.jpg"},
    {"country": "Dubai", "image": "assests/images/dubai.jpg"},
    {"country": "Singapore", "image": "assests/images/singapore.jpg"},
    {"country": "Italy", "image": "assests/images/italy.jpg"},
    {"country": "Malaysia", "image": "assests/images/malaysia.jpg"},
    {"country": "Vietnam", "image": "assests/images/vitenam.jpg"},
    {"country": "Bali", "image": "assests/images/bali.jpeg"},
    {"country": "Maldives", "image": "assests/images/maldives.jpg"},
    {"country": "Germany", "image": "assests/images/germany.jpg"},
    {"country": "France", "image": "assests/images/france.jpg"},
  ];

  List<Map<String, String>> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    filteredCountries = allCountries;
  }

  void filterCountries(String query) {
    final results = allCountries.where((country) {
      final name = country["country"]!.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredCountries = results;
    });
  }

  Future<List<Map<String, dynamic>>> fetchTopPackages() async {
    List<Map<String, dynamic>> result = [];

    final countriesSnapshot =
    await FirebaseFirestore.instance.collection("countries").get();

    for (var countryDoc in countriesSnapshot.docs) {
      final packageSnapshot =
      await countryDoc.reference.collection("packages").limit(1).get();

      if (packageSnapshot.docs.isNotEmpty) {
        final data = packageSnapshot.docs.first.data();
        data["country"] = countryDoc.id;
        result.add(data);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isWebLayout = screenWidth > 600;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isWebLayout ? 1200 : double.infinity,
        ),
        child: ListView(
          children: [

            /// HERO
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Image.asset(
                    "assests/images/search.jpg",
                    height: isWebLayout ? 380 : screenHeight * 0.30,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: isWebLayout ? 380 : screenHeight * 0.30,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: isWebLayout ? 140 : screenHeight * 0.12,
                  child: Text(
                    "Explore the World",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isWebLayout ? 40 : 33,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 25,
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(30),
                    child: TextField(
                      controller: searchController,
                      onChanged: filterCountries,
                      decoration: const InputDecoration(
                        hintText: "Search destination...",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 16),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            /// POPULAR DESTINATIONS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Popular Destinations",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: isWebLayout ? 320 : screenHeight * 0.32,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredCountries.length,
                  itemBuilder: (context, index) {

                    final country =
                    filteredCountries[index]["country"]!;
                    final imagePath =
                    filteredCountries[index]["image"]!;

                    return Container(
                      width: isWebLayout ? 300 : screenWidth * 0.55,
                      margin: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CountryPackagesScreen(
                                      country: country),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(22),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 16,
                              child: Text(
                                country,
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// TOP PACKAGES
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Top Packages",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchTopPackages(),
              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                        child: CircularProgressIndicator()),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 16),
                    child: Text("No packages available"),
                  );
                }

                final packages = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount: packages.length,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16),
                  itemBuilder: (context, index) {

                    final data = packages[index];

                    return InkWell(
                      borderRadius:
                      BorderRadius.circular(18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PackageDetailScreen(
                                    packageData: data),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: 16),
                        padding:
                        const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 80,
                              width: 90,
                              decoration: BoxDecoration(
                                color:
                                Colors.blue.shade100,
                                borderRadius:
                                BorderRadius.circular(
                                    14),
                              ),
                              child: const Icon(
                                  Icons.flight,
                                  size: 40,
                                  color: Colors.blue),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text(
                                    data["title"] ?? "",
                                    style:
                                    const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 6),
                                  Text(
                                    data["duration"] ??
                                        "",
                                    style:
                                    const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 4),
                                  Text(
                                    data["country"] ??
                                        "",
                                    style:
                                    const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius:
                                BorderRadius.circular(
                                    12),
                              ),
                              child: Text(
                                "₹${data["price"]}",
                                style:
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}