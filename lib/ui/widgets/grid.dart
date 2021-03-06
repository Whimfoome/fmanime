import 'package:flutter/material.dart';
import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/services/base_parser.dart';
import 'package:fmanime/ui/pages/detail.dart';

class GridLibrary extends StatefulWidget {
  const GridLibrary(
      {Key? key, required this.urlQuery, required this.gridParser})
      : super(key: key);
  final BaseParser gridParser;
  final String? urlQuery;

  @override
  State<GridLibrary> createState() => _GridLibraryState();
}

class _GridLibraryState extends State<GridLibrary> {
  final ScrollController _scrollController = ScrollController();
  List<EntryInfo> items = [];
  bool loading = false, allLoaded = false;

  int page = 1;

  @override
  void initState() {
    super.initState();

    fetchData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        page++;

        fetchData();
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

  CustomScrollView buildGrid() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = items[index];

              return buildGridTile(item);
            },
            childCount: items.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
        ),
      ],
    );
  }

  Widget buildGridTile(EntryInfo item) {
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
              builder: (_) => DetailPage(
                info: item,
                parser: widget.gridParser,
                contentType: widget.gridParser.contentType,
              ),
            ),
          );
        },
      ),
    );
  }

  fetchData() {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });

    widget.gridParser.getGridData(widget.urlQuery!, page).then((value) {
      final newData = value;

      if (newData.isNotEmpty) {
        items.addAll(newData);
      }

      setState(() {
        loading = false;
        allLoaded = newData.isEmpty;
      });
    });
  }
}
