// lib/presentation/screens/call_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_calling/core/utils/constants/app_constants.dart';

@RoutePage()
class CallScreen extends StatefulWidget {
  final String channelName;
  final String uid;
  final ClientRoleType type;
  const CallScreen({
    super.key,
    required this.channelName,
    required this.uid,
    required this.type,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late RtcEngine _engine;
  int? _remoteUid;
  List<int> _remoteUids = []; // Track multiple remote users

  bool _muted = false;
  bool _videoDisabled = false;
  bool _screenSharing = false;
  bool _usingFrontCamera = true;
  bool _isJoined = false;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    // Request permissions first
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(appId: AppConstants.agoraAppId),
    );

    // Configure video encoder configuration
    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 60,
        bitrate: 0,
      ),
    );

    // Enable video
    await _engine.enableVideo();

    // Set up event handlers
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint('Local user joined channel: ${connection.channelId}');
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint('Remote user joined: $remoteUid');
          setState(() {
            _remoteUid = remoteUid;
            _remoteUids.add(remoteUid);
          });
        },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              debugPrint('Remote user left: $remoteUid');
              setState(() {
                _remoteUids.remove(remoteUid);
                if (_remoteUid == remoteUid) {
                  _remoteUid = _remoteUids.isNotEmpty
                      ? _remoteUids.first
                      : null;
                }
              });
            },
        onError: (ErrorCodeType errorCode, String message) {
          debugPrint('Agora Error: $errorCode, $message');
        },
      ),
    );

    // Start local preview
    await _engine.startPreview();

    await _joinMainChannel();
  }

  Future<void> _joinMainChannel() async {
    try {
      await _engine.joinChannel(
        token: AppConstants.tempToken,
        channelId: widget.channelName,
        uid: 0, // Let Agora assign UID automatically
        options: ChannelMediaOptions(
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,

          clientRoleType: widget.type,
        ),
      );
    } catch (e) {
      debugPrint('Failed to join channel: $e');
    }
  }

  Future<void> _startScreenShare() async {
    try {
      await _engine.startScreenCapture(
        ScreenCaptureParameters2(captureAudio: true, captureVideo: true),
      );
      setState(() => _screenSharing = true);
    } catch (e) {
      debugPrint('Failed to start screen share: $e');
    }
  }

  Future<void> _stopScreenShare() async {
    try {
      await _engine.stopScreenCapture();
      setState(() => _screenSharing = false);
    } catch (e) {
      debugPrint('Failed to stop screen share: $e');
    }
  }

  void _onToggleMute() {
    setState(() => _muted = !_muted);
    _engine.muteLocalAudioStream(_muted);
  }

  void _onToggleVideo() {
    setState(() => _videoDisabled = !_videoDisabled);
    _engine.muteLocalVideoStream(_videoDisabled);

    // Also update local preview
    if (_videoDisabled) {
      _engine.stopPreview();
    } else {
      _engine.startPreview();
    }
  }

  Future<void> _onSwitchCamera() async {
    await _engine.switchCamera();
    setState(() => _usingFrontCamera = !_usingFrontCamera);
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Widget _renderRemoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            "Waiting for remote user...",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Widget _renderLocalPreview() {
    if (_videoDisabled) {
      return Container(
        color: Colors.grey[800],
        child: const Center(
          child: Icon(Icons.videocam_off, size: 48, color: Colors.white),
        ),
      );
    }
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote video (main view)
          _renderRemoteVideo(),

          // Local preview overlay
          if (_isJoined)
            Positioned(
              top: 40,
              right: 16,
              child: Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: _renderLocalPreview(),
                ),
              ),
            ),

          // User info
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Channel: ${widget.channelName}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Role: ${widget.type == ClientRoleType.clientRoleBroadcaster ? 'Host' : 'Audience'}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Remote Users: ${_remoteUids.length}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Control bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(_muted ? Icons.mic_off : Icons.mic),
                    color: Colors.white,
                    onPressed: _onToggleMute,
                  ),
                  IconButton(
                    icon: Icon(
                      _videoDisabled ? Icons.videocam_off : Icons.videocam,
                    ),
                    color: Colors.white,
                    onPressed: _onToggleVideo,
                  ),
                  IconButton(
                    icon: const Icon(Icons.cameraswitch),
                    color: Colors.white,
                    onPressed: _onSwitchCamera,
                  ),
                  if (widget.type == ClientRoleType.clientRoleBroadcaster)
                    IconButton(
                      icon: Icon(
                        _screenSharing
                            ? Icons.stop_screen_share
                            : Icons.screen_share,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        if (_screenSharing) {
                          _stopScreenShare();
                        } else {
                          _startScreenShare();
                        }
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.call_end, color: Colors.red),
                    onPressed: () {
                      _engine.leaveChannel();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
