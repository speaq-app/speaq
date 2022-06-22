import 'package:flutter/material.dart';
import 'package:frontend/blocs/search_bloc/search_bloc.dart';
import 'package:frontend/utils/all_utils.dart';

class SpqSearchBar extends StatelessWidget {
  final SearchBloc searchBloc;
  final String hintText;


  const SpqSearchBar({Key? key, required this.searchBloc, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return SizedBox(
      height: deviceSize.height * 0.1,
      width: deviceSize.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: TextField(
          onChanged: (value) => searchBloc.add(StartSearch(username: value)),
          decoration: InputDecoration(
            filled: true,
            prefixIcon: const Icon(Icons.search, color: spqDarkGreyTranslucent),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
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
