import 'package:flutter/material.dart';
import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/ui/widgets/grid.dart';
import 'package:fmanime/utils/boxes.dart';
import 'package:fmanime/utils/content_type.dart' as contype;
import 'package:hive_flutter/hive_flutter.dart';

class MangaPage extends StatefulWidget {
  const MangaPage({Key? key}) : super(key: key);

  @override
  State<MangaPage> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  @override
  void dispose() {
    Hive.box('mangaEntries').close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manga')),
      body: ValueListenableBuilder<Box<EntryInfo>>(
        valueListenable: Boxes.getMangaEntries().listenable(),
        builder: (context, value, child) {
          final entries =
              value.values.where((element) => element.favorite).toList();

          if (entries.isNotEmpty) {
            return GridLibrary(
              urlQuery: '',
              gridParser: contype.chooseProvider(contype.ContentType.manga),
              customEntries: entries,
              key: UniqueKey(),
            );
          }
          return const Center(child: Text('Empty...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'discover_manga_btn',
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/discover',
            arguments: contype.ContentType.manga,
          );
        },
        child: const Icon(Icons.explore),
      ),
    );
  }
}
