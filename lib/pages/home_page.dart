import 'dart:convert';

import 'package:bookshelf_app/pages/add_book_page.dart';
import 'package:bookshelf_app/pages/book_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
          child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index] as Map;
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BookDetailPage(book: book);
                    }));
                  },
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(book['title']),
                    subtitle: Text(book['year'] +
                        ' | ' +
                        book['publisher'] +
                        ' | ' +
                        book['author']),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          //Edit Book
                          navToEditBook(book);
                        } else if (value == 'delete') {
                          //Delete Book
                          deleteBook(book['id']);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(child: Text('Edit'), value: 'edit'),
                          PopupMenuItem(child: Text('Delete'), value: 'delete')
                        ];
                      },
                    ),
                  ),
                );
              }),
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
    //Delete book
    final url = 'http://192.168.100.8:5000/books/${id}';
    final uri = Uri.parse(url);

    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      //Delete book from the list
      final deletedBook =
          books.where((element) => element['id'] != id).toList();
      setState(() {
        books = deletedBook;
      });
      showSuccessSnackbar('Buku berhasil dihapus!');
    } else {
      showErrorSnackbar('Buku gagal dihapus!');
    }
  }

  //Getting all book
  Future<void> fetchBook() async {
    final url = 'http://192.168.100.8:5000/books';
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['data']['books'] as List;
      setState(() {
        books = result;
      });
    }
    setState(() {
      isLoading = false;
    });
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
