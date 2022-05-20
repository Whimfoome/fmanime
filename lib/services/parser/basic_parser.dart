import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:fmanime/models/anime_info.dart';

abstract class BasicParser {
  BasicParser(String this._link);

  final String? _link;

  /// Get the link for current page
  String? getLink() => _link;

  /// Download HTML string from link
  Future<dom.Document?> downloadHTML() async {
    try {
      final response = await http
          .get(
            Uri.parse(_link!),
          )
          .timeout(const Duration(seconds: 8)); // Timeout in 8s

      if (response.statusCode == 200) {
        return parse(response.body);
      } else {
        // Not 200, just null
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// All subclasses have different implementations
  parseHTML(dom.Document? body);
}

class AnimeParser extends BasicParser {
  AnimeParser(String link) : super(link);

  @override
  List<AnimeInfo> parseHTML(dom.Document? body) {
    List<AnimeInfo> list = [];

    if (body != null) {
      final div = body.getElementsByClassName('items');

      if (div.length == 1) {
        final items = div.first;
        // check if items contains an error message
        if (!items.text.contains('Sorry')) {
          // It can be an empty list
          if (items.hasChildNodes()) {
            for (var element in items.nodes) {
              // Only parse elements, no Text
              if (element is dom.Element) {
                list.add(AnimeInfo(element));
              }
            }
          }
        }
      }
    }

    return list;
  }
}

class Parser {
  String gogoanimeDomain = "https://www26.gogoanimes.tv/";

  Future getAnimeDomain() async {
    final request = http.Request('GET', Uri.parse(gogoanimeDomain))
      ..followRedirects = false;

    final response = await http.Client().send(request);
  }
}
