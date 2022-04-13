import 'dart:convert';

class Category {
  String categoryName;
  String categoryLookableName;
  String categoryColor;

  Category.fromJson(Map<String, dynamic> json):
        categoryName = json['category_name'] as String,
        categoryLookableName = json['category_lookable_name'] as String,
        categoryColor = json['category_color'] as String
  ;
}