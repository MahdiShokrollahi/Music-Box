import 'package:flutter/material.dart';

class Helper {
  static String formatSongTitle(String title) {
    return title
        .replaceAll('&amp;', '&')
        .replaceAll('&#039;', "'")
        .replaceAll('&quot;', '"')
        .replaceAll('[Official Music Video]', '')
        .replaceAll('OFFICIAL MUSIC VIDEO', '')
        .replaceAll('Video', '')
        .replaceAll('[Official Video]', '')
        .replaceAll('[OFFICIAL VIDEO]', '')
        .replaceAll('[official music video]', '')
        .replaceAll('[Official Perfomance Video]', '')
        .replaceAll('[Lyrics]', '')
        .replaceAll('[Lyric Video]', '')
        .replaceAll('Lyric Video', '')
        .replaceAll('[Official Lyric Video]', '')
        .split(' (')[0]
        .split('|')[0]
        .trim();
  }

  static String formatTime(String inputTime) {
    // Parse the input time string
    List<String> parts = inputTime.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(
        parts[2].split('.')[0]); // Extract seconds and ignore milliseconds

    // Convert hours to minutes and add to the total minutes
    minutes += hours * 60;

    // Format the time as "hh:mm"
    String formattedTime = '${minutes}:${seconds.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  static Duration convertTimeStringToDuration(String timeString) {
    List<String> parts = timeString.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    double seconds = double.parse(parts[2]);

    // Convert seconds to milliseconds
    int milliseconds = (seconds * 1000).round();

    return Duration(hours: hours, minutes: minutes, milliseconds: milliseconds);
  }
}
