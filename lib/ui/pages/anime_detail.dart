import "package:flutter/material.dart";
import 'package:fmanime/models/anime_info.dart';

class AnimeDetailPage extends StatefulWidget {
  const AnimeDetailPage({Key? key, required this.info}) : super(key: key);

  final AnimeInfo info;

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.network(
                widget.info.coverImage!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Expanded(child: Text(widget.info.name!)),
            ],
          ),
          Text("Description"),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
