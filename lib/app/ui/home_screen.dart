import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty/app/model/character.dart';
import 'package:rick_and_morty/app/utils/queries.dart';
import 'package:rick_and_morty/app/widgets/character_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedGender = 'All';
  final List<Uri> links = [
    Uri.parse('https://t.me/Enoch90s'),
    Uri.parse('https://github.com/Henok-Enyew'),
    Uri.parse('https://www.linkedin.com/in/henok-enyew'),
    Uri.parse('https://www.instagram.com/enoch90s/'),
  ];

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double gap = MediaQuery.of(context).size.height * .43;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121C0E),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Image.asset(
          "assets/logo.png",
          height: 42,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: SizedBox(
              height: 35,
              width: 150,
              child: TextField(
                style: const TextStyle(
                  color: Color(0xf441ae20),
                ),
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                maxLength: 35,
                minLines: 1,
                maxLines: 1,
                autofocus: false,
                decoration: const InputDecoration(
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                  hintText: 'Rick Sanchez',
                  labelText: "Search character",
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon: Icon(Icons.search, size: 25),
                  suffixIconColor: Colors.grey,
                  border: OutlineInputBorder(),
                  counterText: "",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF121C0E), // Background color
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 80, 10, 30),
                child: SizedBox(
                  child: Text(
                    'Filters',
                    style: TextStyle(
                      color: Color(0xf441ae20),
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                    });
                  },
                  items: <String>['All', 'Alive', 'Dead', 'Unknown']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Color(0xf441ae20),
                        ),
                      ),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue!;
                    });
                  },
                  items: <String>['All', 'Male', 'Female', 'Unknown']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Color(0xf441ae20),
                        ),
                      ),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, gap, 16, 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset(
                            'assets/github.png',
                            width: 36,
                            height: 36,
                          ),
                          onPressed: () async {
                            await launchUrl(links[1]);
                          },
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/linkedin.png',
                            width: 36,
                            height: 36,
                          ),
                          onPressed: () async {
                            await launchUrl(links[2]);
                          },
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/telegram.png',
                            width: 36,
                            height: 36,
                          ),
                          onPressed: () async {
                            await launchUrl(links[0]);
                          },
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/instagram.png',
                            width: 36,
                            height: 36,
                          ),
                          onPressed: () async {
                            await launchUrl(links[3]);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                      // height: MediaQuery.of(context).size.height * .43,
                    ),
                    const Text(
                      'Made with 💚 by Henok Enyew © 2024',
                      style: TextStyle(
                        color: Color(0xf441ae20),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Query(
            builder: (result, {fetchMore, refetch}) {
              if (result.data != null) {
                int? nextPage = 1;
                List<Character> characters =
                    (result.data!["characters"]["results"] as List)
                        .map((e) => Character.fromMap(e))
                        .toList();
                List<Character> filteredCharacters = characters
                    .where((character) =>
                        character.name
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) &&
                        (_selectedStatus == 'All' ||
                            character.status.toLowerCase() ==
                                _selectedStatus.toLowerCase()) &&
                        (_selectedGender == 'All' ||
                            character.gender.toLowerCase() ==
                                _selectedGender.toLowerCase()))
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
                            children: filteredCharacters
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
                document: getAllCharachters(),
                variables: const {"page": 1}),
          ),
        ),
      ),
    );
  }
}
