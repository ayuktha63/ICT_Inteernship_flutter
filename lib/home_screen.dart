import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'insights_screen.dart';
import 'main.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: Text("Shopping List"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AuthScreen()));
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to your Shopping List",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              _buildButton(context, "Scan", Icons.camera_alt, Colors.blue, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScanScreen()));
              }),
              SizedBox(height: 20),
              _buildButton(context, "Insights", Icons.insights, Colors.orange,
                  () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InsightsScreen()));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon,
      Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
