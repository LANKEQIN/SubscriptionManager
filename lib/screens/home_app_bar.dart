import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import 'notifications_screen.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingSubscriptions = ref.watch(upcomingSubscriptionsProvider);
    final hasUnreadNotifications = ref.watch(hasUnreadNotificationsProvider);
    
    final upcomingCount = upcomingSubscriptions.length;
    final hasUnread = hasUnreadNotifications && upcomingCount > 0;
    
    return AppBar(
      title: const Text('会员制管理'),
      centerTitle: false,
      actions: [
        // 提醒铃铛图标
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // 标记提醒为已读
                ref.read(subscriptionProvider.notifier).markNotificationsAsRead();
                // 导航到提醒页面
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            if (hasUnread)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${upcomingCount > 99 ? '99+' : upcomingCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        // 用户头像
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person_outline,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}