import 'package:fmanime/models/entry_info.dart';

abstract class BaseParser {
  Future<List<EntryInfo>?> getGridData(String? url, int page);

  Future<EntryInfo?> getDetailsData(EntryInfo info);

  Future<EntryInfo?> getContentData(EntryInfo info);

  Future<Episode> getViewerInfo(Episode episode);
}
