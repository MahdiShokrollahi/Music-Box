// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'download_cubit.dart';

class DownloadState {
  double? progress;

  DownloadState({required this.progress});

  DownloadState copyWith({
    double? progress,
  }) {
    return DownloadState(
      progress: progress,
    );
  }
}
