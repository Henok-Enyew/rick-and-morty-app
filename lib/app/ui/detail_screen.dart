import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/app/utils/queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty/app/widgets/character_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    // accept the id
    // Query detial with the id
    // show the detal info
    return Scaffold(
      appBar: AppBar(),
      body: Query(
        builder: (result, {fetchMore, refetch}) {
          if (result.data != null) {
            List<Map<String, String>> episodes =
                (result.data!["character"]["episode"] as List)
                    .map((e) => {
                          "name": e["name"]?.toString() ?? "None",
                          "episode": e["episode"]?.toString() ?? "None",
                        })
                    .toList();

            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: MediaQuery.of(context).size.width * .90,
                height: MediaQuery.of(context).size.height - 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xF451D928),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(6)),
                      child: CachedNetworkImage(
                        imageUrl: result.data!["character"]["image"],
                        placeholder: (context, url) => Container(
                          color: Colors.grey,
                          height: 300,
                          width: double.infinity,
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 300,
                          width: double.infinity,
                          color: Colors.red,
                        ),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      child: Column(
                        children: [
                          Text(
                            result.data!["character"]["name"].toString(),
                            style: const TextStyle(
                              fontSize: 32,
                            ),
                          ),
                          Wrap(spacing: 6, runSpacing: 6, children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .35,
                              child: IconAndLabel(
                                label: result.data!["character"]["gender"],
                                icon: result.data!["character"]["gender"] ==
                                        'Male'
                                    ? Icons.male_outlined
                                    : Icons.female,
                                size: 24,
                                flexible: true,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .35,
                              child: IconAndLabel(
                                label: result.data!["character"]["species"],
                                icon: Icons.psychology_outlined,
                                size: 24,
                                flexible: true,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .35,
                              child: Row(children: [
                                Icon(
                                  Icons.circle,
                                  size: 24,
                                  color: result.data!["character"]["status"]
                                              .toLowerCase() ==
                                          "alive"
                                      ? Colors.green
                                      : result.data!["character"]["species"]
                                                  .toLowerCase() ==
                                              "unknown"
                                          ? Colors.grey
                                          : Colors.red,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  result.data!["character"]["status"]
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(221, 37, 37, 37)),
                                ),
                              ]),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .40,
                              child: IconAndLabel(
                                label: result.data!["character"]["origin"]
                                    ["name"],
                                icon: Icons.home_outlined,
                                size: 24,
                                flexible: true,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .45,
                              child: IconAndLabel(
                                label: result.data!["character"]["location"]
                                    ["name"],
                                icon: Icons.place_outlined,
                                size: 24,
                                flexible: true,
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26),
                      child: IconAndLabel(
                        label: "Episodes participated: ",
                        icon: Icons.movie_outlined,
                        size: 24,
                        flexible: true,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 4, 20, 0),
                        child: ListView.builder(
                          itemCount: episodes.length,
                          itemBuilder: (context, index) {
                            final episode = episodes[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              width: MediaQuery.of(context).size.width * .45,
                              height: 64,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                title: Text(
                                  episode["name"]!,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                subtitle: Text(episode["episode"]!),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (result.isLoading) {
            return const SpinKitSpinningLines(
              color: Color.fromARGB(199, 81, 217, 40),
              size: 150.0,
            );
          } else if (result.data == null) {
            return const Center(
                child: Text(
              "Connection failed! 🌐",
              style: TextStyle(fontSize: 24),
            ));
          }
          return const Center(
              child: Text(
            "Something went wrong 😪",
            style: TextStyle(fontSize: 24),
          ));
        },
        options: QueryOptions(
            fetchPolicy: FetchPolicy.cacheAndNetwork,
            document: getCharacterDetail(),
            variables: {"id": int.parse(id)}),
      ),
    );
  }
}
