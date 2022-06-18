import 'package:fmanime/services/base_parser.dart';
import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/models/content_type.dart' as contype;
import 'package:web_scraper/web_scraper.dart';

class GogoanimeParser extends BaseParser {
  GogoanimeParser()
      : super(
          domain: 'https://gogoanime.gg',
          queryPopular: '/popular.html',
          querySearch: '/search.html?keyword=',
          contentType: contype.ContentType.anime,
        );

  final ajaxScraper = WebScraper('https://ajax.gogo-load.com');

  @override
  Future<List<EntryInfo>> getGridData(String url, int page) async {
    bool isSearch = url.startsWith('search');

    final dataRoute = '$url${isSearch ? '&' : '?'}page=$page';

    List<EntryInfo> list = [];

    if (await webScraper.loadWebPage(dataRoute)) {
      final imageElements =
          webScraper.getElement('ul.items > li > div.img > a > img', ['src']);

      final urlElements =
          webScraper.getElement('ul.items > li > p.name > a', ['href']);

      for (var i = 0; i < urlElements.length; i++) {
        var entryInfo = EntryInfo();

        entryInfo.name = urlElements[i]['title'];
        entryInfo.link = urlElements[i]['attributes']['href'];
        entryInfo.coverImage = imageElements[i]['attributes']['src'];

        list.add(entryInfo);
      }
    }

    return list;
  }

  @override
  Future<EntryInfo?> getDetailsData(EntryInfo info) async {
    if (await webScraper.loadWebPage(info.link ?? '')) {
      final descriptionElement =
          webScraper.getElement('div.anime_info_body_bg > p.type', []);

      final movieIdElement = webScraper.getElement('#movie_id', ['value'])[0];

      String description = descriptionElement[1]['title'];
      description = description.split('Plot Summary: ')[1];

      info.description = description;
      info.id = movieIdElement['attributes']['value'];
    }

    return info;
  }

  @override
  Future<EntryInfo?> getContentData(EntryInfo info) async {
    List<Episode> fetchedEpisodes = [];

    final linkRoute =
        '/ajax/load-list-episode?ep_start=0&ep_end=5000&id=${info.id}';

    if (await ajaxScraper.loadWebPage(linkRoute)) {
      final hrefElements =
          ajaxScraper.getElement('#episode_related > li > a', ['href']);

      final epNameElements =
          ajaxScraper.getElement('#episode_related > li > a > div.name', []);

      for (var i = 0; i < epNameElements.length; i++) {
        String epName = epNameElements[i]['title'];
        epName = epName.split('EP ')[1];

        String epHref = hrefElements[i]['attributes']['href'] as String;
        epHref = epHref.trim();

        final episode = Episode(link: epHref, name: 'Episode $epName');
        fetchedEpisodes.add(episode);
      }
    }

    info.episodes = fetchedEpisodes.reversed.toList();

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
}
