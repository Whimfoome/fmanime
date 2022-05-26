import "package:html/dom.dart" as dom;
import "package:fmanime/models/anime_info.dart";
import "package:fmanime/services/parser/html_helper.dart";

class GogoanimeParser {
  GogoanimeParser();
  // domains: "https://www26.gogoanimes.tv/"
  //          "https://gogoanimes.to/"
  final String domain = "https://www26.gogoanimes.tv/";

  Future<List<AnimeInfo>?> getGridData(String? url, int page) async {
    bool isSearch = url?.startsWith("/search") ?? false;

    final link = "$domain${url!}${isSearch ? '&' : '?'}page=$page";

    final parsedData = downloadHTML(link).then((body) {
      List<AnimeInfo> list = [];

      if (body != null) {
        final div = body.getElementsByClassName('items');

        if (div.length == 1) {
          final items = div.first;

          if (items.text.contains('Sorry') || !items.hasChildNodes()) {
            return null;
          }

          for (var element in items.nodes) {
            if (element is dom.Element) {
              list.add(getMainAnimeInfo(element));
            }
          }
        }
      }

      return list;
    });

    return parsedData;
  }

  Future<AnimeInfo?> getDetailsData(AnimeInfo info) {
    final link = domain + (info.link ?? '');

    final parsedData = downloadHTML(link).then((body) {
      AnimeInfo newInfo = info;

      final infoClass =
          body?.getElementsByClassName("anime_info_body_bg").first;

      newInfo.description = infoClass?.nodes[9].nodes[1].text?.trimRight();

      final movieClass = body?.getElementById("movie_id");

      newInfo.id = movieClass?.attributes["value"];

      return newInfo;
    });

    return parsedData;
  }

  Future<AnimeInfo?> getEpisodesData(AnimeInfo info) {
    List<Episode> fetchedEpisodes = [];
    final link =
        "${domain}load-list-episode?ep_start=0&ep_end=5000&id=${info.id}";

    return downloadHTML(link).then((body) {
      final list =
          body?.getElementById("episode_related")?.getElementsByTagName("li");

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
              .getElementsByClassName("name")
              .first
              .text
              .trim()
              .split("EP ")[1];

          final episode = Episode(link: href, name: "Episode $epNumber");
          fetchedEpisodes.add(episode);
        }
      } else {
        fetchedEpisodes = [];
      }

      info.episodes = fetchedEpisodes.reversed.toList();

      return info;
    });
  }

  AnimeInfo getMainAnimeInfo(dom.Element element) {
    AnimeInfo animeInfo = AnimeInfo();

    final imageClass = element.getElementsByClassName('img').first;
    animeInfo.coverImage = imageClass.nodes[1].nodes[1].attributes['src'];

    final nameClass = element.getElementsByClassName('name').first;
    final nameLink = nameClass.firstChild;
    animeInfo.name = nameLink?.attributes['title']?.trim();
    animeInfo.link = nameLink?.attributes['href'];

    return animeInfo;
  }
}
