import 'package:flutter/material.dart';
import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/services/manga_parsers/mangasee_parser.dart';
import 'package:photo_view/photo_view.dart';

class MangaReader extends StatefulWidget {
  const MangaReader({Key? key, required this.episode}) : super(key: key);

  final Episode episode;

  @override
  State<MangaReader> createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader> {
  int length = 0;
  int currentPage = 1;
  late List<dynamic> pages;
  bool appBarVisible = true;
  bool chapterAndPageVisible = true;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    fetchPages();
  }

  void fetchPages() async {
    var newEpisode = await MangaSeeParser().getViewerInfo(widget.episode);

    List<dynamic> newPages = newEpisode.servers;

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
    return Center(
        child: PageView.builder(
      // store this controller in a State to save the carousel scroll position
      controller: PageController(viewportFraction: 1, initialPage: 1),
      onPageChanged: (value) => setCurrentPage(value),

      itemCount: length + 2,
      itemBuilder: (BuildContext context, int itemIndex) {
        return buildCarouselItem(context, itemIndex);
      },
    ));
  }

  Widget buildCarouselItem(BuildContext context, int itemIndex) {
    if (itemIndex == 0) {
      // Go to previous chapter page
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () => print('Go to previous chapter'), // TODO
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.arrow_back, size: 25),
                    VerticalDivider(
                      width: 10,
                    ),
                    Text(
                      "Previous Chapter",
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ])),
        ],
      );
    } else if (itemIndex == length + 1) {
      // Go to next chapter page
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () => print('Go to next chapter'), // TODO
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Next Chapter",
                      style: TextStyle(fontSize: 17.0),
                    ),
                    VerticalDivider(
                      width: 10,
                    ),
                    Icon(Icons.arrow_forward, size: 25),
                  ]))
        ],
      );
    } else {
      // Manga Page
      return Padding(
          padding: const EdgeInsets.all(1),
          child: PhotoView(
            minScale: PhotoViewComputedScale.contained * 1,
            maxScale: PhotoViewComputedScale.contained * 2.5,
            imageProvider: NetworkImage(pages[itemIndex - 1]),
          ));
    }
  }

  void setCurrentPage(int page) {
    if (page == 0 || page == length + 1) {
      if (page == length + 1) {
        // TODO Set current chapter as read
      }
      setState(() {
        chapterAndPageVisible = false;
      });
    } else {
      setState(() {
        currentPage = page;
        chapterAndPageVisible = true;
      });
    }
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
      title:
          chapterAndPageVisible ? Text('Chapter ${widget.episode.name}') : null,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      centerTitle: true,
      primary: true,
      actions: chapterAndPageVisible ? [appBarPadding] : null,
    );
  }
}
