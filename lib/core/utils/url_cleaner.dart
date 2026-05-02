class UrlCleaner {
  static String clean(String url) {
    if (url.isEmpty) return url;
    final cleaned = url.replaceAll(RegExp(r'\s+'), '').trim();
    print('[URL CLEANER] Processing...');
    print('[URL CLEANER] Original: "$url" -> Cleaned: "$cleaned"');
    return cleaned;
  }

  static List<String> cleanList(List<String>? urls) {
    if (urls == null) return [];
    return urls.map((url) => clean(url)).toList();
  }
}
