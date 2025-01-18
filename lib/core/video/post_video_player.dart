import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final bool autoPlay;
  final double playTriggerFraction;

  const PostVideoPlayer({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.autoPlay = true,
    this.playTriggerFraction = 0.6,
  });

  @override
  State<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  late BetterPlayerConfiguration _playerConfig;
  late BetterPlayerController _controller;
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _playerConfig = const BetterPlayerConfiguration(
      autoPlay: false,
      fit: BoxFit.cover,
      // aspectRatio: 16 / 9,
      autoDispose: true,
      handleLifecycle: true,
      placeholderOnTop: true,
      showPlaceholderUntilPlay: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableFullscreen: false,
        enablePip: false,
        enablePlayPause: true,
        enableMute: true,
        enableProgressBar: true,
        enableSkips: false,
        enableRetry: true,
        enableOverflowMenu: false,
        controlsHideTime: Duration(seconds: 1),
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
      child: Container(
        width: double.infinity,
        //height: 390,
        color: Colors.black,
        child: BetterPlayer(
          controller: _controller,
        ),
      ),
    );
  }
}
