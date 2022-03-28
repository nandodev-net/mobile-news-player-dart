// import 'dart:convert';
import 'package:noticias_sin_filtro/entities/news.dart';

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






