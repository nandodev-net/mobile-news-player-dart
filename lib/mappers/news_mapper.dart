// import 'dart:convert';
import 'package:noticias_sin_filtro/entities/news.dart';

class NewsRequestMapper {
  int totalPages;
  List<News> results;
  String? next;
  String? previous;
  int count;

  NewsRequestMapper.fromJson(Map<String, dynamic> json):
    totalPages = json['total_pages'],
    results = List.from(json['results']).map((result)=> News.fromJson(result)).toList(),
    next = json['next'] as String?,
    previous = json['previous'] as String?,
    count = json['count'];
}






