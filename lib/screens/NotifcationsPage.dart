import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/NotificatioCubit.dart';
import '../model/NotificationModel.dart';
import '../states/NotificationState.dart';

class Notifcationspage extends StatefulWidget {
  const Notifcationspage({Key? key}) : super(key: key);

  @override
  State<Notifcationspage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<Notifcationspage> {
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'تحديد الكل كمقروء',
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationFailure) {
            return Center(child: Text(state.message));
          } else if (state is NotificationSuccess) {
            _notifications = state.notifications;

            if (_notifications.isEmpty) return _buildEmptyState();

            return RefreshIndicator(
              onRefresh: _refreshNotifications,
              child: ListView.separated(
                padding: const EdgeInsets.all(8.0),
                itemCount: _notifications.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return _buildNotificationItem(notification);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_off, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('لا توجد إشعارات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('ستظهر الإشعارات الجديدة هنا', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _refreshNotifications,
            child: const Text('تحديث'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Dismissible(
      key: Key(notification.id.toString()),
      background: Container(
        alignment: AlignmentDirectional.centerStart,
        color: Colors.blue,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Icon(Icons.mark_email_read, color: Colors.white),
        ),
      ),
      secondaryBackground: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _toggleReadStatus(notification);
          return false;
        }
        _removeNotification(notification);
        return true;
      },
      child: ListTile(
        // ✅ نزيل leading
        title: Row(
          children: [
          // Icon(Icons.notifications, color: Colors.blueGrey),
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight:
                  notification.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),


          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.message, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        tileColor: notification.isRead ? null : Colors.blue.withOpacity(0.05),
        trailing: IconButton(
          icon: Icon(
            notification.isRead ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[600],
          ),
          onPressed: () => _toggleReadStatus(notification),
        ),
      ),
    );
  }

  Future<void> _refreshNotifications() async {
    await context.read<NotificationCubit>().fetchNotifications();
  }

  void _toggleReadStatus(NotificationModel notification) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] = NotificationModel(
          id: notification.id,
          title: notification.title,
          message: notification.message,
          isRead: !notification.isRead,
          createdAt: notification.createdAt,
        );
      }
    });
  }

  void _removeNotification(NotificationModel notification) {
    setState(() {
      _notifications.removeWhere((n) => n.id == notification.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حذف الإشعار'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'تراجع',
          onPressed: () {
            setState(() => _notifications.add(notification));
            _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          },
        ),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map((n) => NotificationModel(
        id: n.id,
        title: n.title,
        message: n.message,
        isRead: true,
        createdAt: n.createdAt,
      ))
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تحديد جميع الإشعارات كمقروءة'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
    return '${time.day}/${time.month}/${time.year}';
  }
}
