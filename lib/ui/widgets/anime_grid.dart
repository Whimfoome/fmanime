import 'package:flutter/material.dart';
import 'package:fmanime/models/anime_info.dart';
import 'package:fmanime/services/parser/gogoanime_parser.dart';
import 'package:fmanime/ui/widgets/anime_card.dart';

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
    getPopularAnime();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        page++;
        getPopularAnime();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (items.isNotEmpty) {
        return ListView.separated(
            controller: _scrollController,
            itemBuilder: ((context, index) {
              return ListTile(
                title: Text(items[index].name!),
              );
            }),
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
              );
            },
            itemCount: items.length);
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

  getPopularAnime() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });

    await GogoanimeParser().fetchData(widget.url, page).then((value) {
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
