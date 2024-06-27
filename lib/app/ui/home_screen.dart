import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty/app/model/character.dart';
import 'package:rick_and_morty/app/utils/queries.dart';
import 'package:rick_and_morty/app/widgets/character_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logo.png",
          height: 42,
        ),
        // backgroundColor: const Color.fromARGB(25, 0, 0, 0),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: SizedBox(
              height: 30,
              width: 200,
              child: Expanded(
                child: TextField(
                  maxLength: 35,
                  minLines: 1,
                  maxLines: 1,
                  autofocus: false,
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.black12)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.black26)),
                    hintText: 'Character name..',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(),
                    counterText: "",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                  ),
                ),
              ),
            ),
          ),
        ],

        // Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 12),
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         const Expanded(
        //           child: TextField(
        //             decoration: InputDecoration(
        //               hintText: 'Search...',
        //               border: OutlineInputBorder(),
        //             ),
        //           ),
        //         ),
        //         const SizedBox(width: 8),
        //         IconButton(
        //           icon: const Icon(Icons.search),
        //           onPressed: () {},
        //         ),
        //       ],
        //     ),
        //   ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Query(
            builder: (result, {fetchMore, refetch}) {
              if (result.data != null) {
                int? nextPage = 1;
                List<Character> characters =
                    (result.data!["characters"]["results"] as List)
                        .map((e) => Character.fromMap(e))
                        .toList();

                nextPage = result.data!["characters"]["info"]["next"];

                return RefreshIndicator(
                  onRefresh: () async {
                    await refetch!();
                    nextPage = 1;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: characters
                                .map((e) => CharacterWidget(character: e))
                                .toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (nextPage != null)
                          ElevatedButton(
                              onPressed: () async {
                                FetchMoreOptions opts = FetchMoreOptions(
                                  variables: {'page': nextPage},
                                  updateQuery: (previousResultData,
                                      fetchMoreResultData) {
                                    final List<dynamic> repos = [
                                      ...previousResultData!["characters"]
                                          ["results"] as List<dynamic>,
                                      ...fetchMoreResultData!["characters"]
                                          ["results"] as List<dynamic>
                                    ];
                                    fetchMoreResultData["characters"]
                                        ["results"] = repos;
                                    return fetchMoreResultData;
                                  },
                                );
                                await fetchMore!(opts);
                              },
                              child: result.isLoading
                                  ? const CircularProgressIndicator.adaptive()
                                  : const Text("Load More"))
                      ],
                    ),
                  ),
                );
              }
              // We got data but it is null
              else if (result.data == null) {
                return const Text("Data Not Found!");
              }
              // We don't have data yet -> LOADING STATE
              else if (result.isLoading) {
                return const Center(
                  child: Text("Loading..."),
                );
              }
              // error state
              else {
                return const Center(
                  child: Center(child: Text("Something went wrong")),
                );
              }
            },
            options: QueryOptions(
                fetchPolicy: FetchPolicy.cacheAndNetwork,
                document: getAllCharachters(),
                variables: const {"page": 1}),
          ),
        ),
      ),
    );
  }
}
