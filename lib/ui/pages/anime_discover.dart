import "package:flutter/material.dart";
import "package:fmanime/ui/widgets/anime_grid.dart";

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final _searchController = TextEditingController();
  String search = '';
  String query = '';
  bool sendKey = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
              hintText: "Search",
              border: InputBorder.none,
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  sendKey = true;

                  setState(() {
                    search = '';
                    query = '';
                  });
                },
                icon: const Icon(Icons.clear),
              )),
          autocorrect: false,
          onChanged: (str) {
            setState(() {
              search = str;
              query = '';
            });
          },
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              query = search;
            });
          },
        ),
      ),
      body: buildGrid(),
    );
  }

  Widget buildGrid() {
    if (search.isEmpty) {
      if (sendKey) {
        sendKey = false;
        return GridLibrary(url: "popular.html", key: UniqueKey());
      } else {
        return const GridLibrary(url: "popular.html");
      }
    }

    if (query.length > 3) {
      return GridLibrary(url: "/search.html?keyword=$query");
    } else {
      return Container();
    }
  }
}
