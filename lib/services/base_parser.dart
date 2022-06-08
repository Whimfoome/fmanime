import 'package:fmanime/models/entry_info.dart';
import 'package:fmanime/models/content_type.dart' as contype;

abstract class BaseParser {
  final String domain;
  final String queryPopular;
  final String querySearch;
  final contype.ContentType contentType;

  BaseParser({
    required this.domain,
    required this.queryPopular,
    required this.querySearch,
    required this.contentType,
  });

  Future<List<EntryInfo>?> getGridData(String? url, int page);

  Future<EntryInfo?> getDetailsData(EntryInfo info);

  Future<EntryInfo?> getContentData(EntryInfo info);

  Future<Episode> getViewerInfo(Episode episode);
}
