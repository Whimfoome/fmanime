import "package:http/http.dart" as http;
import "package:html/dom.dart" as dom;
import "package:html/parser.dart";

Future<dom.Document?> downloadHTML(String url, {int timeout = 8}) async {
  try {
    final response =
        await http.get(Uri.parse(url)).timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return parse(response.body);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
