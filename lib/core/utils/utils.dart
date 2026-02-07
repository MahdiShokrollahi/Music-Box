bool isExpired({String? url, int? epoch}) {
  if (url != null) {
    RegExpMatch? match = RegExp(".expire=([0-9]+)?&").firstMatch(url);
    if (match != null) {
      epoch = int.parse(match[1]!);
    }
  }

  if (epoch != null &&
      DateTime.now().millisecondsSinceEpoch ~/ 1000 + 1800 < epoch) {
    return false;
  }
  return true;
}
