import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:library_offline/component/myText.dart';
import 'package:library_offline/route/pageroute.dart';
import 'package:library_offline/route/route_generater.dart';
import 'package:library_offline/utils/image.dart';
import 'package:library_offline/view/drawer.dart';
import '../component/my_container.dart';
import '../database/table/user_profile_db.dart';
import '../provider/member_details/member_details_bloc.dart';
import '../provider/member_details/member_details_event.dart';
import '../provider/member_details/member_details_state.dart';
import 'auth/login_screen.dart';
import 'member detail/member.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {




  bool _isLoading = false;
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;


  final Map<String, dynamic> product = {
    "library": {
      "banner": [
        {"img_url": "assets/banner/1st.jpg"},
        {"img_url": "assets/banner/2nd.jpg"},
        {"img_url": "assets/banner/3rd.jpg"},
        {"img_url": "assets/banner/4th.jpg"},
      ],
    }
  };

  final Map<String, dynamic> grid_Details = {
    "Card_Name": [
      {
        "img": ImagePath.active,
        "heading": "Active user",
      },
      {
        "img": ImagePath.allUser,
        "heading": "All user",
      },
      {
        "img": ImagePath.inactive,
        "heading": "Inactive user",
      },
      {
        "img": ImagePath.account,
        "heading": "Account",
      },
      {
        "img": ImagePath.addMember,
        "heading": "Add user",
      },
    ]
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
    BlocProvider.of<MemberBloc>(context).add(FetchMembersEvent(index: 3));
     // Fetch the user name when the screen initializes
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }




  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < product['library']['banner']-1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
       // backgroundColor: Colors.deepPurple.withOpacity(0.8),
        elevation: 0.0,
        title:
            MyText(label: "My Library", fontSize: 24, fontColor: Colors.white),

            actions: [
              // BlocBuilder to rebuild the IconButton when state changes
              BlocBuilder<MemberBloc, MemberState>(
                builder: (context, state) {
                  if (state is MemberLoading) {
                    return IconButton(
                      onPressed: null,
                      icon: CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (state is MemberTotalCollectionSuccess) {
                    final totalCollection = state.totalCollection; // Total of all active members
                    return IconButton(
                      onPressed: () {
                        // Define the desired action here
                      },
                      icon: Row(
                        children: [
                          Icon(Icons.wallet_outlined),
                          SizedBox(width: 5),
                          Text(
                            "$totalCollection",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Default state
                    return IconButton(
                      onPressed: null,
                      icon: Icon(Icons.wallet_outlined),
                    );
                  }
                },
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutePath.reminderPage);
                },
                icon: Icon(Icons.notifications_active),
              ),
            ],


      ),
      drawer: MyDrawer(),
      body: GradientContainer(
        child: Column(
          children: [
            Container(
              height: 150.h,
              child: PageView.builder(
                controller: _pageController,
                itemCount: product['library']['banner'].length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    product['library']['banner'][index]['img_url'],
                    fit: BoxFit.cover,
                  );
                },
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
              ),
            ),
            SizedBox(height:10.h),
            MyText(
              label: "My Service",
              fontSize: 24,
              fontColor: Colors.white,
              alignment: true,
            ),
            SizedBox(height:10.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: grid_Details['Card_Name'].length,
                itemBuilder: (context, index) {
                  String gridTitle =
                      grid_Details['Card_Name'][index]['heading'];
                 String gridImage =     grid_Details['Card_Name'][index]['img'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        if (index == 3) {
                          Navigator.pushNamed(
                            context,
                            RoutePath.totalCollection,
                          );
                        } else if (index == 4) {

                          Navigator.pushNamed(context, RoutePath.bookSeats);
                        } else {
                          Navigator.pushNamed(
                            context,
                            RoutePath.memberScreen,
                            arguments: MemberScreen(
                              title: gridTitle,
                              index: index,
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage(gridImage), // Provide the image path here
                            fit: BoxFit.cover, // Adjust how the image is displayed (cover, contain, etc.)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white12,
                            width: 1.0,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5), // Black background with 50% opacity
                              borderRadius: BorderRadius.circular(4.0), // Optional: Rounded corners
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Add padding for spacing
                            child:  MyText(
                              label: gridTitle,
                              fontSize: 14.sp,
                              fontColor: Colors.white, // White text color
                              alignment: true,
                            ),
                          ),
                        ),

                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }



}


