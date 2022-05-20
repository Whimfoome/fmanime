import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:fmanime/models/anime_info.dart';

abstract class BasicParser {
  String? _link;

  /// Get the link for current page
  String? getLink() => this._link;

  BasicParser(String link) {
    this._link = link;
    print(this._link);
  }

  /// Download HTML string from link
  Future<dom.Document?> downloadHTML() async {
    try {
      final response = await http
          .get(
            Uri.parse(this._link!),
          )
          .timeout(Duration(seconds: 8)); // Timeout in 8s

      if (response.statusCode == 200) {
        return parse(response.body);
      } else {
        // Not 200, just null
        return null;
      }
    } catch (e) {
      print(e);
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
      // There should only one of the list
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

/// It gets the current domain and will be called when app opens
class DomainParser {
  final String _gogoanime;
  DomainParser(this._gogoanime);

  /// Replace http with https if https doesn't exist
  String? _replaceHttp(String? link) {
    if (link == null) return null;
    if (link.contains('https')) return link;
    return link.replaceAll('http', 'https');
  }

  /// Request to the domain currently saved and see if there is a new one
  Future<String> getNewDomain() async {
    String finalDomain = _gogoanime;

    try {
      String? newDomain = _replaceHttp(this._gogoanime);
      // WHen it is null, it means that there is no more redirect and it is the latest domain
      while (newDomain != null) {
        // Request but don't follow redirects
        final request = http.Request('GET', Uri.parse(newDomain))
          ..followRedirects = false;
        // Get response and get the new location
        final response = await http.Client().send(request);
        // Replace http with https because `http` doesn't redirect for some reasons
        newDomain = _replaceHttp(response.headers['location']);
        if (newDomain != null) {
          finalDomain = newDomain;
        }
      }

      return finalDomain;
    } catch (e) {
      print(e);
      return finalDomain;
    }
  }
}
