import 'package:intl/intl.dart';
import 'package:note_app/src/utils/database/model.dart';

class Note extends Model {
  int? id;
  String title;
  String note;
  int? archived;
  int? trashed;
  DateTime? createdAt;
  DateTime? updatedAt;

  Note(
      {this.id,
      required this.title,
      required this.note,
      this.archived = 0,
      this.trashed = 0,
      this.createdAt,
      this.updatedAt});

  static String getTableName() {
    return "notes";
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> item = {
      "title": title,
      "note": note,
      "archived": archived,
      "trashed": trashed,
      "updated_at": DateFormat("y-M-dd H:mm:ss").format(DateTime.now())
    };

    if (id != null || id != 0) {
      item.putIfAbsent('id', () => id);
    }

    return item;
  }

  static fromJson(Map<dynamic, dynamic> record) => Note(
      id: record['id'] as int? ?? 0,
      title: record['title'] as String? ?? '',
      note: record['note'] as String? ?? '',
      archived: (record['archived'] as int?) ?? 0,
      trashed: (record['trashed'] as int?) ?? 0,
      createdAt: DateTime.tryParse(record['created_at'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(record['updated_at'] as String? ?? '') ??
          DateTime.now());
}
