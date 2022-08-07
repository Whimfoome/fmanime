import 'package:flutter/material.dart';
import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/services/base_parser.dart';
import 'package:fmanime/ui/widgets/episode_list.dart';
import 'package:fmanime/utils/boxes.dart';
import 'package:fmanime/utils/content_type.dart' as contype;
import 'package:hive/hive.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(
      {Key? key,
      required this.info,
      required this.parser,
      required this.contentType})
      : super(key: key);

  final BaseParser parser;
  final EntryInfo info;
  final contype.ContentType contentType;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late EntryInfo info;

  @override
  void initState() {
    super.initState();

    final boxEntries = getBox();
    final foundEntry = boxEntries.get(widget.info.link!);

    if (foundEntry != null) {
      info = foundEntry;
    } else {
      info = widget.info;
      showDetails();
    }
  }

  Future showDetails() async {
    await widget.parser.getDetailsData(info).then((value) {
      if (value != null) {
        setState(() {
          info = value;
        });
      }
    });

    widget.parser.getContentData(info).then((value) {
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
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  info.favorite = !info.favorite;
                });

                final box = getBox();
                if (info.favorite) {
                  box.put(info.link, info);
                } else {
                  box.delete(info.link);
                }
              },
              icon: info.favorite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border)),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: buildHeader(),
          ),
          // -------------------- //
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: loadingText(),
              ),
            ),
          ),
          // -------------------- //
          const SliverToBoxAdapter(
            child: Divider(height: 1),
          ),
          // -------------------- //
          EpisodeList(
            entryInfo: info,
            contentType: widget.contentType,
            updatedEpisodeIndex: updatedEpisodeIndex,
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

  Widget loadingText() {
    final contentName = widget.contentType == contype.ContentType.anime
        ? 'episodes'
        : 'chapters';

    return Text(info.episodes.isNotEmpty
        ? '${info.episodes.length} $contentName'
        : 'Loading $contentName...');
  }

  void updatedEpisodeIndex(int index, bool value) {
    setState(() {
      info.episodes[index].read = value;
    });

    final box = getBox();
    box.put(info.link, info);
  }

  Box<EntryInfo> getBox() {
    return widget.contentType == contype.ContentType.anime
        ? Boxes.getAnimeEntries()
        : Boxes.getMangaEntries();
  }
}
