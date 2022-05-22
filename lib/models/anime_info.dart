class AnimeInfo {
  String? name;
  String? link;
  String? coverImage;
  String? description;

  List<Episode> episodes = [];

  AnimeInfo();

  String? getTitle() => name;
}

class Episode {
  String? name;
  String? link;
}
