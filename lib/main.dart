import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

void main() {
  runApp(ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("/Users/krishna/Desktop/flutterbackend/my_app/lib/assets/logo.png"), height: 150),
            SizedBox(height: 20),
            Text("Shopping List", style: TextStyle(color: Colors.white, fontSize: 22)),
          ],
        ),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> authenticateUser(bool isSignup) async {
    final url = Uri.parse(isSignup ? "http://192.168.1.2:5050/signup" : "http://192.168.1.2:5050/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": usernameController.text,
        "password": passwordController.text,
      }),
    );

    final result = json.decode(response.body);
    if (result["message"] == "✅ Login successful!") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage("/Users/krishna/Desktop/flutterbackend/my_app/lib/assets/user.png"), height: 120), // Added image above Login
              SizedBox(height: 15),
              Text(isLogin ? "Login" : "Register", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => authenticateUser(!isLogin),
                child: Text(isLogin ? "Login" : "Register"),
              ),
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin ? "Don't have an account? Register" : "Already have an account? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
