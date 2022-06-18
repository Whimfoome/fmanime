import 'package:flutter/material.dart';
import 'package:fmanime/ui/pages/discover.dart';
import 'package:fmanime/models/content_type.dart';

class MangaPage extends StatefulWidget {
  const MangaPage({Key? key}) : super(key: key);

  @override
  State<MangaPage> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manga')),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
