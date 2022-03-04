import 'dart:convert';

class NewsRequestMapper {
  var status;
  int totalResults;
  List<News> results;
  int nextPage;

  NewsRequestMapper.fromJson(Map<String, dynamic> json):
      status = json['status'],
      totalResults = json['totalResults'],
      results = List.from(json['results']).map((result)=> News.fromJson(result)).toList(),
      nextPage = json['nextPage'];
}

class News {
  String? title;
  String? link;
  String? source_id;
  // List<String> keywords;
  // List<String> creator;
  String? image_url;
  String? video_url;
  String? description;
  String? pubDate;
  String? content;
  // List<String> country;
  // List<String> category;
  String? language;


    News.fromJson(Map<String, dynamic> json):
        title = json['title'] as String?,
        link = json['link'] as String?,
        source_id = json['source_id'] as String?,
       // keywords = List.from(json['keywords']),
       // creator = List.from(json['creator']),
        image_url = json['image_url'] as String?,
        video_url = json['video_url'] as String?,
        description = json['description'] as String?,
        pubDate = json['pubDate'] as String?,
        content = json['content'] as String?,
      //  country = List.from(json['country']),
       // category = List.from(json['category']),
        language = json['language'] as String?;

}




