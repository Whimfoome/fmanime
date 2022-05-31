class AnimeInfo {
  String? id;
  String? name;
  String? link;
  String? coverImage;
  String? description = '';
  String? releaseDate;

  List<Episode> episodes = [];

  AnimeInfo();

  String? getTitle() => name;
}

class Episode {
  Episode({required this.link, required this.name});

  String name;
  String link;

  List<VideoServer> videoServers = [];
}

class VideoServer {
  String title;
  String link;

  VideoServer({required this.title, required this.link});
}
