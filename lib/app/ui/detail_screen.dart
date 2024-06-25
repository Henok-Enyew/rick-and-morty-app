import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rick_and_morty/app/utils/query.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    // accept the id
    // Query detial with the id
    // show the detal info
    return Scaffold(
      appBar: AppBar(
        title: Text(id),
      ),
      body: Query(
        builder: (result, {fetchMore, refetch}) {
          if (result.data != null) {
            return Text(result.data!["character"]["name"].toString());
          } else if (result.isLoading) {
            return const Text("Loading");
          } else if (result.data == null) {
            return const Text("Data Not Found!");
          }
          return const Text("Something went wrong");
        },
        options: QueryOptions(
            fetchPolicy: FetchPolicy.cacheAndNetwork,
            document: getCharacterDetail(),
            variables: {"id": int.parse(id)}),
      ),
    );
  }
}
