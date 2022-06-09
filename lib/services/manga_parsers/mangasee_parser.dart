import 'dart:convert';

import 'package:fmanime/models/entry_info.dart';
import 'package:html/dom.dart' as dom;
import 'package:fmanime/services/base_parser.dart';
import 'package:fmanime/services/html_helper.dart';
import 'package:fmanime/models/content_type.dart' as contype;
import 'package:web_scraper/web_scraper.dart';

class MangaSeeParser extends BaseParser {
  MangaSeeParser()
      : super(
          domain: 'https://mangasee123.com',
          queryPopular: '/search/?sort=v&desc=true',
          querySearch: '/search/?name=',
          contentType: contype.ContentType.manga,
        );

  List<EntryInfo> allManga = [];

  @override
  Future<List<EntryInfo>?> getGridData(String url, int page) async {
    if (allManga.isEmpty) {
      allManga = await fetchAllManga();
    }

    bool isSearch = url.startsWith(querySearch);

    if (isSearch) {
      final query = url.split(querySearch)[1];
      return allManga
          .where((manga) =>
              manga.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return allManga;
  }

  Future<List<EntryInfo>> fetchAllManga() async {
    final webScraper = WebScraper(domain);
    List<EntryInfo> list = [];

    if (await webScraper.loadWebPage(queryPopular)) {
      // Get the JSON list of manga
      Map<String, dynamic> elements =
          webScraper.getScriptVariables(['vm.Directory']);
      String scrapedString =
          elements['vm.Directory'][0].replaceAll('vm.Directory = ', '');
      String response = scrapedString.substring(0, scrapedString.length - 1);
      List<dynamic> jsonResponse = jsonDecode(response);

      for (var mangaObject in jsonResponse) {
        var entryInfo = EntryInfo();

        entryInfo.name = mangaObject['s'];
        entryInfo.link = mangaObject['i'];
        entryInfo.coverImage =
            'https://cover.nep.li/cover/${mangaObject['i']}.jpg';

        list.add(entryInfo);
      }
    }

    return list;
  }

  @override
  Future<EntryInfo?> getDetailsData(EntryInfo info) {
    final link = domain + (info.link ?? '');

    final parsedData = downloadHTML(link).then((body) {
      EntryInfo newInfo = info;

      newInfo.description = body
          ?.getElementsByClassName('anime_info_body_bg')
          .first
          .getElementsByClassName('type')[1]
          .text
          .trim()
          .split('Plot Summary: ')
          .last;

      newInfo.id = body
          ?.getElementsByClassName('anime_info_episodes_next')
          .first
          .getElementsByTagName('input')
          .first
          .attributes
          .values
          .elementAt(1);

      return newInfo;
    });

    return parsedData;
  }

  @override
  Future<EntryInfo?> getContentData(EntryInfo info) {
    List<Episode> fetchedEpisodes = [];
    final link =
        '${domain}load-list-episode?ep_start=0&ep_end=5000&id=${info.id}';

    return downloadHTML(link).then((body) {
      final list =
          body?.getElementById('episode_related')?.getElementsByTagName('li');

      if (list != null) {
        for (var element in list) {
          final href = element
              .getElementsByTagName('a')
              .first
              .attributes
              .values
              .first
              .trim();

          final epNumber = element
              .getElementsByTagName('a')
              .first
              .getElementsByClassName('name')
              .first
              .text
              .trim()
              .split('EP ')[1];

          final episode = Episode(link: href, name: 'Episode $epNumber');
          fetchedEpisodes.add(episode);
        }
      } else {
        fetchedEpisodes = [];
      }

      info.episodes = fetchedEpisodes.reversed.toList();

      return info;
    });
  }

  @override
  Future<Episode> getViewerInfo(Episode episode) async {
    final epLink = episode.link;
    final link = domain + epLink;

    return downloadHTML(link).then((body) {
      final div = body?.getElementsByClassName('anime_video_body').first;

      final server = div?.getElementsByClassName('anime_muti_link').first;
      final serverList = server?.nodes[1];
      if (serverList != null) {
        for (var element in serverList.nodes) {
          if (element.runtimeType == dom.Element) {
            final elNode = element.nodes[1];

            var link1 = elNode.attributes['data-video'] ?? '';
            if (!link1.startsWith('http')) {
              link1 = 'https://$link1';
            }

            final title1 = elNode.nodes[0].text ?? '';
            String? theTitle;
            if (title1.trim().isEmpty) {
              theTitle = elNode.nodes[2].text?.toUpperCase();
            } else {
              theTitle = title1.toUpperCase();
            }

            episode.videoServers
                .add(VideoServer(title: theTitle!, link: link1));
          }
        }
      }

      return episode;
    });
  }
}
