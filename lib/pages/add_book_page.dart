import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBookPage extends StatefulWidget {
  final Map? book;
  const AddBookPage({super.key, this.book});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final book = widget.book;
    if (book != null) {
      isEditing = true;
      titleController.text = book['title'];
      yearController.text = book['year'];
      publisherController.text = book['publisher'];
      authorController.text = book['author'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Book' : 'Add Book')),
      body: ListView(padding: EdgeInsets.all(20), children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(labelText: 'Judul Buku'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: yearController,
          decoration: InputDecoration(labelText: 'Tahun Terbit'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: publisherController,
          decoration: InputDecoration(labelText: 'Penerbit'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: authorController,
          decoration: InputDecoration(labelText: 'Pengarang'),
        ),
        SizedBox(height: 50),
        ElevatedButton(
            onPressed: isEditing ? updateBook : addBook,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(isEditing ? 'Update' : 'Submit'),
            ))
      ]),
    );
  }

  Future<void> updateBook() async {
    final book = widget.book;
    if (book == null) {
      showErrorSnackbar('Tidak bisa melakukan edit buku!');
      return;
    }
    final id = book['id'];
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

    final url =
        'http://192.168.100.8:5000/books/${id}'; //Change into current IP
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      showSuccessSnackbar('Berhasil memperbarui buku!');
    } else {
      showErrorSnackbar('Gagal memperbarui buku!');
    }
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
      titleController.text = '';
      yearController.text = '';
      publisherController.text = '';
      authorController.text = '';
      showSuccessSnackbar('Buku berhasil ditambahkan!');
    } else {
      showErrorSnackbar('Buku gagal ditambahkan!');
    }
  }

  void showSuccessSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
