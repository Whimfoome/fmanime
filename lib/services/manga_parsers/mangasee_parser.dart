import 'dart:convert';

import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/services/base_parser.dart';
import 'package:fmanime/models/content_type.dart' as contype;

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
  Future<List<EntryInfo>> getGridData(String url, int page) async {
    if (page > 1) {
      return [];
    }

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
  Future<EntryInfo> getDetailsData(EntryInfo info) async {
    EntryInfo newInfo = info;
    newInfo.description = 'Placeholder description';

    return newInfo;
  }

  @override
  Future<EntryInfo?> getContentData(EntryInfo info) async {
    List<Episode> fetchedEpisodes = [];

    if (await webScraper.loadWebPage('/manga/${info.link}')) {
      // Get the JSON list of manga
      Map<String, dynamic> elements =
          webScraper.getScriptVariables(['vm.Chapters']);
      String scrapedString =
          elements['vm.Chapters'][0].replaceAll('vm.Chapters = ', '');
      String response = scrapedString.substring(0, scrapedString.length - 1);
      List<dynamic> jsonResponse = jsonDecode(response);

      // Create Chapter items and add them to the list
      for (var chapterObject in jsonResponse) {
        final chapNumber = processChapterNumber(chapterObject['Chapter']);

        final chapter = Episode(link: info.link!, name: 'Chapter $chapNumber');
        fetchedEpisodes.add(chapter);
      }

      info.episodes = fetchedEpisodes.reversed.toList();
    }

    return info;
  }

  @override
  Future<Episode> getViewerInfo(Episode episode) async {
    if (await webScraper.loadWebPage(episode.link)) {
      final serversList = webScraper.getElement(
          'div.anime_video_body > div.anime_muti_link > ul > li > a',
          ['data-video']);

      for (var i = 0; i < serversList.length; i++) {
        var serverLink = serversList[i]['attributes']['data-video'];
        if (!serverLink.startsWith('http')) {
          serverLink = 'https://$serverLink';
        }

        String serverTitle = serversList[i]['title'];
        serverTitle = serverTitle.trim().split('Choose')[0];

        episode.videoServers
            .add(VideoServer(title: serverTitle, link: serverLink));
      }
    }

    return episode;
  }

  /// Converts "MangaSee chapter formatting" to a readable chapter number.
  ///
  /// Chapter formatting:
  /// ```
  /// eg. 109565 -> [1] [0956] [5]      -> Chapter 956.5
  ///                ?   chap.  decimal
  /// ```
  /// [chapter] is the chapter number formatted from MangaSee's website.
  /// Returns a readable chapter number.
  String processChapterNumber(String chapter) {
    String decimalNumber =
        chapter.substring(chapter.length - 1, chapter.length);
    String decimal = decimalNumber != '0' ? '.$decimalNumber' : '';
    String integer = removeChapterPad(chapter.substring(1, chapter.length - 1));
    return integer + decimal;
  }

  /// Removes zero-padding from [chapter].
  ///
  /// Recursive function that keeps removing leading "0" until there are no more.
  /// If the final string is empty, it returns "0" (It will be empty if the
  /// chapter number is actually "0" and it gets deleted by the function).
  /// Returns the chapter without zero-padding.
  String removeChapterPad(String chapter) {
    if (chapter.startsWith('0')) {
      return removeChapterPad(chapter.substring(1, chapter.length));
    }
    return chapter.isNotEmpty ? chapter : '0';
  }
}
