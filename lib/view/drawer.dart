import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../database/table/user_profile_db.dart';
import '../route/pageroute.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? _currentUser;
  String userName = ""; // Default name, will be updated from the database
  String userId = "";
  List<Map<String, dynamic>> profile = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserName();
  }

  // Function to fetch user name from the database
  Future<void> _fetchUserName() async {
    ProfileTable profileTable = ProfileTable();
    var data = await profileTable.getProfile();
    setState(() {
      profile = data;
      userName = profile.first['Name'] ?? "User Name"; // Update userName from the profile
      userId = profile.first['UserId'] ?? "userId"; // Update userName from the profile
      print("user id $userId");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:   Colors.deepPurple,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color:   Colors.deepPurple.withOpacity(0.8),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/Profile.gif"),
                ),
                SizedBox(height: 10),
                Text(
                  userName,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // Navigate to home screen if not already there
            },
          ),
          ListTile(
            leading: Icon(Icons.person_3_rounded, color: Colors.white),
            title: Text('Profile', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, RoutePath.profile);
            },
          ),
          ListTile(
            leading: Icon(Icons.picture_as_pdf, color: Colors.white),
            title: Text('pdf screen', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pushNamed(context, RoutePath.pdfPage);
              // Navigate to home screen if not already there
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, RoutePath.settings);
            },
          ),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Handle logout action
              _signOut();

            },
          ),
        ],
      ),
    );
  }
  Future<void> _signOut() async {
    try {
      // Sign out from Google and Firebase
      await googleSignIn.signOut();
      await firebaseAuth.signOut();

      // Clear current user info
      setState(() {
        _currentUser = null;
      });
      List<Map<String, dynamic>> profiles = await ProfileTable().getProfile();
      print("cheaked ${profiles.first[ProfileTable.loginStatus]}");
      String   userId = profiles.first[ProfileTable.userId];
      // Update login status in the database
      await ProfileTable().updateLoginStatus(  userId: userId, status: false);

      // Navigate to login page after sign-out and status update
      Navigator.pushReplacementNamed(context, RoutePath.login);
    } catch (e) {
      print("Error during sign out: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error during sign out: $e")));
    }
  }

}
