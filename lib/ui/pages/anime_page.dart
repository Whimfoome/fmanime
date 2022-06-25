import 'package:flutter/material.dart';
import 'package:fmanime/ui/pages/discover.dart';
import 'package:fmanime/utils/content_type.dart';

class AnimePage extends StatefulWidget {
  const AnimePage({Key? key}) : super(key: key);

  @override
  State<AnimePage> createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anime')),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
