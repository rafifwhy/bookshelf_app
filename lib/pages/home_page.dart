import 'dart:collection';
import 'dart:convert';

import 'package:bookshelf_app/pages/add_book_page.dart';
import 'package:bookshelf_app/pages/book_detail_page.dart';
import 'package:bookshelf_app/services/books_services.dart';
import 'package:bookshelf_app/widgets/card_book.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/snackbar_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List books = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBook();
  }

  @override
  Widget build(BuildContext context) {
    //Sorting books decending by year
    books.sort((a, b) => int.parse(b['year']).compareTo(int.parse(a['year'])));
    return Scaffold(
      appBar: AppBar(title: Text('Bookshelf App')),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchBook,
          child: Visibility(
            visible: books.isNotEmpty,
            replacement: Center(
                child: Text(
              'Belum ada buku yang terdaftar!',
              style: Theme.of(context).textTheme.headline6,
            )),
            child: ListView.builder(
                itemCount: books.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final book = books[index] as Map;
                  return BookCard(
                    index: index,
                    book: book,
                    navToEdit: navToEditBook,
                    navToDelete: deleteBook,
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navToAddBook, label: Text('Add Book')),
    );
  }

  Future<void> navToEditBook(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddBookPage(book: item),
    );

    await Navigator.push(context, route);

    setState(() {
      isLoading = true;
    });
    fetchBook();
  }

  Future<void> navToAddBook() async {
    final route = MaterialPageRoute(
      builder: (context) => AddBookPage(),
    );

    await Navigator.push(context, route);

    setState(() {
      isLoading = true;
    });
    fetchBook();
  }

  //Delete Book By ID
  Future<void> deleteBook(String id) async {
    final isSuccess = await BooksService.deleteBook(id);
    if (isSuccess) {
      //Delete book from the list
      final deletedBook =
          books.where((element) => element['id'] != id).toList();
      setState(() {
        books = deletedBook;
      });
      showSuccessSnackbar(context, message: 'Buku berhasil dihapus!');
    } else {
      showErrorSnackbar(context, message: 'Buku gagal dihapus!');
    }
  }

  //Getting all book
  Future<void> fetchBook() async {
    final response = await BooksService.fetchBooks();
    if (response != null) {
      setState(() {
        books = response;
      });
    } else {
      showErrorSnackbar(context, message: 'Gagal menampilkan list buku!');
    }
    setState(() {
      isLoading = false;
    });
  }
}
