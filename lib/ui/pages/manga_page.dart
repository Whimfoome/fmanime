import 'package:flutter/material.dart';
import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/ui/pages/discover.dart';
import 'package:fmanime/utils/boxes.dart';
import 'package:fmanime/utils/content_type.dart';
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
          final entry = value.values.toList().cast<EntryInfo>();

          if (entry.isNotEmpty) {
            return Text(entry[0].name!);
          }
          return Text('nothing here');
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'discover_manga_btn',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const Discover(
                contentType: ContentType.manga,
              ),
            ),
          );
        },
        child: const Icon(Icons.explore),
      ),
    );
  }
}
