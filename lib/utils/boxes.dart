import 'package:fmanime/models/entry_info.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Boxes {
  static Future initializeBoxes() async {
    await Hive.initFlutter();

    Hive.registerAdapter(EntryInfoAdapter());
    Hive.registerAdapter(EpisodeAdapter());

    await Hive.openBox<EntryInfo>('animeEntries');
    await Hive.openBox<EntryInfo>('mangaEntries');
  }

  static Box<EntryInfo> getAnimeEntries() {
    return Hive.box<EntryInfo>('animeEntries');
  }

  static Box<EntryInfo> getMangaEntries() {
    return Hive.box<EntryInfo>('mangaEntries');
  }
}
