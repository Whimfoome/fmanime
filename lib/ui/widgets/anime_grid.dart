import 'package:flutter/material.dart';
import 'package:fmanime/models/anime_info.dart';
import 'package:fmanime/services/parser/basic_parser.dart';
import 'package:fmanime/ui/widgets/loading_switcher.dart';
import 'package:fmanime/ui/widgets/anime_card.dart';
import 'dart:math';
import 'package:fmanime/utils/constants.dart';

class GridLibrary extends StatefulWidget {
  const GridLibrary({Key? key, required this.url}) : super(key: key);

  final String? url;

  @override
  State<GridLibrary> createState() => _GridLibraryState();
}

class _GridLibraryState extends State<GridLibrary> {
  bool loading = true;
  List<AnimeInfo> list = [];
  List<AnimeCard> cards = [];

  int page = 1;
  bool canLoadMore = true;

  late ScrollController controller;
  bool showIndicator = false;

  // @override
  // void initState() {
  //   super.initState();
  //   loadData();
  //   controller = ScrollController()
  //     ..addListener(() {
  //       loadMoreData();
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPopularAnime(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
              crossAxisCount: 2,
              children: cards,
            );
          } else {
            return const Text("Loading...");
          }
        }));
  }

  Future<List<AnimeCard>> getPopularAnime() async {
    bool isSearch = widget.url?.startsWith("/search") ?? false;

    final link =
        "$defaultDomain${widget.url!}${isSearch ? '&' : '?'}page=$page";

    final parser = AnimeParser(link);
    parser.downloadHTML().then((body) {
      final moreData = parser.parseHTML(body);

      setState(() {
        loading = false;
        list = moreData;
      });
    });

    for (var info in list) {
      cards.add(AnimeCard(info: info));
    }

    return cards;
  }

  // /// Increase page and load more data
  // void loadData({bool refresh = false}) {
  //   // Reset page to 1, start from 1 not ZERO
  //   if (refresh) page = 1;

  //   setState(() {
  //     canLoadMore = false;
  //     showIndicator = true;
  //   });

  //   bool isSearch = widget.url?.startsWith('/search') ?? false;
  //   // For search, you need to use &
  //   final link =
  //       '$defaultDomain${widget.url!}${isSearch ? '&' : '?'}page=$page';

  //   final parser = AnimeParser(link);
  //   parser.downloadHTML().then((body) {
  //     final moreData = parser.parseHTML(body);

  //     // Append more data
  //     setState(() {
  //       loading = false;
  //       // If refresh, just reset the list to more data
  //       if (refresh) {
  //         list = moreData;
  //       } else {
  //         list += moreData;
  //       }
  //       // If more data is emptp, we have reached the end
  //       canLoadMore = moreData.isNotEmpty;
  //       showIndicator = false;
  //     });
  //   });
  // }

  /// Load more data if the grid is close to the end
  // void loadMoreData() {
  //   if (controller.position.extentAfter < 10 && canLoadMore) {
  //     page += 1;
  //     loadData();
  //   }
  // }

  // Widget renderBody() {
  //   if (loading) {
  //     // While loading, show a loading indicator and a normal app bar
  //     return Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   } else {
  //     // After parsing is done, show the anime grid
  //     return SafeArea(
  //       child: Stack(
  //         children: <Widget>[
  //           RefreshIndicator(
  //             onRefresh: () async {
  //               this.loadData(refresh: true);
  //             },
  //             child: Scrollbar(
  //               child: LayoutBuilder(
  //                 builder: (context, constraints) {
  //                   final count =
  //                       max(min((constraints.maxWidth / 200).floor(), 5), 2);
  //                   final imageWidth = constraints.maxWidth / count.toDouble();
  //                   // Calculat ratio, adjust the offset (70)
  //                   final ratio = imageWidth / (imageWidth / 0.7 + 70);
  //                   final length = this.list.length;

  //                   return length > 0
  //                       ? GridView.builder(
  //                           controller: this.controller,
  //                           gridDelegate:
  //                               SliverGridDelegateWithFixedCrossAxisCount(
  //                             crossAxisCount: count,
  //                             childAspectRatio: ratio,
  //                           ),
  //                           itemBuilder: (BuildContext context, int index) {
  //                             final info = this.list[index];
  //                             return Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: InkWell(
  //                                 borderRadius: BorderRadius.circular(12),
  //                                 child: AnimeCard(info: info),
  //                               ),
  //                             );
  //                           },
  //                           itemCount: length,
  //                         )
  //                       : Center(
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Text(
  //                                 'Nothing was found. Try loading it again.\nDouble check the website link in Settings as well.',
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                               IconButton(
  //                                 onPressed: () {
  //                                   setState(() {
  //                                     loading = true;
  //                                   });
  //                                   loadData(refresh: true);
  //                                 },
  //                                 icon: Icon(Icons.refresh),
  //                               ),
  //                             ],
  //                           ),
  //                         );
  //                 },
  //               ),
  //             ),
  //           ),
  //           showIndicator
  //               ? Align(
  //                   alignment: Alignment.bottomCenter,
  //                   child: LinearProgressIndicator(),
  //                 )
  //               : Container(),
  //         ],
  //       ),
  //     );
  //   }
  // }
}
/////////////////////////////////////////////////////////////////////////
