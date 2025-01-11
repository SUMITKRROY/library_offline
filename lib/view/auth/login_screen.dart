import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../component/myTextForm.dart';
import '../../component/mybutton.dart';
import '../../database/table/user_profile_db.dart';
import '../../route/pageroute.dart';
import '../../utils/image.dart';
import '../../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.withOpacity(0.8), // 80% opacity
                Colors.black // 60% opacity
              ],
              begin: Alignment.topCenter,
            ),
          ),
          child: Center( // Ensures everything is centered vertically and horizontally
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
              children: [
                _buildHeader(),
                _buildLoginForm(context),
              ],
            ),
          ),
        ),
      ),

    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.purpleAccent,
      onPressed: _showHelpAndSupportBottomSheet,
      child: const Icon(Icons.help_outline, color: Colors.white),
    ),
    );
  }

  Widget _buildHeader() {
    return Text(
      "Login",
      style: TextStyle(
        color: Colors.white,
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 30.h),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEmailField(),
              SizedBox(height: 20.sp),
              _buildPasswordField(),
              SizedBox(height: 20.sp),
              _buildLoginButton(context),
              // SizedBox(height: 20.sp),
              // SocialLogin(),
              SizedBox(height: 20.sp),
              _buildCreateAccountRow(context),
              SizedBox(height: 20.sp,),
              //_otherFeature(context)
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildSafeLogin(BuildContext context){
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      SizedBox(height: 20.h),
                      MyTextForm(
                        label: "Email",
                        controller: _emailController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                        ],
                        keyboardType: TextInputType.emailAddress,
                        validator: true,
                        validatorFunc: Utils.emailValidator(),
                        prefix: const Icon(Icons.email, color: Colors.white),
                        onChanged: (String) {},
                      ),
                      SizedBox(height: 20.h),
                      MyTextForm(
                        label: "Password",
                        controller: _passwordController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(16),
                        ],
                        keyboardType: TextInputType.text,
                        validator: true,
                        validatorFunc: Utils.passwordValidator(),
                        validatorLabel: "Password",
                        prefix: const Icon(Icons.password, color: Colors.white),
                        onChanged: (String) {},
                      ),


                      SizedBox(height: 20.h),
                      MyButton(
                          onTap: (){} ,
                          text: "Log In",
                          textColor: Colors.white,
                          color: Color(0xffBC30AA).withOpacity(0.7),
                          width: double.infinity,
                          height: 50.h
                      ),
                      SizedBox(height: 20.sp),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "New User? ",
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: const Text(
                              "Create an account",
                              style: TextStyle(
                                  color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 150.h),
                         Image.asset("assets/images/headset.png"),
                      SizedBox(
                        height: 5.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Support Action
                        },
                        child: Text(
                          "Need Support",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16.sp,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),

    );

}

  Widget _buildEmailField() {
    return    MyTextForm(
      label: "Email",
      controller: _emailController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
      ],
      keyboardType: TextInputType.emailAddress,
      validator: true,
      validatorFunc: Utils.emailValidator(),
      prefix: const Icon(Icons.email, color: Colors.white),
      onChanged: (String) {},
    );
  }

  Widget _buildPasswordField() {
    return   MyTextForm(
      label: "Password",
      controller: _passwordController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(16),
      ],
      keyboardType: TextInputType.text,
      validator: true,
      validatorFunc: Utils.passwordValidator(),
      validatorLabel: "Password",
      prefix: const Icon(Icons.lock, color: Colors.white),
      onChanged: (String) {},
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator() // Show loading indicator
        : MyButton(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isLoading = true; // Start loading
          });

          bool isAuthorized = await _login(_emailController.text, _passwordController.text);

          if (isAuthorized) {
            await _checkDatabaseAndNavigate(context);
          } else {
            _showSnackbar(context, 'You are not authorized');
          }
          setState(() {
            _isLoading = false; // Stop loading
          });
        }
      },
      text: "Log In",
      textColor: Colors.white,
      color: Color(0xffBC30AA).withOpacity(0.7),
      width: double.infinity,
      height: 50.h,
    );
  }

  Widget _otherFeature(BuildContext context) {
    return Column(
      children: [
      //  SizedBox(height: 150.h),
        Image.asset(
          ImagePath.headset,
          // height: 250.h,
          // width: 250.h,
        ),
        SizedBox(
          height: 5.h,
        ),
        GestureDetector(
          onTap: () {
            // Support Action
          },
          child: Text(
            "Need Support",
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 16.sp,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "New User? ",
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
          onTap: () {

          },
          child: const Text(
            "Create an account",
            style: TextStyle(
                color: Colors.purpleAccent, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Future<bool> _login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
  void _showHelpAndSupportBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.deepPurple.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Need Help?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutePath.helpAndSupport);
                },
                icon: const Icon(Icons.help, color: Colors.white),
                iconSize: 40.sp,
              ),
              Text(
                'Go to Help and Support',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _checkDatabaseAndNavigate(BuildContext context) async {
    ProfileTable profileTable = ProfileTable();
    try {
      List<Map<String, dynamic>> userData = await profileTable.getProfile();
      String   userId = userData.first[ProfileTable.userId];
      if (userData.isEmpty) {
        Navigator.pushNamed(context, RoutePath.register);
        _showSnackbar(context, 'No data found. Redirecting to Register Page');
      } else {
        await ProfileTable().updateLoginStatus(  userId: userId, status: true);
        Navigator.pushNamed(context, RoutePath.homeScreen);
        _showSnackbar(context, 'Login Successful');
      }
    } catch (e) {
      print("Error checking database: $e");
      _showSnackbar(context, 'Error: $e');
      Navigator.pushReplacementNamed(context, RoutePath.register);
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
