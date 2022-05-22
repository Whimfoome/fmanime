import "package:flutter/material.dart";
import "package:fmanime/models/anime_info.dart";
import "package:fmanime/services/parser/gogoanime_parser.dart";

class AnimeDetailPage extends StatefulWidget {
  const AnimeDetailPage({Key? key, required this.info}) : super(key: key);

  final AnimeInfo info;

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  late AnimeInfo info;

  @override
  void initState() {
    super.initState();

    info = widget.info;

    GogoanimeParser().getDetailsData(info).then((value) {
      if (value != null) {
        setState(() {
          info = value;
        });
      }
    });
  }

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
                info.coverImage!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Expanded(child: Text(info.name!)),
            ],
          ),
          Text(info.description!),
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
