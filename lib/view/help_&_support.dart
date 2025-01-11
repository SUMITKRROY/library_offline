import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({Key? key}) : super(key: key);

  // Function to launch mail app
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  // Function to launch call
  Future<void> _launchCall(String phoneNumber) async {
    final Uri callUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    const String ownerEmail = 'owneremail@domain.com'; // Replace with your email
    const String ownerPhone = '+911234567890'; // Replace with your phone number

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help and Support',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.withOpacity(0.8), // 80% opacity
              Colors.black, // Full black
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // AppBar Replacement

              const SizedBox(height: 20),
              // Company Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/resent.png', // Replace with your logo path
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Company Name
              const Text(
                'Your Company Name',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Owner Name
              const Text(
                'Owner: John Doe', // Replace with owner's name
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              // Email Address with launcher
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email, color: Colors.white),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _launchEmail(ownerEmail),
                    child: Text(
                      ownerEmail,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Contact Number with launcher
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, color: Colors.white),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _launchCall(ownerPhone),
                    child: Text(
                      ownerPhone,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Support Message
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'If you have any questions or need further assistance, please feel free to contact us!',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
