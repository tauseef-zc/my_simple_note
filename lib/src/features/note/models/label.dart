import 'package:note_app/src/utils/database/model.dart';

class Label extends Model {
  int? id;
  String label;
  DateTime? createdAt;
  DateTime? updatedAt;

  Label({this.id, required this.label, this.createdAt, this.updatedAt});

  static String getTableName() {
    return "notes";
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> item = {
      "label": label,
      "updated_at": DateTime.now().toIso8601String()
    };

    if (id != null || id != 0) {
      item.putIfAbsent('id', () => id);
    }
    return item;
  }

  factory Label.fromJson(Map<String, dynamic> json) => Label(
      label: json["label"],
      createdAt: json['created_at'],
      updatedAt: json['updated_at']);
}
