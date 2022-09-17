import 'package:flutter/material.dart';
import 'package:fmanime/main.dart';
import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/services/base_parser.dart';
import 'package:fmanime/ui/pages/anime_viewer.dart';
import 'package:fmanime/ui/pages/detail.dart';
import 'package:fmanime/ui/pages/discover.dart';
import 'package:fmanime/ui/pages/manga_reader.dart';
import 'package:fmanime/utils/content_type.dart' as contype;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => const NavBar(title: 'Fmanime'));

      case '/discover':
        if (args is contype.ContentType) {
          return MaterialPageRoute(
            builder: (_) => Discover(
              contentType: args,
            ),
          );
        }
        return _errorRoute();

      case '/details':
        if (args is DetailsRouteArgs) {
          return MaterialPageRoute(
            builder: (_) => DetailPage(
              info: args.info,
              parser: args.parser,
              contentType: args.contentType,
            ),
          );
        }
        return _errorRoute();

      case '/watch':
        if (args is Episode) {
          return MaterialPageRoute(
            builder: (_) => AnimeViewer(
              episode: args,
            ),
          );
        }
        return _errorRoute();

      case '/read':
        if (args is ReadRouteArgs) {
          return MaterialPageRoute(
            builder: (_) => MangaReader(
              entryInfo: args.info,
              epIndex: args.episodeIndex,
              updatedEpisodeIndex: args.updatedEpisodeIndex,
            ),
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('ERROR'),
          ),
        );
      },
    );
  }
}

class DetailsRouteArgs {
  final EntryInfo info;
  final BaseParser parser;
  final contype.ContentType contentType;

  DetailsRouteArgs(this.info, this.parser, this.contentType);
}

class ReadRouteArgs {
  final EntryInfo info;
  final int episodeIndex;
  final Function updatedEpisodeIndex;

  ReadRouteArgs(this.info, this.episodeIndex, this.updatedEpisodeIndex);
}
