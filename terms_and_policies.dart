import 'package:flutter/material.dart';

class TermsAndPoliciesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Policies"),
        backgroundColor: Color(0xFF50604E),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Terms and Conditions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "1. Introduction",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Welcome to PetCare! By using this app, you agree to comply with and be bound by the following terms and conditions. Please review them carefully.",
            ),
            SizedBox(height: 10),
            Text(
              "2. User Responsibilities",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "You agree to use the app responsibly, not to misuse the services, and to provide accurate and true information while booking appointments or setting up your pet’s profile.",
            ),
            SizedBox(height: 10),
            Text(
              "3. Privacy Policy",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "We respect your privacy and are committed to protecting your personal data. Please refer to our Privacy Policy to understand how we handle your data.",
            ),
            SizedBox(height: 10),
            Text(
              "4. Limitation of Liability",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "PetCare shall not be liable for any damages or loss incurred while using the app. This app provides scheduling and information services but does not replace professional veterinary advice.",
            ),
            SizedBox(height: 10),
            Text(
              "5. Changes to Terms",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "We may update these terms and policies from time to time. You are advised to review this page periodically for any changes. Continued use of the app after changes are made constitutes acceptance of those changes.",
            ),
            SizedBox(height: 20),
            Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "1. Data Collection",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "We collect data to improve your experience and ensure efficient service delivery. This includes your contact information, pet details, and appointment history.",
            ),
            SizedBox(height: 10),
            Text(
              "2. Data Usage",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Your data is used solely to facilitate app functionality, such as appointment management and reminders. We do not share your data with third parties without your consent.",
            ),
            SizedBox(height: 10),
            Text(
              "3. Data Security",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "We employ standard security measures to protect your data. However, please be aware that no method of electronic storage is 100% secure.",
            ),
            SizedBox(height: 10),
            Text(
              "Contact Us",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "If you have any questions or concerns about our terms or policies, please contact our support team.",
            ),
          ],
        ),
      ),
    );
  }
}
