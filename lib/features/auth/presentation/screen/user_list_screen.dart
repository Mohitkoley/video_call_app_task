// presentation/users/users_list_screen.dart
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_calling/core/utils/constants/app_constants.dart';
import 'package:video_calling/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:video_calling/features/video_call/presentation/screen/call_screen.dart';

@RoutePage()
class UsersListScreen extends StatefulWidget {
  final String currentUserId;
  const UsersListScreen({super.key, required this.currentUserId});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(LoadUsers());
      _handlePermissions();
    });
  }

  Future<void> _handlePermissions() async {
    await [Permission.camera, Permission.microphone].request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      // create new call
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // create a new call with a random channel name
          context.read<AuthBloc>().add(
            UpdateUserEvent(
              data: {
                "defaultChannel": AppConstants.channelName,
                "isOnline": true,
              },
            ),
          );
          String newChannel = "channel_${widget.currentUserId}";
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CallScreen(
                channelName: AppConstants.channelName,
                uid: widget.currentUserId,
                type: ClientRoleType.clientRoleBroadcaster,
                // placeholder, no specific callee
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            final users = state.users
                .where((u) => u.uid != widget.currentUserId)
                .toList();
            if (users.isEmpty) {
              return const Center(child: Text("No other users"));
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, i) {
                final user = users[i];
                return ListTile(
                  leading: CircleAvatar(child: Text(user.displayName[0])),
                  title: Text(user.displayName),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        user.isHost ? Icons.circle : Icons.circle_outlined,
                        color: user.isHost ? Colors.green : Colors.grey,
                        size: 14,
                      ),
                      if (user.defaultChannel != null)
                        IconButton(
                          icon: const Icon(
                            Icons.video_call,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            String sharedChannel = getSharedChannel(
                              widget.currentUserId,
                              user.uid,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CallScreen(
                                  channelName: AppConstants.channelName,
                                  uid: widget.currentUserId,
                                  type: ClientRoleType.clientRoleAudience,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            );
          } else if (state is AuthFailure) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }

  String getSharedChannel(String id1, String id2) {
    List<String> ids = [id1, id2];
    ids.sort(); // ensure order is consistent
    return ids.join("_"); // e.g., "az8aMRfoZgcOisoNL5kY67i6nSy2_uid2"
  }
}
