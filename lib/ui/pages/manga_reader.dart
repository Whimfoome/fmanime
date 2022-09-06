import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/services/manga_parsers/mangasee_parser.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';

class MangaReader extends StatefulWidget {
  const MangaReader(
      {Key? key,
      required this.entryInfo,
      required this.epIndex,
      required this.updatedEpisodeIndex})
      : super(key: key);

  final int epIndex;
  final EntryInfo entryInfo;
  final Function updatedEpisodeIndex;

  @override
  State<MangaReader> createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader> {
  late Episode episode;
  int length = 0;
  int currentPage = 1;
  late List<dynamic> pages;
  bool appBarVisible = false;
  bool chapterAndPageVisible = true;
  bool loading = true;
  List<NetworkImage> images = [];

  @override
  void initState() {
    super.initState();

    episode = widget.entryInfo.episodes[widget.epIndex];

    fetchPages();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    super.dispose();
  }

  void fetchPages() async {
    var newEpisode =
        await MangaSeeParser().getViewerInfo(episode, widget.entryInfo);

    List<dynamic> newPages = newEpisode.servers;

    for (var page in newPages) {
      images.add(NetworkImage(page));
    }

    images = images.reversed.toList();

    setState(() {
      pages = newPages;
      length = newPages.length;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: appBarVisible ? buildAppBar(context) : null,
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            heightFactor: 0.0,
            child: Text(
              '$currentPage / $length',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => setState(() {
          appBarVisible = !appBarVisible;
        }),
        child: Column(
          children: [
            Expanded(
              child: loading ? buildLoading(context) : buildCarousel(context),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCarousel(BuildContext context) {
    return InteractiveviewerGallery(
      sources: images,
      initIndex: images.length - 1,
      itemBuilder: ((context, index, _) {
        return Center(
            child: Image(
          image: images[index],
          fit: BoxFit.contain,
        ));
      }),
      onPageChanged: (value) {
        setCurrentPage(images.length - value);
        cacheNextImage(value);
      },
    );
  }

  Future cacheNextImage(int index) async {
    if (index > 0) {
      precacheImage(images[index - 1], context);
    }
  }

  void setCurrentPage(int page) {
    if (page == length) {
      widget.updatedEpisodeIndex(widget.epIndex, true);
    }

    setState(() {
      currentPage = page;
      chapterAndPageVisible = true;
    });
  }

  Widget buildLoading(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'Loading...',
          style: TextStyle(color: Colors.white),
        )
      ],
    ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: chapterAndPageVisible ? Text(episode.name) : null,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      centerTitle: true,
      primary: true,
    );
  }
}
