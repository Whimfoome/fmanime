import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
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
      body: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        children: [
          buildHeader(),
          ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            children: [
              ListTile(title: Text("Episode 1")),
              ListTile(title: Text("Episode 2")),
              ListTile(title: Text("Episode 3")),
              ListTile(title: Text("Episode 4")),
              ListTile(title: Text("Episode 5")),
              ListTile(title: Text("Episode 6")),
              ListTile(title: Text("Episode 7")),
              ListTile(title: Text("Episode 8")),
              ListTile(title: Text("Episode 9")),
              ListTile(title: Text("Episode 10")),
              ListTile(title: Text("Episode 11")),
              ListTile(title: Text("Episode 12")),
              ListTile(title: Text("Episode 13")),
              ListTile(title: Text("Episode 14")),
              ListTile(title: Text("Episode 15")),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      // Background Image
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(info.coverImage!),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.1),
            BlendMode.modulate,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Image Card
              Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 0.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      info.coverImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Title
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    info.name!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Description
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: buildDescription(info.description!),
          ),
        ],
      ),
    );
  }

  Widget buildDescription(String description) {
    if (description.isNotEmpty) {
      return Text(description);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
