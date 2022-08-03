import 'package:flutter/material.dart';
import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/services/manga_parsers/mangasee_parser.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
  bool appBarVisible = true;
  bool chapterAndPageVisible = true;
  bool loading = true;
  List<NetworkImage> images = [];

  @override
  void initState() {
    super.initState();

    episode = widget.entryInfo.episodes[widget.epIndex];

    fetchPages();
  }

  void fetchPages() async {
    var newEpisode =
        await MangaSeeParser().getViewerInfo(episode, widget.entryInfo);

    List<dynamic> newPages = newEpisode.servers;

    for (var page in newPages) {
      images.add(NetworkImage(page));
    }

    setState(() {
      pages = newPages;
      length = newPages.length;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: appBarVisible ? buildAppBar(context) : null,
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
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      reverse: true,
      itemCount: length,
      builder: (context, index) {
        cacheNextImage(index);

        return PhotoViewGalleryPageOptions(
          imageProvider: images[index],
          initialScale: PhotoViewComputedScale.contained * 1.0,
          minScale: PhotoViewComputedScale.contained * 1.0,
          maxScale: PhotoViewComputedScale.covered * 1.5,
        );
      },
      onPageChanged: (index) => setCurrentPage(index + 1),
    );
  }

  Future cacheNextImage(int index) async {
    if (index < images.length - 1) {
      precacheImage(images[index + 1], context);
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
    var appBarPadding = Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
              text: TextSpan(
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            children: [
              TextSpan(
                  text: '$currentPage',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  )),
              TextSpan(text: ' / $length'),
            ],
          ))
        ],
      ),
    );

    return AppBar(
      title: chapterAndPageVisible ? Text(episode.name) : null,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      centerTitle: true,
      primary: true,
      actions: chapterAndPageVisible ? [appBarPadding] : null,
    );
  }
}
