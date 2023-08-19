import 'package:flutter/material.dart';

class BookDetailPage extends StatefulWidget {
  final Map book;
  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  TextEditingController codeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final book = widget.book;
    codeController.text = book['id'];
    titleController.text = book['title'];
    yearController.text = book['year'];
    publisherController.text = book['publisher'];
    authorController.text = book['author'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book['title'])),
      body: ListView(padding: EdgeInsets.all(20), children: [
        TextField(
          readOnly: true,
          controller: codeController,
          decoration: InputDecoration(labelText: "Kode Buku"),
        ),
        SizedBox(height: 10),
        TextField(
          readOnly: true,
          controller: titleController,
          decoration: InputDecoration(labelText: "Judul Buku"),
        ),
        SizedBox(height: 10),
        TextField(
          readOnly: true,
          controller: yearController,
          decoration: InputDecoration(labelText: "Tahun Terbit"),
        ),
        SizedBox(height: 10),
        TextField(
          readOnly: true,
          controller: publisherController,
          decoration: InputDecoration(labelText: "Penerbit"),
        ),
        SizedBox(height: 10),
        TextField(
          readOnly: true,
          controller: authorController,
          decoration: InputDecoration(labelText: "Pengarang"),
        )
      ]),
    );
  }
}
