import "package:flutter/material.dart";
import "package:fmanime/models/anime_info.dart";
import "package:fmanime/services/anime_parsers/gogoanime_parser.dart";
import "package:fmanime/ui/pages/anime_viewer.dart";

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

    showDetails();
  }

  Future showDetails() async {
    await GogoanimeParser().getDetailsData(info).then((value) {
      if (value != null) {
        setState(() {
          info = value;
        });
      }
    });

    GogoanimeParser().getEpisodesData(info).then((value) {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(info.episodes.isNotEmpty
                  ? "${info.episodes.length} episodes"
                  : "Loading episodes..."),
            ),
          ),
          const Divider(
            height: 1,
          ),
          buildEpisodes(),
        ],
      ),
    );
  }

  Widget buildEpisodes() {
    if (info.episodes.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: info.episodes.length,
        itemBuilder: ((context, index) {
          return ListTile(
            title: Text(info.episodes[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnimeViewer(episode: info.episodes[index]),
                ),
              );
            },
          );
        }),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
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
