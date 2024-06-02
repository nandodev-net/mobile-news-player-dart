class Audio {
  int id;
  String title;
  String duration;
  String author;
  int authorId;
  String authorDescription;
  String authorType;
  String thumbnailUrl;
  String audioUrl;
  int listenCount;
  int votes;
  String authorFollowers;

  Audio.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        title = json['title'] as String,
        duration = json['duration'] as String,
        authorFollowers = json['author_followers'] as String,
        author = json['author'] as String,
        authorId = json['author_id'] as int,
        authorDescription = json['author_description'] ?? json['author'] as String, //TODO revisar no detecta descripcion desde full player
        authorType = json['author_type'] as String,
        thumbnailUrl = json['thumbnailUrl'] as String,
        audioUrl = json['audioUrl'] ?? " ",
        listenCount = json['listenCount'] as int,
        votes = json['votes'] as int;
}
