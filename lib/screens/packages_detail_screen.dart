import 'package:flutter/material.dart';

class PackageDetailScreen extends StatelessWidget {
  final Map<String, dynamic> packageData;

  const PackageDetailScreen({
    super.key,
    required this.packageData,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Column(
        children: [

          /// 🔥 HEADER IMAGE SECTION
          Stack(
            children: [
              Container(
                height: 260,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF42A5F5),
                      Color(0xFF1E88E5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.flight,
                  size: 100,
                  color: Colors.white,
                ),
              ),

              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 📦 PACKAGE INFO
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    packageData["title"] ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    packageData["country"] ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Icon(Icons.schedule,
                          color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        packageData["duration"] ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "About this trip",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    packageData["description"] ??
                        "Enjoy a premium travel experience with handpicked stays, guided tours and unforgettable memories.",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),

                  const Spacer(),

                  /// 💰 PRICE + BOOK BUTTON
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,   // ⬅ height badhayi
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24), // ⬅ thoda round
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                          "₹${packageData["price"]}",
                          style: const TextStyle(
                            fontSize: 24, // ⬅ price thoda bada
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),

                        SizedBox(
                          height: 50, // ⬅ button height fix
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28), // ⬅ button width
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Book Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}