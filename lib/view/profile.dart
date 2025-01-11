import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../component/my_container.dart';
import '../component/mybutton.dart';
import '../database/table/user_profile_db.dart';
import '../route/pageroute.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>> profileData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProfileData();
  }

  // Fetch profile data from the database
  Future<void> _getProfileData() async {
    try {
      ProfileTable profileTable = ProfileTable();
      var data = await profileTable.getProfile();

      setState(() {
        profileData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching profile data: $e");
    }
  }

  // Handle logout functionality
  Future<void> _handleLogout() async {
    if (profileData.isNotEmpty) {
      try {
        ProfileTable profileTable = ProfileTable();
        final userId = profileData.first[ProfileTable.userId];

        if (userId != null) {
          await profileTable.updateLoginStatus(userId: userId, status: false);
          Navigator.pushReplacementNamed(context, RoutePath.login);
        }
      } catch (e) {
        print("Error during logout: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 18.sp, color: Colors.white),
        ),
      ),
      body: GradientContainer(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : profileData.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileRow("Name", profileData.first[ProfileTable.name] ?? ""),
              _buildProfileRow("Phone", profileData.first[ProfileTable.phone] ?? ""),
              _buildProfileRow("Email", profileData.first[ProfileTable.email] ?? ""),
              _buildProfileRow(
                  "Total Seats", profileData.first[ProfileTable.totalSeats]?.toString() ?? "0"),
              const SizedBox(height: 30),
              Center(
                child: MyButton(
                  onTap: _handleLogout,
                  text: "Logout",
                  textColor: Colors.white,
                  color: const Color(0xffBC30AA).withOpacity(0.7),
                  width: double.infinity,
                  height: 50.h,
                ),
              ),
            ],
          ),
        )
            : Center(
          child: Text(
            'No profile data found',
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Helper method to build profile data rows
  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.white),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
