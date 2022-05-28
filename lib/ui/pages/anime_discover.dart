import "package:flutter/material.dart";
import "package:fmanime/ui/widgets/anime_grid.dart";
import "package:fmanime/ui/widgets/anime_search.dart";

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  String search = '';
  String query = '';

  @override
  Widget build(BuildContext context) {
    // return const GridLibrary(
    //   url: "/popular.html",
    // );
    //return const GridLibrarySearch();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration.collapsed(hintText: "Search"),
          autocorrect: false,
          onChanged: (str) {
            search = str;
            setState(() {
              query = '';
            });
          },
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              query = search; //.split(' ').join('%20');
            });
          },
        ),
      ),
      body: buildGrid(),
    );
  }

  Widget buildGrid() {
    if (query.length > 3) {
      return GridLibrary(url: "/search.html?keyword=$query");
    } else {
      return Container();
    }
  }
}
