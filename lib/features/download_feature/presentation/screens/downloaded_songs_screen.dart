import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_box/core/services/downlaod_manager.dart';
import 'package:music_box/core/widgets/marqwee_widget.dart';

class DownloadedSongsScreen extends StatelessWidget {
  const DownloadedSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ValueListenableBuilder(
            valueListenable: DownLoadManager.listenable,
            builder: (context, box, child) {
              var songList = box.values.toList();
              return ListView.builder(
                  itemCount: songList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var song = songList[index];
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image:
                                        FileImage(File(song.image!), scale: 6),
                                    centerSlice:
                                        const Rect.fromLTRB(1, 1, 1, 1),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MarqueeWidget(
                                      child: Text(
                                    song.title!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                  )),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    overflow: TextOverflow.ellipsis,
                                    song.moreInfo!.singers!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              color: Colors.red,
                              iconSize: 22,
                              icon: const Icon(Icons.favorite_outline),
                              onPressed: () => {},
                            ),
                            // Text(
                            //   Helper.formatTime(song.duration!),
                            //   style: TextStyle(
                            //       fontSize: 12, color: Colors.grey.shade700),
                            // ),
                          ],
                        ),
                      ),
                    );
                  });
            }));
  }
}
