import 'package:bookshelf_app/pages/add_book_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookshelf App')),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navToAddBook, label: Text('Add Book')),
    );
  }

  void navToAddBook() {
    final route = MaterialPageRoute(
      builder: (context) => AddBookPage(),
    );

    Navigator.push(context, route);
  }
}
