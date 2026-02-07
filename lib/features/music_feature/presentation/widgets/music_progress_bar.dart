import 'package:flutter/material.dart';
import 'package:music_box/core/services/audio_manger.dart';
import 'package:music_box/core/utils/models/position_data.dart';
import 'package:rxdart/rxdart.dart';

class MusicProgressBar extends StatelessWidget {
  const MusicProgressBar({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
            player.positionStream,
            player.bufferedPositionStream,
            player.durationStream,
            (position, bufferedPosition, duration) => PositionData(
                position, bufferedPosition, duration ?? Duration.zero)),
        builder: (context, snapShot) {
          final positionData = snapShot.data;
          int totalValue =
              positionData != null ? positionData.duration.inMilliseconds : 0;
          int progressValue =
              positionData != null ? positionData.position.inMilliseconds : 0;
          double remainingValue = (progressValue / totalValue).toDouble();
          return Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 8.0,
                  offset: const Offset(0.0, -0.0))
            ], color: Colors.grey),
            child: LinearProgressIndicator(
              backgroundColor: Colors.yellow,
              value: remainingValue > 0 ? remainingValue : null,
              minHeight: 3,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
            ),
          );
        });
  }
}
