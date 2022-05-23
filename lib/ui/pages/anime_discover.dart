import "package:flutter/material.dart";
import "package:fmanime/ui/widgets/anime_grid.dart";

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  Widget build(BuildContext context) {
    return const GridLibrary(
      url: "/popular.html",
    );
  }
}
