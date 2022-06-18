// This isn't even model file, but I keep it here for conveniece...
import 'package:fmanime/services/anime_parsers/gogoanime_parser.dart';
import 'package:fmanime/services/base_parser.dart';
import 'package:fmanime/services/manga_parsers/mangasee_parser.dart';

enum ContentType {
  anime,
  manga,
}

BaseParser chooseProvider(ContentType type) {
  if (type == ContentType.anime) {
    return GogoanimeParser();
  } else {
    return MangaSeeParser();
  }
}
