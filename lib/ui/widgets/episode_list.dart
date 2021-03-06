import 'package:flutter/material.dart';
import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/ui/pages/anime_viewer.dart';
import 'package:fmanime/ui/pages/manga_reader.dart';
import 'package:fmanime/utils/content_type.dart' as contype;

class EpisodeList extends StatelessWidget {
  const EpisodeList(
      {Key? key,
      required this.entryInfo,
      required this.contentType,
      required this.updatedEpisodeIndex})
      : super(key: key);

  final contype.ContentType contentType;
  final EntryInfo entryInfo;
  final Function updatedEpisodeIndex;

  @override
  Widget build(BuildContext context) {
    if (entryInfo.episodes.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return listTileItem(index, context);
          },
          childCount: entryInfo.episodes.length,
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

  ListTile listTileItem(int index, BuildContext context) {
    bool isRead = entryInfo.episodes[index].read;

    return ListTile(
      title: episodeName(index, isRead),
      trailing: PopupMenuButton(
        onSelected: (value) {
          updatedEpisodeIndex(index, value);
        },
        itemBuilder: (context) => [
          PopupMenuItem(
              value: !isRead,
              child: Text(isRead ? 'Mark as Unread' : 'Mark as Read')),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => contentType == contype.ContentType.anime
                ? AnimeViewer(episode: entryInfo.episodes[index])
                : MangaReader(
                    entryInfo: entryInfo,
                    epIndex: index,
                    updatedEpisodeIndex: updatedEpisodeIndex,
                  ),
          ),
        );
      },
    );
  }

  Text episodeName(int index, bool isRead) {
    if (isRead) {
      return Text(
        entryInfo.episodes[index].name,
        style: const TextStyle(color: Colors.grey),
      );
    } else {
      return Text(entryInfo.episodes[index].name);
    }
  }
}
