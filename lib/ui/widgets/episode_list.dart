import 'package:flutter/material.dart';
import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/ui/pages/anime_viewer.dart';
import 'package:fmanime/ui/pages/manga_reader.dart';
import 'package:fmanime/utils/content_type.dart' as contype;

class EpisodeList extends StatelessWidget {
  const EpisodeList(
      {Key? key, required this.entryInfo, required this.contentType})
      : super(key: key);

  final contype.ContentType contentType;
  final EntryInfo entryInfo;

  @override
  Widget build(BuildContext context) {
    if (entryInfo.episodes.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ListTile(
              title: episodeName(index),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => contentType == contype.ContentType.anime
                        ? AnimeViewer(episode: entryInfo.episodes[index])
                        : MangaReader(
                            episode: entryInfo.episodes[index],
                            entryInfo: entryInfo,
                          ),
                  ),
                );
              },
            );
          },
        ),
      );
    } else {
      return const SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Text episodeName(int index) {
    final contentName =
        contentType == contype.ContentType.anime ? 'Episode' : '';

    return Text('$contentName ${entryInfo.episodes[index].name}');
  }
}
