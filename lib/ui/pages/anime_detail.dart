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
  AnimeInfo? info = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDescription();
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
                widget.info.coverImage!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Expanded(child: Text(widget.info.name!)),
            ],
          ),
          Text(info!.description ?? "Loading..."),
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

  Future<AnimeInfo?> getDescription() async {
    await GogoanimeParser().getDetailsData(widget.info).then((value) {
      final newData = value;

      if (newData != null) {
        info = newData;
      }

      return newData;
    });
  }

  // @override
  // Future<void> initState() {
  //   super.initState();

  //   await GogoanimeParser().getDetailsData(widget.info).then((value) {
  //     final newData = value;

  //     if (newData != null) {
  //       info = newData;
  //     }
  //   });
  // }
}
