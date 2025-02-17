import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemQtyController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  List items = [];

  Future<void> addItem() async {
    final response = await http.post(
      Uri.parse("http://192.168.1.2:5050/addItem"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": itemNameController.text,
        "quantity": int.tryParse(itemQtyController.text) ?? 1,
        "price": double.tryParse(itemPriceController.text) ?? 0.0,
      }),
    );

    if (response.statusCode == 200) {
      fetchItems();
      itemNameController.clear();
      itemQtyController.clear();
      itemPriceController.clear();
    }
  }

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse("http://192.168.1.2:5050/getItems"));
    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body);
      });
    }
  }

  Future<void> deleteItem(String itemId) async {
    final response = await http.delete(Uri.parse("http://192.168.1.2:5050/deleteItem/$itemId"));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item deleted successfully")));
      fetchItems(); // Refresh list after deletion
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to delete item")));
    }
  }

  void confirmDelete(String itemId, String itemName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Item"),
          content: Text("Are you sure you want to delete '$itemName'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteItem(itemId);
                Navigator.pop(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan & Add Items")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: itemNameController, decoration: InputDecoration(labelText: "Item Name")),
            TextField(controller: itemQtyController, decoration: InputDecoration(labelText: "Quantity"), keyboardType: TextInputType.number),
            TextField(controller: itemPriceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(onPressed: addItem, child: Text("Add Item")),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  String itemId = items[index]["_id"];
                  String itemName = items[index]["name"];

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(itemName),
                      subtitle: Text("Qty: ${items[index]["quantity"]} | Price: ₹${items[index]["price"]}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => confirmDelete(itemId, itemName),
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
