
class Author{
  int id;
  String name;
  String thumbnailUrl;
  String description;

  Author.fromJson(Map<String, dynamic> json):
        id = json['id'] as int,
        name = json['name'] as String,
        thumbnailUrl = json['thumbnailUrl'] as String,
        description = json['description'] as String
  ;
}