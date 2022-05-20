import 'package:flutter/material.dart';
import 'package:fmanime/services/parser/basic_parser.dart';
import 'package:fmanime/utils/constants.dart';
import 'package:fmanime/ui/widgets/anime_grid.dart';

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const AnimeGrid(
              url: "/popular.html",
            );
          } else {
            return const Text("Loading...");
          }
        });
  }

  Future<bool> init() async {
    await DomainParser(defaultDomain).getNewDomain();
    return true;
  }
}
