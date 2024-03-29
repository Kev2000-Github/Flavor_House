import 'package:dio/dio.dart';
import 'package:flavor_house/utils/text_themes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class Helper {
  static Future<MultipartFile> getMultiPartFile(String imagePath, { String? filename, MediaType? contentType}) async {
    String fullFileName = imagePath.split('/').last;
    String ext = fullFileName.split('.').last;
    RegExp isHTTPPath = RegExp(r'^(http|https)');
    if(isHTTPPath.hasMatch(imagePath)){
      var image = await http.get(Uri.parse(imagePath));
      return MultipartFile.fromBytes(
          image.bodyBytes,
          filename: filename ?? fullFileName,
          contentType: contentType ?? MediaType("image", ext)
      );
    }
    return MultipartFile.fromFile(
        imagePath,
        filename: filename ?? fullFileName,
        contentType: contentType ?? MediaType("image", ext)
    );
  }

  static RichText createPostDescription(String description) {
    RegExp isHashtag = RegExp(r'^#(\w|\d)+');
    List<String> splitDescription = description.split(" ");
    List<TextSpan> segments = splitDescription.map((segment) {
      if(isHashtag.hasMatch(segment)){
        return TextSpan(
            text: '$segment ',
            style: DesignTextTheme.get(type: TextThemeEnum.hashtag)
        );
      }
      return TextSpan(
          text: '$segment ',
          style: DesignTextTheme.get(type: TextThemeEnum.grayLight)
      );
    }).toList();
    return RichText(
        text: TextSpan(
            children: segments));
  }

  static toColor(String val) {
    var hexColor = val.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
