import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_offline/component/myText.dart';
import 'package:library_offline/route/pageroute.dart';
import 'package:library_offline/route/route_generater.dart';
import 'package:library_offline/utils/image.dart';
import '../database/table/user_profile_db.dart'; // Import your ProfileTable class
import 'package:lottie/lottie.dart';

import 'component/my_container.dart';
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Simulate a delay
    await Future.delayed(Duration(seconds: 3));

    try {
      ProfileTable profileTable = ProfileTable();
      List<Map<String, dynamic>> profiles = await profileTable.getProfile();
      print("cheaked ${profiles.first[ProfileTable.loginStatus]}");
      // Assuming there's only one user profile, or you want to check the first one
      if (profiles.isNotEmpty) {
        bool loginStatus = profiles.first[ProfileTable.loginStatus] == 1;
        print("cheaked ${loginStatus}");
        if (loginStatus) {
          Navigator.pushReplacementNamed(context, RoutePath.homeScreen);
        } else {
          Navigator.pushReplacementNamed(context, RoutePath.login);
        }
      } else {
        Navigator.pushReplacementNamed(context, RoutePath.login);
      }
    } catch (e) {
      print("Error checking login status: $e");
      Navigator.pushReplacementNamed(context, RoutePath.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/images/SplashAnimation.json",
                fit: BoxFit.contain, // Ensures the animation fits nicely within the screen
              ),
              SizedBox(
                height: 10.h,
              ),
              Column(
                children: [
                  Text(
                    'Library',
                    style: TextStyle(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
