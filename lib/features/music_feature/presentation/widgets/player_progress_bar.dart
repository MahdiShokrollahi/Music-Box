import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PlayerProgressBar extends StatelessWidget {
  const PlayerProgressBar(
      {super.key,
      this.buffer,
      required this.total,
      required this.progress,
      this.onChanged});
  final Duration? buffer;
  final Duration total;
  final Duration progress;
  final ValueChanged<Duration>? onChanged;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final ThemeData themeData = Theme.of(context);

    int totalValue = total.inMilliseconds;
    int progressValue = progress.inMilliseconds;
    int bufferValue = buffer?.inMilliseconds ?? 0;

    Duration remainingDuration =
        Duration(milliseconds: totalValue - progressValue);
    double percent = (bufferValue / totalValue).toDouble();
    double min = 0;
    double max = totalValue.toDouble();

    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: themeData.colorScheme.primary,
              inactiveTrackColor:
                  themeData.colorScheme.primary.withOpacity(0.1),
              trackShape: const RoundedRectSliderTrackShape(),
              trackHeight: 6.0,
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 14.0, elevation: 6, pressedElevation: 10),
              overlayColor: Colors.white,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  width: width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: percent >= 0 && percent <= 1
                      ? LinearPercentIndicator(
                          width: width - 40,
                          lineHeight: 6.0,
                          percent: percent,
                          barRadius: const Radius.circular(10),
                          backgroundColor: Colors.transparent,
                          progressColor:
                              themeData.colorScheme.primary.withOpacity(0.2))
                      : Container(),
                ),
                Container(
                  width: width,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Slider(
                      value: progressValue.toDouble() <= totalValue.toDouble()
                          ? progressValue.toDouble()
                          : totalValue.toDouble(),
                      min: min,
                      max: max,
                      onChanged: (value) {
                        if (onChanged != null) {
                          onChanged!
                              .call(Duration(milliseconds: value.toInt()));
                        }
                      }),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 32),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${progress.inMinutes.remainder(60).toString().padLeft(2, "0")}:${(progress.inSeconds.remainder(60).toString().padLeft(2, "0"))}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: themeData.colorScheme.primary,
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "-${remainingDuration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${(remainingDuration.inSeconds.remainder(60).toString().padLeft(2, "0"))}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: themeData.colorScheme.primary,
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }
}
