import 'dart:convert';

import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/services/base_parser.dart';
import 'package:fmanime/utils/content_type.dart' as contype;

class MangaSeeParser extends BaseParser {
  MangaSeeParser()
      : super(
          domain: 'https://mangasee123.com',
          queryPopular: '/search/?sort=v&desc=true',
          querySearch: '/search/?name=',
          contentType: contype.ContentType.manga,
        );

  List<EntryInfo> allManga = [];
  final chapterImageRegex = RegExp(r'^0+');

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
      List<dynamic> jsonResponse = varToJson('vm.Directory');

      // Sort by Popular Monthly
      jsonResponse.sort((a, b) => b["vm"].compareTo(a["vm"]));

      for (var mangaObject in jsonResponse) {
        var entryInfo = EntryInfo();

        entryInfo.name = mangaObject['s'];
        entryInfo.link = mangaObject['i'];
        entryInfo.coverImage =
            'https://temp.compsci88.com/cover/${mangaObject['i']}.jpg';

        list.add(entryInfo);
      }
    }

    return list;
  }

  @override
  Future<EntryInfo> getDetailsData(EntryInfo info) async {
    if (await webScraper.loadWebPage('/manga/${info.link}')) {
      final descriptionElement =
          webScraper.getElement('li.list-group-item > div.Content', []);

      String description = descriptionElement[0]['title'];
      info.description = description;
    }

    return info;
  }

  @override
  Future<EntryInfo?> getContentData(EntryInfo info) async {
    List<Episode> fetchedEpisodes = [];

    if (await webScraper.loadWebPage('/manga/${info.link}')) {
      List<dynamic> jsonResponse = varToJson('vm.Chapters');

      // Create Chapter items and add them to the list
      for (var chapterObject in jsonResponse) {
        String? name = chapterObject['ChapterName'];
        String indexChapter = chapterObject['Chapter'];

        if (name == null || name.isEmpty) {
          name = '${chapterObject['Type']} ${chapterImage(indexChapter, true)}';
        }

        var splittedName = name.split(' ');
        splittedName.last = removeNumberPad(splittedName.last);
        name = splittedName.join(' ');

        String url =
            '/read-online/${info.link}${chapterURLEncode(indexChapter)}';

        final chapter = Episode(link: url, name: name);
        fetchedEpisodes.add(chapter);
      }

      info.episodes = fetchedEpisodes.reversed.toList();
    }

    return info;
  }

  @override
  Future<Episode> getViewerInfo(Episode episode, [EntryInfo? info]) async {
    List<String> pagesList = [];

    if (info == null) {
      return episode;
    }

    if (await webScraper.loadWebPage(episode.link)) {
      // Get server url
      Map<String, dynamic> elementsServer =
          webScraper.getScriptVariables(['vm.CurPathName']);
      String scrapedStringServer = elementsServer['vm.CurPathName'][0]
          .replaceAll('vm.CurPathName = ', '');
      String responseServer =
          scrapedStringServer.substring(1, scrapedStringServer.length - 2);

      Map<String, dynamic> jsonResponse = varToJson('vm.CurChapter');

      // Create Chapter items and add them to the list
      String pathName = responseServer;
      String paddedChapterNumber = addNumberPad(episode.name.split(' ').last);
      String directory = jsonResponse['Directory'].length > 0
          ? jsonResponse['Directory'] + '/'
          : '';

      for (int page = 1; page <= int.parse(jsonResponse['Page']); page++) {
        String paddedPageNumber = page.toString().padLeft(3, '0');
        String pageUrl =
            'https://$pathName/manga/${info.link}/$directory$paddedChapterNumber-$paddedPageNumber.png';

        print(pageUrl);
        pagesList.add(pageUrl);
      }
    }

    episode.servers.addAll(pagesList);

    return episode;
  }

  dynamic varToJson(String varName) {
    Map<String, dynamic> elements = webScraper.getScriptVariables([varName]);

    String scrapedString = elements[varName][0].replaceAll('$varName = ', '');

    String response = scrapedString.substring(0, scrapedString.length - 1);

    return jsonDecode(response);
  }

  String chapterImage(String e, bool cleanString) {
    var a = e.substring(1, e.length - 1);

    if (cleanString) {
      a.replaceFirst(chapterImageRegex, '');
    }

    var b = int.parse(e.substring(e.length - 1));

    if (b == 0 && a.isNotEmpty) {
      return a;
    } else if (b == 0 && a.isEmpty) {
      return '0';
    } else {
      return '$a.$b';
    }
  }

  String chapterURLEncode(String e) {
    var index = '';
    final t = int.parse(e.substring(0, 1));

    if (t != 1) {
      index = '-index-$t';
    }

    int dgt;
    if (int.parse(e) < 100100) {
      dgt = 4;
    } else if (int.parse(e) < 101000) {
      dgt = 3;
    } else if (int.parse(e) < 110000) {
      dgt = 2;
    } else {
      dgt = 1;
    }

    final n = e.substring(dgt, e.length - 1);
    var suffix = '';
    final path = int.parse(e.substring(e.length - 1));

    if (path != 0) {
      suffix = '.$path';
    }

    return '-chapter-$n$suffix$index.html';
  }

  // 0005 -> 5
  String removeNumberPad(String number) {
    if (number.startsWith('0')) {
      return removeNumberPad(number.substring(1, number.length));
    }

    return number.isNotEmpty ? number : '0';
  }

  String addNumberPad(String number) {
    if (number.contains('.')) {
      return number.padLeft(6, '0');
    } else {
      return number.padLeft(4, '0');
    }
  }
}
