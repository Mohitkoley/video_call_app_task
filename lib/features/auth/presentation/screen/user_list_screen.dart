// presentation/users/users_list_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
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
                        user.isOnline ? Icons.circle : Icons.circle_outlined,
                        color: user.isOnline ? Colors.green : Colors.grey,
                        size: 14,
                      ),
                      if (user.isOnline)
                        IconButton(
                          icon: const Icon(
                            Icons.video_call,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CallScreen(
                                  channelName: user.defaultChannel,
                                  callerId: widget.currentUserId,
                                  calleeId: user.uid,
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
}
