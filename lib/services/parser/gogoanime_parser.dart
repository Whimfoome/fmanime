import "package:http/http.dart" as http;
import "package:html/dom.dart" as dom;
import "package:html/parser.dart";
import "package:fmanime/models/anime_info.dart";

class GogoanimeParser {
  GogoanimeParser();
  // domains: "https://www26.gogoanimes.tv/"
  //          "https://gogoanimes.to/"
  final String domain = "https://www26.gogoanimes.tv/";
  String? _link;

  Future<dom.Document?> downloadHTML() async {
    try {
      final response = await http
          .get(
            Uri.parse(_link!),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        return parse(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<AnimeInfo>?> getMainData(String? url, int page) async {
    bool isSearch = url?.startsWith("/search") ?? false;

    _link = "$domain${url!}${isSearch ? '&' : '?'}page=$page";

    final parsedData = downloadHTML().then((body) {
      return parseMain(body);
    });

    return parsedData;
  }

  AnimeInfo? getDetailsData(AnimeInfo info) {
    _link = domain + (info.link ?? "");

    final parsedData = downloadHTML().then((body) {
      return parseDetails(info, body);
    });

    return parsedData;
  }

  List<AnimeInfo> parseMain(dom.Document? body) {
    List<AnimeInfo> list = [];

    if (body != null) {
      final div = body.getElementsByClassName('items');

      if (div.length == 1) {
        final items = div.first;
        // check if items contains an error message
        if (!items.text.contains('Sorry')) {
          if (items.hasChildNodes()) {
            for (var element in items.nodes) {
              // Only parse elements, no Text
              if (element is dom.Element) {
                list.add(getMainAnimeInfo(element));
              }
            }
          }
        }
      }
    }

    return list;
  }

  AnimeInfo parseDetails(AnimeInfo info, dom.Document? body) {
    AnimeInfo newInfo = info;

    final infoClass = body?.getElementsByClassName("anime_info_body_bg").first;

    newInfo.description = infoClass?.nodes[9].nodes[1].text?.trimRight();

    return newInfo;
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

class EpisodeSection {
  String? episodeStart;
  String? episodeEnd;
  String? movieId;

  EpisodeSection();

  String getLink() => "?ep_start=$episodeStart&ep_end=$episodeEnd&id=$movieId";
}
