import 'package:flutter/material.dart';
import 'package:fmanime/models/anime_info.dart';
import 'package:fmanime/services/anime_parsers/gogoanime_parser.dart';
import 'package:fmanime/ui/pages/anime_detail.dart';

class GridLibrary extends StatefulWidget {
  const GridLibrary({Key? key, required this.url}) : super(key: key);

  final String? url;

  @override
  State<GridLibrary> createState() => _GridLibraryState();
}

class _GridLibraryState extends State<GridLibrary> {
  final ScrollController _scrollController = ScrollController();
  List<AnimeInfo> items = [];
  bool loading = false, allLoaded = false;

  int page = 1;

  @override
  void initState() {
    super.initState();
    getAnime();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        page++;
        getAnime();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (items.isNotEmpty) {
        return buildGrid();
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    }));
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  GridView buildGrid() {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(5),
      itemBuilder: ((context, index) {
        final item = items[index];

        return buildGridTile(item);
      }),
      itemCount: items.length,
    );
  }

  Widget buildGridTile(AnimeInfo item) {
    // Workaround for Ink bleeding through IndexedStack
    // (https://github.com/flutter/flutter/issues/59963)
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: GridTile(
          footer: Container(
            margin: const EdgeInsets.all(6),
            child: Text(
              item.name!,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                shadows: <Shadow>[
                  Shadow(
                    blurRadius: 12.0,
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 20.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              image: item.coverImage != null
                  ? DecorationImage(
                      image: NetworkImage(item.coverImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AnimeDetailPage(info: item),
            ),
          );
        },
      ),
    );
  }

  getAnime() {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });

    GogoanimeParser().getGridData(widget.url, page).then((value) {
      final newData = value;

      if (newData != null) {
        if (newData.isNotEmpty) {
          items.addAll(newData);
        }

        setState(() {
          loading = false;
          allLoaded = newData.isEmpty;
        });
      }
    });
  }
}
