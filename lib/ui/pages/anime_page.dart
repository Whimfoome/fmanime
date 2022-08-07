import 'package:flutter/material.dart';
import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/ui/pages/discover.dart';
import 'package:fmanime/utils/boxes.dart';
import 'package:fmanime/utils/content_type.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AnimePage extends StatefulWidget {
  const AnimePage({Key? key}) : super(key: key);

  @override
  State<AnimePage> createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  @override
  void dispose() {
    Hive.box('animeEntries').close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anime')),
      body: ValueListenableBuilder<Box<EntryInfo>>(
        valueListenable: Boxes.getAnimeEntries().listenable(),
        builder: (context, value, child) {
          final entry = value.values.toList().cast<EntryInfo>();

          if (entry.isNotEmpty) {
            return Text(entry[0].name!);
          }
          return Text('nothing here');
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'discover_anime_btn',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const Discover(
                contentType: ContentType.anime,
              ),
            ),
          );
        },
        child: const Icon(Icons.explore),
      ),
    );
  }
}
