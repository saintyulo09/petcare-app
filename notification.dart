import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<dynamic> notifications = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final url = 'http://rjsaintyulo09.helioho.st/petcare/api/get_appointments_notifications.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is List) {
          if (mounted) {
            setState(() {
              notifications = jsonResponse;
              isLoading = false;
              error = null;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              error = jsonResponse['error'] ?? "Unexpected error occurred.";
              isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            error = "Failed to load notifications";
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = "Error fetching data: $e";
          isLoading = false;
        });
      }
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    final url = 'http://rjsaintyulo09.helioho.st/petcare/api/delete_notification.php?id=$notificationId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            notifications.removeWhere((notification) => notification['id'] == notificationId);
          });
        }
      } else {
        print("Failed to delete notification");
      }
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Color(0xFF50604E),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : notifications.isEmpty
                  ? Center(child: Text("No upcoming appointments found"))
                  : ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        var notification = notifications[index];
                        return Dismissible(
                          key: Key(notification['id'].toString()),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Delete Notification"),
                                  content: Text("Are you sure you want to delete this notification?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) {
                            deleteNotification(notification['id']);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          child: NotificationCard(
                            title: notification['title'],
                            message: notification['message'],
                            createdAt: notification['created_at'],
                            details: notification,
                          ),
                        );
                      },
                    ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String createdAt;
  final Map<String, dynamic> details;

  NotificationCard({
    required this.title,
    required this.message,
    required this.createdAt,
    required this.details,
  });

  // Function to format `createdAt` to 'MMMM dd, yyyy h:mm a' format (AM/PM)
  String _formatDateTime(String dateTime) {
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return DateFormat('MMMM dd, yyyy h:mm a').format(parsedDate);
    } catch (e) {
      return dateTime; // Return the original format if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 5),
            Text(
              _formatDateTime(createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationDetailsPage(details: details),
            ),
          );
        },
      ),
    );
  }
}

class NotificationDetailsPage extends StatelessWidget {
  final Map<String, dynamic> details;

  NotificationDetailsPage({required this.details});

  String _formatDateTime(String dateTime) {
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return DateFormat('MMMM dd, yyyy h:mm a').format(parsedDate);
    } catch (e) {
      return dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Details"),
        backgroundColor: Color(0xFF50604E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title: ${details['title'] ?? 'No Title'}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Message: ${details['message'] ?? 'No Message'}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Contact: ${details['email'] ?? 'No Email'} - ${details['phone'] ?? 'No Phone'}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Created At: ${_formatDateTime(details['created_at'] ?? '')}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
