class Audio {
  int id;
  String title;
  String duration;
  String author;
  String thumbnailUrl;
  int listenCount;
  int votes;

  Audio.fromJson(Map<String, dynamic> json):
        id = json['id'] as int,
        title = json['title'] as String,
        duration = json['duration'] as String,
        author = json['author'] as String,
        thumbnailUrl = json['thumbnailUrl'] as String,
        listenCount = json['listenCount'] as int,
        votes = json['votes'] as int
  ;
}
