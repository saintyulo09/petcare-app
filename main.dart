import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '/pages/calendar.dart';
import '/pages/pets.dart';
import '/pages/book.dart';
import '/pages/profile.dart';
import '/pages/settings.dart';
import '/pages/notification.dart';

void main() {
  runApp(PetCareApp());
}

class PetCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PetCareHome(),
      theme: ThemeData(
        primaryColor: Color(0xFF50604E),
      ),
    );
  }
}

class PetCareHome extends StatefulWidget {
  @override
  _PetCareHomeState createState() => _PetCareHomeState();
}

class _PetCareHomeState extends State<PetCareHome> {
  int _selectedIndex = 0;
  List _stories = [];
  List _upcomingAppointments = [];

  @override
  void initState() {
    super.initState();
    _fetchStories();
    _fetchUpcomingAppointments();
  }

  Future<void> _fetchStories() async {
    final url = 'http://rjsaintyulo09.helioho.st/petcare/api/get_stories.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _stories = data;
        });
      } else {
        print("Failed to load stories");
      }
    } catch (e) {
      print("Error fetching stories: $e");
    }
  }

  Future<void> _fetchUpcomingAppointments() async {
    final currentDate = DateTime.now();
    final url = 'http://rjsaintyulo09.helioho.st/petcare/api/get_appointments.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _upcomingAppointments = data.where((appointment) {
            DateTime appointmentDate = DateTime.parse(appointment['appointment_date']);
            return appointmentDate.isAfter(currentDate) || appointmentDate.isAtSameMomentAs(currentDate);
          }).toList();
        });
      } else {
        print("Failed to load appointments");
      }
    } catch (e) {
      print("Error fetching appointments: $e");
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarPage()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => BookAppointmentPage()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PetsPage()));
    } else if (index == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
    } else if (index == 0) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('MMMM dd, yyyy').format(parsedDate);
  }

  String _formatTime(String time) {
    final parsedTime = DateFormat("HH:mm:ss").parse(time);
    return DateFormat("h:mm a").format(parsedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color(0xFF50604E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Title Section
          Container(
            color: Color(0xFF50604E),
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                Text(
                  'PetCare',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'brave ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Icon(Icons.pets, color: Colors.white),
                    Text(
                      ' friends',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Display stories
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _stories.length,
              itemBuilder: (context, index) {
                var story = _stories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryViewer(
                          stories: _stories,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                          'http://rjsaintyulo09.helioho.st/petcare/${story['image_url']}'),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'UPCOMING APPOINTMENTS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 31, 31, 31),
                ),
              ),
            ),
          ),
          Expanded(
            child: _upcomingAppointments.isEmpty
                ? Center(
                    child: Text(
                      "No upcoming appointments found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _upcomingAppointments.length,
                    itemBuilder: (context, index) {
                      var appointment = _upcomingAppointments[index];
                      return AppointmentCard(
                        petName: appointment['full_name'],
                        concern: appointment['concern'],
                        phone: appointment['phone'],
                        email: appointment['email'],
                        appointmentDate: _formatDate(appointment['appointment_date']),
                        appointmentTime: _formatTime(appointment['appointment_time']),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF50604E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String petName;
  final String concern;
  final String phone;
  final String email;
  final String appointmentDate;
  final String appointmentTime;

  AppointmentCard({
    required this.petName,
    required this.concern,
    required this.phone,
    required this.email,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              petName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text("Concern: $concern"),
            Text("Phone: $phone"),
            Text("Email: $email"),
            Text("Appointment Date: $appointmentDate"),
            Text("Appointment Time: $appointmentTime"),
          ],
        ),
      ),
    );
  }
}

class StoryViewer extends StatefulWidget {
  final List stories;
  final int initialIndex;

  StoryViewer({required this.stories, required this.initialIndex});

  @override
  _StoryViewerState createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pop(context); // Close viewer if it's the last story
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.stories.length,
            itemBuilder: (context, index) {
              var story = widget.stories[index];
              return GestureDetector(
                onTap: _nextStory,
                child: Center(
                  child: Image.network(
                    'http://rjsaintyulo09.helioho.st/petcare/${story['image_url']}',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
