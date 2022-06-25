class EntryInfo {
  String? id;
  String? name;
  String? link;
  String? coverImage;
  String? description = '';
  String? releaseDate;

  List<Episode> episodes = [];

  EntryInfo();

  String? getTitle() => name;
}

class Episode {
  Episode({required this.link, required this.name});

  String name;
  String link;

  List<String> servers = [];
}
