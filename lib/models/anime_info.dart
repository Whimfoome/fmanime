class AnimeInfo {
  String? name;
  String? link;
  String? coverImage;

  AnimeInfo();

  AnimeInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    name = json['name'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'link': link,
    };
  }

  @override
  String toString() {
    return 'name: $name, link: $link';
  }

  String? getTitle() => name;
}
