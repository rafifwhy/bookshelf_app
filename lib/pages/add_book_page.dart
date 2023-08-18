import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Book')),
      body: ListView(padding: EdgeInsets.all(20), children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(labelText: 'Title'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: yearController,
          decoration: InputDecoration(labelText: 'Year'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: publisherController,
          decoration: InputDecoration(labelText: 'Publisher'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: authorController,
          decoration: InputDecoration(labelText: 'Author'),
        ),
        SizedBox(height: 50),
        ElevatedButton(onPressed: addBook, child: Text('Submit'))
      ]),
    );
  }

  Future<void> addBook() async {
    //Get book data from page form
    final title = titleController.text;
    final year = yearController.text;
    final publisher = publisherController.text;
    final author = authorController.text;
    final body = {
      "title": title,
      "year": year,
      "publisher": publisher,
      "author": author
    };

    //Add book
    final url = 'http://192.168.100.8:5000/books'; //Change into current IP
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    //Show messages
    if (response.statusCode == 201) {
      showSuccessSnackbar('Buku berhasil ditambahkan!');
    }
  }

  void showSuccessSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
