// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SearchToolbar extends StatelessWidget {
  String searchQuery = '';
  final void Function(String) onSearch;

  SearchToolbar({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            onSubmitted: onSearch,
            onChanged: (value) => searchQuery = value.trim().toLowerCase(),
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search Society',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
          ),
        ),
        IconButton(
          onPressed: () => onSearch(searchQuery),
          icon: const Icon(Icons.search),
        )
      ],
    );
  }
}
