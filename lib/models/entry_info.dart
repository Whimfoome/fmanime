import 'package:hive/hive.dart';

part 'entry_info.g.dart';

@HiveType(typeId: 0)
class EntryInfo extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? link;

  @HiveField(3)
  String? coverImage;

  @HiveField(4)
  String? description = '';

  @HiveField(5)
  String? releaseDate;

  @HiveField(6)
  String provider = '';

  @HiveField(7)
  bool favorite = false;

  @HiveField(8)
  List<Episode> episodes = [];

  EntryInfo();

  String? getTitle() => name;
}

@HiveType(typeId: 1)
class Episode extends HiveObject {
  Episode({required this.link, required this.name});

  @HiveField(0)
  String name;

  @HiveField(1)
  String link;

  @HiveField(2)
  bool read = false;

  List<String> servers = [];
}
