import 'dart:convert';

class Site {
  String siteUrl;
  String siteUrlImage;
  String siteLookableName;
  String siteName;




  Site.fromJson(Map<String, dynamic> json):
        siteUrl = json['site_url'] as String,
        siteUrlImage = json['site_url_image'] as String,
        siteLookableName = json['site_lookable_name'] as String,
        siteName = json['site_name'] as String
  ;


}