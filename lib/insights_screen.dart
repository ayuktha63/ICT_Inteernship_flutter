import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InsightsScreen extends StatefulWidget {
  @override
  _InsightsScreenState createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  List items = [];

  Future<void> fetchInsights() async {
    final response = await http.get(Uri.parse("http://localhost:5050/weeklyComparison"));
    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchInsights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Insights")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Weekly Price Comparison", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  double latestPrice = items[index]["latestPrice"];
                  double previousPrice = items[index]["previousPrice"];
                  double priceDifference = latestPrice - previousPrice;
                  String status = priceDifference > 0 ? "Increased" : "Decreased";
                  String percentageChange = ((priceDifference / previousPrice) * 100).toStringAsFixed(2);

                  return Card(
                    child: ListTile(
                      title: Text(items[index]["_id"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Avg Price: ₹${items[index]["averagePrice"].toStringAsFixed(2)}"),
                          Text("Previous Price: ₹$previousPrice"),
                          Text("Latest Price: ₹$latestPrice"),
                          Text(
                            "Change: ₹${priceDifference.abs().toStringAsFixed(2)} (${(priceDifference / previousPrice * 100).abs().toStringAsFixed(2)}%)",
                            style: TextStyle(
                              color: status == "Increased" ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        status,
                        style: TextStyle(
                          color: status == "Increased" ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
