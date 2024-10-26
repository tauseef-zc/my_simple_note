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
      "updated_at": DateTime.now().toIso8601String()
    };

    if (id != null || id != 0) {
      item.putIfAbsent('id', () => id);
    }

    return item;
  }

  factory Note.fromJson(Map<String, dynamic> json) => Note(
      title: json["title"],
      note: json["note"],
      archived: json["archived"] ?? 0,
      trashed: json['trashed'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at']);
}
