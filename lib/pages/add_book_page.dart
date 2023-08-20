import 'dart:convert';

import 'package:bookshelf_app/services/books_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/snackbar_helper.dart';

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
      showErrorSnackbar(context, message: 'Tidak bisa melakukan edit buku!');
      return;
    }
    final id = book['id'];

    final url =
        'http://192.168.100.8:5000/books/${id}'; //Change into current IP
    final uri = Uri.parse(url);
    final isSuccess = await BooksService.updateBook(id, body);
    if (isSuccess) {
      showSuccessSnackbar(context, message: 'Berhasil memperbarui buku!');
    } else {
      showErrorSnackbar(context, message: 'Gagal memperbarui buku!');
    }
  }

  Future<void> addBook() async {
    //Add book
    final url = 'http://192.168.100.8:5000/books'; //Change into current IP
    final uri = Uri.parse(url);
    final isSuccess = await BooksService.addBook(body);

    //Show messages
    if (isSuccess) {
      titleController.text = '';
      yearController.text = '';
      publisherController.text = '';
      authorController.text = '';
      showSuccessSnackbar(context, message: 'Buku berhasil ditambahkan!');
    } else {
      showErrorSnackbar(context, message: 'Buku gagal ditambahkan!');
    }
  }

  Map get body {
    //Get book data from page form
    final title = titleController.text;
    final year = yearController.text;
    final publisher = publisherController.text;
    final author = authorController.text;
    return {
      "title": title,
      "year": year,
      "publisher": publisher,
      "author": author
    };
  }
}
