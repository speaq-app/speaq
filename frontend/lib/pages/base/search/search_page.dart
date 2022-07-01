import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/blocs/search_bloc/search_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:frontend/widgets/speaq_search_bar_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchBloc _searchBloc = SearchBloc();
  List<CondensedUser> foundUsers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          leading: null,
          automaticallyImplyLeading: false,
          title: SpqSearchBar(
              searchBloc: _searchBloc,
              hintText: appLocale.hintTextSearchBarSearchPage
          ),
          preferredSize: deviceSize,
          centerTitle: true,
          actionList: [SpqSettingsIconButton(onPressed:() => Navigator.pushNamed(context, "privacySafetySettings"),)],
        ),

        // Selects the appropriate state and returns a [foundUsers] Listview.
        body: BlocConsumer<SearchBloc, SearchState>(
          bloc: _searchBloc,
          listener: (context, state) {

            if (state is ResultsReceived) {
              foundUsers = state.users;
            }
          },
          builder: (context, state) {
            if (state is SearchStarted) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: foundUsers.length,
                itemBuilder: (context, index) {
                  return FollowerTile(follower: foundUsers[index]);
                },
              );
            } else if (state is RequestSend) {
              return SpqLoadingWidget(deviceSize.width * 0.2);
            } else if (state is ResultsReceived) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: foundUsers.length,
                itemBuilder: (context, index) {
                  return FollowerTile(follower: foundUsers[index]);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Generates a search bar to search for different users.
  SizedBox generateSearchBar(Size deviceSize, AppLocalizations appLocale) {
    return SizedBox(
      height: deviceSize.height * 0.09,
      width: deviceSize.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: TextField(
          onChanged: (value) => _searchBloc.add(StartSearch(term: value)),
          decoration: InputDecoration(
            filled: true,
            prefixIcon: const Icon(Icons.search, color: spqDarkGreyTranslucent),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none
            ),
            hintStyle: const TextStyle(
              fontSize: 16,
              color: spqDarkGreyTranslucent,
            ),
            hintText: appLocale.hintTextSearchBarSearchPage,
          ),
        ),
      ),
    );
  }
}
