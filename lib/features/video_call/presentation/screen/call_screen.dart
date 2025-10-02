// lib/presentation/screens/call_screen.dart
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_calling/core/utils/constants/app_constants.dart';

class CallScreen extends StatefulWidget {
  final String channelName;
  final String callerId;
  final String? calleeId;
  const CallScreen({
    super.key,
    required this.channelName,
    required this.callerId,
    this.calleeId,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late RtcEngine _engine;
  int? _remoteUid;

  bool _muted = false;
  bool _videoDisabled = false;
  bool _screenSharing = false;
  bool _usingFrontCamera = true;

  static const int localUid = 0; // main camera track
  static const int screenShareUid = 99; // unique UID for screen sharing

  @override
  void initState() {
    super.initState();
    _handlePermissions();
    _initAgora();
  }

  Future<void> _handlePermissions() async {
    await [Permission.camera, Permission.microphone].request();
  }

  Future<void> _initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(appId: AppConstants.agoraAppId),
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          if (_remoteUid == remoteUid) {
            setState(() {
              _remoteUid = null;
            });
          }
        },
      ),
    );

    await _engine.enableVideo();
    await _joinMainChannel();
  }

  Future<void> _joinMainChannel() async {
    await _engine.joinChannelWithUserAccount(
      token: "",
      channelId: widget.channelName,
      userAccount: widget.callerId, // Use callerId as userAccount
      options: const ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> _startScreenShare() async {
    await _engine.joinChannelWithUserAccountEx(
      token: "",
      channelId: widget.channelName,
      userAccount: widget.callerId,
      options: const ChannelMediaOptions(
        autoSubscribeVideo: false,
        autoSubscribeAudio: false,
        publishCameraTrack: false,
        publishMicrophoneTrack: false,
        publishScreenCaptureAudio: true,
        publishScreenCaptureVideo: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
    setState(() => _screenSharing = true);
  }

  Future<void> _stopScreenShare() async {
    await _engine.stopScreenCapture();
    setState(() => _screenSharing = false);
  }

  void _onToggleMute() {
    setState(() => _muted = !_muted);
    _engine.muteLocalAudioStream(_muted);
  }

  void _onToggleVideo() {
    setState(() => _videoDisabled = !_videoDisabled);
    _engine.muteLocalVideoStream(_videoDisabled);
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
      return const Center(child: Text("Waiting for remote user..."));
    }
  }

  Widget _renderLocalPreview() {
    if (_videoDisabled) {
      return const Center(child: Icon(Icons.videocam_off, size: 48));
    }
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: localUid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _renderRemoteVideo(),

          // Local preview overlay
          Positioned(
            top: 24,
            left: 16,
            child: SizedBox(
              width: 120,
              height: 160,
              child: _renderLocalPreview(),
            ),
          ),

          // Control bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              color: Colors.black54,
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

          // Caller and callee info
          // Positioned(
          //   top: 50,
          //   left: 16,
          //   child: Column(
          //     children: [
          //       Text("Caller: ${widget.callerId}"),
          //       Text("Callee: ${widget.calleeId}"),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
