import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final bool autoPlay;
  final double playTriggerFraction;

  const ReelVideoPlayer({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.autoPlay = true,
    this.playTriggerFraction = 0.6,
  });

  @override
  State<ReelVideoPlayer> createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
  late BetterPlayerConfiguration _playerConfig;
  late BetterPlayerController _controller;
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _playerConfig = BetterPlayerConfiguration(
      autoPlay: false,
      aspectRatio: Get.width / Get.height,
      looping: true,
      expandToFill: true,
      fit: BoxFit.cover,
      autoDispose: true,
      handleLifecycle: true,
      placeholderOnTop: true,
      showPlaceholderUntilPlay: true,
      errorBuilder: (context, errorMessage) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 32),
              SizedBox(height: 8),
              Text(
                'Something wrong with playing video',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        enableFullscreen: false,
        enablePip: false,
        enablePlayPause: true,
        enableMute: true,
        enableProgressBar: true,
        enableSkips: false,
        enableRetry: true,
        enableOverflowMenu: false,
        controlsHideTime: Duration(milliseconds: 500),
        showControlsOnInitialize: false,
        showControls: true,
      ),
    );

    _controller = BetterPlayerController(_playerConfig);
    _setupDataSource();
  }

  void _setupDataSource() {
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl,
      notificationConfiguration: const BetterPlayerNotificationConfiguration(
        showNotification: false,
      ),
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 5000,
        maxBufferMs: 15000,
        bufferForPlaybackMs: 2500,
        bufferForPlaybackAfterRebufferMs: 5000,
      ),
      placeholder: widget.thumbnailUrl != null
          ? Image.network(widget.thumbnailUrl!, fit: BoxFit.cover)
          : null,
    );
    _controller.setupDataSource(dataSource);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final visibleFraction = info.visibleFraction;
    if (visibleFraction >= widget.playTriggerFraction) {
      _controller.play();
    } else {
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: _onVisibilityChanged,
      child: BetterPlayer(
        controller: _controller,
      ),
    );
  }
}
