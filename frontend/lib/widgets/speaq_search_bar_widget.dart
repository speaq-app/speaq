import 'package:flutter/material.dart';
import 'package:frontend/blocs/search_bloc/search_bloc.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:frontend/utils/all_utils.dart';

/// Custom [Searchbar] used for instance in [MessagesPage] and [SearchPage].
class SpqSearchBar extends StatelessWidget {
  final SearchBloc searchBloc;
  final String hintText;

  const SpqSearchBar({
    Key? key,
    required this.searchBloc,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: spqWhite,
      ),
      child: Center(
        child: TextField(
          onChanged: (value) => searchBloc.add(StartSearch(term: value)),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: spqDarkGreyTranslucent),
            border: InputBorder.none,
            hintStyle: const TextStyle(
              fontSize: 16,
              color: spqDarkGreyTranslucent,
            ),
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}
