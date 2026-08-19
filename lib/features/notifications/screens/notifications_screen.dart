import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      "id": 1,
      "title": "New Invoice Synced",
      "body": "Invoice #1245 has been successfully synced.",
      "time": "2 min ago",
      "icon": Icons.cloud_done,
      "color": Colors.green,
    },
    {
      "id": 2,
      "title": "Customer Updated",
      "body": "Customer 'Al-Sabah Market' updated their phone number.",
      "time": "10 min ago",
      "icon": Icons.person,
      "color": Colors.blue,
    },
    {
      "id": 3,
      "title": "Low Stock Warning",
      "body": "Milk Chocolate 85g is below minimum stock.",
      "time": "1 hour ago",
      "icon": Icons.warning_amber_rounded,
      "color": Colors.orange,
    },
    {
      "id": 4,
      "title": "Sync Failed",
      "body": "Could not sync visits. Try again later.",
      "time": "Yesterday",
      "icon": Icons.error,
      "color": Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final n = notifications[index];

          return Dismissible(
            key: Key(n["id"].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),

            onDismissed: (_) {
              setState(() {
                notifications.removeAt(index);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Notification deleted"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },

            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              elevation: 1,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: n["color"].withOpacity(0.15),
                  child: Icon(n["icon"], color: n["color"], size: 26),
                ),
                title: Text(
                  n["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    n["body"],
                    style: TextStyle(color: Colors.grey.shade700, height: 1.3),
                  ),
                ),
                trailing: Text(
                  n["time"],
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
