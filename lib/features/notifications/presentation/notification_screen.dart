import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/notifications/presentation/view_model/notification_view_model.dart';
import 'package:yumm_ai/features/notifications/presentation/widgets/notification_item.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  late ScrollController _scrollController;

  void _loadNotifications({bool forceRefresh = false}){
    final currentState = ref.read(notificationViewModelProvider);
    if(!forceRefresh && currentState.notifications.isNotEmpty){
      return;
    }
    ref.read(notificationViewModelProvider.notifier).fetchNotifications(isRefresh: forceRefresh || currentState.notifications.isEmpty);
  }

  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_)=>_loadNotifications());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(notificationViewModelProvider);
      if (!state.isLoading && state.hasMore) {
        ref.read(notificationViewModelProvider.notifier).fetchNotifications();
      }
    }
  }
  

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadNotifications(forceRefresh: true);
          },
          child: Builder(
            builder: (context) {
              if (state.isLoading && state.notifications.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null && state.notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "Failed to load notifications: ${state.error}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(notificationViewModelProvider.notifier)
                              .fetchNotifications(isRefresh: true);
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              if (state.notifications.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "No notifications yet",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount:
                    state.notifications.length + (state.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.notifications.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final notification = state.notifications[index];
                  return NotificationItem(notification: notification);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
