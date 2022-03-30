// import 'dart:convert';

class News {
  String? title;
  String? url;
  String? mediaSite;
  String? pubDatetime;
  String? imageUrl;
  String? excerpt;
  String? scrapedDate;
  bool relevance;
  //List<String> categories;


  // List<String> country;
  // List<String> category;
  //String? language;
  // List<String> keywords;
  // List<String> creator;
  //String? video_url;


  News.fromJson(Map<String, dynamic> json):
        title = json['title'] as String?,
        url = json['url'] as String?,
        mediaSite = json['mediaSite'] as String?,
        pubDatetime = json['datetime'] as String?,
        imageUrl = json['image_url'],
        excerpt = json['excerpt'],
        scrapedDate = json['scraped_date'],
        relevance = json['relevance'];


}