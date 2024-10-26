import 'dart:async';

import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController _search;
  final Function() onSearch;

  const SearchField(
      {super.key,
      required TextEditingController search,
      required this.onSearch})
      : _search = search;

  @override
  Widget build(BuildContext context) {
    Timer? debounce;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _search,
        onChanged: (String text) {
          if (debounce?.isActive ?? false) debounce!.cancel();
          debounce = Timer(const Duration(milliseconds: 500), () {
            onSearch();
          });
        },
        decoration: const InputDecoration(
          hintText: 'Search notes?',
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
    );
  }
}
