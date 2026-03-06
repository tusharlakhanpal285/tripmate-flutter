import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_itinerary_screen.dart';
import 'add_expense_screen.dart';
import '../services/weather_service.dart';
import '../widgets/trip_map_widget.dart';
import '../services/geocoding_service.dart';

class TripDetailScreen extends StatelessWidget {
  final String tripId;
  final Map<String, dynamic> tripData;

  const TripDetailScreen({
    super.key,
    required this.tripId,
    required this.tripData,
  });

  @override
  Widget build(BuildContext context) {
    final tripRef =
    FirebaseFirestore.instance.collection('trips').doc(tripId);

    final int budget =
        int.tryParse(tripData['budget'].toString()) ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E88E5),
        centerTitle: true,
        title: Text(
          tripData['destination'] ?? "Trip Detail",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 💰 Budget + Weather Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Budget: ₹$budget",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  FutureBuilder(
                    future: WeatherService()
                        .fetchWeather(tripData['destination']),
                    builder: (context, snapshot) {

                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      }

                      if (!snapshot.hasData ||
                          snapshot.hasError) {
                        return const Text(
                            "Weather unavailable");
                      }

                      final data =
                      snapshot.data as Map<String, dynamic>;

                      final temp =
                      data['main']['temp'];
                      final condition =
                      data['weather'][0]['main'];

                      return Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text("Weather: $condition"),
                          Text("Temperature: $temp°C"),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// 🗺 Location
            const Text(
              "Location",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 250,
                child: FutureBuilder(
                  future: GeocodingService()
                      .getCoordinates(
                      tripData['destination']),
                  builder: (context, snapshot) {

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child:
                          CircularProgressIndicator());
                    }

                    if (!snapshot.hasData ||
                        snapshot.hasError) {
                      return const Center(
                          child: Text(
                              "Location unavailable"));
                    }

                    final coords =
                    snapshot.data
                    as Map<String, double>;

                    return TripMapWidget(
                      latitude: coords['lat']!,
                      longitude: coords['lon']!,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// 💸 Expense Progress
            StreamBuilder<QuerySnapshot>(
              stream:
              tripRef.collection('expenses').snapshots(),
              builder: (context, snapshot) {

                int totalSpent = 0;

                if (snapshot.hasData) {
                  for (var doc
                  in snapshot.data!.docs) {
                    final data =
                    doc.data()
                    as Map<String, dynamic>;
                    totalSpent += int.tryParse(
                        data['amount']
                            .toString()) ??
                        0;
                  }
                }

                final remaining =
                    budget - totalSpent;

                final percent =
                budget == 0
                    ? 0.0
                    : totalSpent / budget;

                return Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: percent > 1
                          ? 1
                          : percent,
                      minHeight: 8,
                      backgroundColor:
                      Colors.grey.shade300,
                      color: percent > 1
                          ? Colors.red
                          : const Color(
                          0xFF1E88E5),
                    ),
                    const SizedBox(height: 6),
                    Text(
                        "Spent: ₹$totalSpent  |  Remaining: ₹$remaining"),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            /// 📅 Itinerary
            const Text(
              "Itinerary",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            StreamBuilder<QuerySnapshot>(
              stream: tripRef
                  .collection('itinerary')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Text(
                      "No itinerary added yet.");
                }

                final items =
                    snapshot.data!.docs;

                return Column(
                  children: items.map((doc) {
                    final data =
                    doc.data()
                    as Map<String, dynamic>;

                    return ListTile(
                      title:
                      Text(data['activity']),
                      trailing: IconButton(
                        icon: const Icon(
                            Icons.delete,
                            color: Colors.red),
                        onPressed: () =>
                            doc.reference
                                .delete(),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddItineraryScreen(tripId: tripId),
                    ),
                  );
                },
                child: const Text(
                  "Add Itinerary",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 💸 Expenses
            const Text(
              "Expenses",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            StreamBuilder<QuerySnapshot>(
              stream: tripRef
                  .collection('expenses')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Text(
                      "No expenses added yet.");
                }

                final items =
                    snapshot.data!.docs;

                return Column(
                  children: items.map((doc) {
                    final data =
                    doc.data()
                    as Map<String, dynamic>;

                    return ListTile(
                      title:
                      Text(data['title']),
                      trailing: Row(
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [
                          Text(
                              "₹${data['amount']}"),
                          IconButton(
                            icon: const Icon(
                                Icons.delete,
                                color: Colors.red),
                            onPressed: () =>
                                doc.reference
                                    .delete(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddExpenseScreen(tripId: tripId),
                    ),
                  );
                },
                child: const Text(
                  "Add Expense",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}