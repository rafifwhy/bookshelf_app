import 'package:flutter/material.dart';

import '../pages/book_detail_page.dart';

class BookCard extends StatelessWidget {
  final int index;
  final Map book;
  final Function(Map) navToEdit;
  final Function(String) navToDelete;
  const BookCard(
      {super.key,
      required this.index,
      required this.book,
      required this.navToEdit,
      required this.navToDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                navToEdit(book);
              } else if (value == 'delete') {
                //Delete Book
                navToDelete(book['id']);
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
      ),
    );
  }
}
