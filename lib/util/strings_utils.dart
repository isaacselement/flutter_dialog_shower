import 'dart:math';

class StringsUtils {
  /// Random Methods

  static String random(int length) {
    String hex = '0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    return List.generate(length, (index) => hex[Random().nextInt(hex.length)]).join();
  }

  static String randomHex(int length) {
    String hex = '0123456789abcdef';
    Random random = Random();
    return List.generate(length, (index) => hex[random.nextInt(hex.length)]).join();
  }

  /// Comma Values

  static String changeCommaValue(String content, String key, String value, {String? separator, String? equalSymbol}) {
    List<int>? indexes = getCommaValueIndexes(content, key, separator: separator ?? ';', equalSymbol: equalSymbol ?? '=');
    String result = content;
    if (indexes != null) {
      result = content.replaceRange(indexes.first, indexes.last, value);
    }
    return result;
  }

  static String? getCommaValue(String content, String key, {String? separator, String? equalSymbol}) {
    List<int>? indexes = getCommaValueIndexes(content, key, separator: separator ?? ';', equalSymbol: equalSymbol ?? '=');
    if (indexes != null) {
      return content.substring(indexes.first, indexes.last);
    }
    return null;
  }

  // separator maybe ; or &, equalSymbol maybe = or :
  static List<int>? getCommaValueIndexes(String content, String key, {String separator = ';', String equalSymbol = '='}) {
    int start = -1;

    String k = "$key=";
    if (content.startsWith(k)) {
      start = 0;
    } else {
      k = '$separator$k';
      start = content.indexOf(k);
    }
    if (start < 0) {
      return null;
    }
    int begin = start + k.length;
    int end = content.indexOf(separator, begin);
    if (end < 0) end = content.length;
    return [begin, end];
  }
}
