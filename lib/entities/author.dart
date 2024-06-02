
class Author{
  int id;
  String name;
  String thumbnailUrl;
  String type;
  String description;
  int followers;

  Author({
  required this.id,
  required this.name,
  required this.thumbnailUrl,
  required this.type,
  required this.description,
  required this.followers,
  });

  Author.fromJson(Map<String, dynamic> json):
        id = json['id'] as int,
        name = json['name'] as String,
        type = json['type'] as String,
        thumbnailUrl = json['thumbnailUrl'] as String,
        followers = json['followers'] as int,
        description = json['description'] ?? "Thank's for listen us on NSFapp."
  ;
}

final testAuthor = Author(
    id:-1,
    name:'TEST',
    thumbnailUrl:'https://drive.google.com/uc?export=view&id=15y4qTizfabCMrSqFIbm9PyM98TB8bAfE',
    description:'TEST',
    type:'News',
    followers: 0,
  );


class AuthorSuggestion{
  String name;


  AuthorSuggestion({
  required this.name
  });

  AuthorSuggestion.fromJson(Map<String, dynamic> json):
        name = json['name'] as String
  ;
}