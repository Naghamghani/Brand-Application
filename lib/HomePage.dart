import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> items = [];
  String dropdownValue = 'Pants';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  Map<int, bool> selectedItems = {};

  // ✅ لأنك على Emulator: 10.0.2.2 بدل localhost
  final String baseUrl = "http://localhost/brand";

  Future<void> fetchData([String? query]) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search.php'),
        body: {'query': query ?? ''},
      );

      print("SEARCH status: ${response.statusCode}");
      print("SEARCH body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          items = json.decode(response.body);

          selectedItems.clear();
          for (int i = 0; i < items.length; i++) {
            selectedItems[i] = false;
          }
        });
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print("SEARCH error: $e");
    }
  }

  Future<void> addItem(String name, String dropdownValue) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter item name")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add.php'),
        body: {'name': trimmed, 'dropdown': dropdownValue},
      );

      print("ADD status: ${response.statusCode}");
      print("ADD body: ${response.body}");

      if (response.statusCode == 200) {
        await fetchData();
      } else {
        print('Failed to add item');
      }
    } catch (e) {
      print("ADD error: $e");
    }
  }

  Future<void> deleteSelectedItems() async {
    final List<String> idsToDelete = [];
    selectedItems.forEach((index, isSelected) {
      if (isSelected == true) {
        final id = items[index]['id']?.toString();
        if (id != null) idsToDelete.add(id);
      }
    });

    if (idsToDelete.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No items selected for deletion")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete.php'),
        body: {'ids': json.encode(idsToDelete)},
      );

      print("DELETE status: ${response.statusCode}");
      print("DELETE body: ${response.body}");

      if (response.statusCode == 200) {
        await fetchData();
      } else {
        print('Failed to delete items');
      }
    } catch (e) {
      print("DELETE error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    nameController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Final project')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => fetchData(value),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Item',
              ),
            ),
          ),
          DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              if (newValue == null) return;
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['Pants', 'Jacket', 'Shirt']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await addItem(nameController.text, dropdownValue);
                    nameController.clear();
                  },
                  child: Text('Add Item'),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await deleteSelectedItems();
                  },
                  child: Text('Delete Selected'),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                selectedItems.putIfAbsent(index, () => false);

                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: selectedItems[index] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedItems[index] = value ?? false;
                        });
                      },
                    ),
                    title: Text(items[index]['name']?.toString() ?? ''),
                    subtitle: Text(items[index]['dropdown']?.toString() ?? ''),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}