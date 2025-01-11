import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_offline/component/myText.dart';
import 'package:library_offline/component/myTextForm.dart';
import 'package:library_offline/component/mybutton.dart';
import 'package:library_offline/route/pageroute.dart';
import 'package:library_offline/utils/utils.dart';
import 'package:uuid/uuid.dart';
import '../../database/table/user_profile_db.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _userId = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _totalSeats = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  Map<String, dynamic> appDetailSet = {};
  bool _isLoading = false; // Loading state


  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed to prevent memory leaks
    _name.dispose();
    _userId.dispose();
    _phone.dispose();
    _email.dispose();
    _totalSeats.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

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
                Colors.deepPurple.withOpacity(0.8),
                Colors.black,
              ],
              begin: Alignment.topCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBackground(),
                  _buildFormSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Background section with gradient and welcome message
  Widget _buildBackground() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome,',
          style: TextStyle(
            fontSize: 30.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'to our library!',
          style: TextStyle(
            fontSize: 25.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Form section with input fields and buttons
  Widget _buildFormSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 30.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildNameField(),
            SizedBox(height: 20.sp),
            _buildPhoneField(),
            SizedBox(height: 20.sp),
            _buildTotalSeatsField(),
            SizedBox(height: 20.sp),
            _buildSaveButton(),
            // SizedBox(height: 20.sp),
            // _buildAccountNavigation(),
          ],
        ),
      ),
    );
  }

  // Name input field
  Widget _buildNameField() {
    return MyTextForm(
      label: 'Name',
      controller: _name,
      keyboardType: TextInputType.text,
      validator: true,
      validatorFunc: Utils.validateUserName(),
      onChanged: (String ) {  },
    );
  }

  // Phone number input field
  Widget _buildPhoneField() {
    return MyTextForm(
      label: 'Phone Number',
      controller: _phone,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      keyboardType: TextInputType.phone,
        validator: true,
        validatorFunc: Utils.phoneValidator(), onChanged: (String ) {  },
    );
  }

  // Total seats input field
  Widget _buildTotalSeatsField() {
    return MyTextForm(
      label: 'Total Seats',
      controller: _totalSeats,
      inputFormatters: [
        LengthLimitingTextInputFormatter(3),
      ],
      keyboardType: TextInputType.number,
          validator: true,

      onChanged: (String ) {  },
    );
  }

  // Save button
  Widget _buildSaveButton() {
    return  _isLoading
        ? CircularProgressIndicator() // Show loading indicator
        :MyButton(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isLoading = true; // Start loading
          });
          appTableSet(context);
          setState(() {
            _isLoading = false; // Stop loading
          });
        }
      },
      text: "Save",
      textColor: Colors.white,
      color: Color(0xffBC30AA).withOpacity(0.7),
      width: double.infinity,
      height: 50.h,
    );
  }

  // Account navigation link
  Widget _buildAccountNavigation() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Navigator.pushReplacementNamed(context, RoutePath.login);
            },
            child: MyText(
              label: "Already have an account?",
              fontColor: Color(0xff63A6DC),
              fontSize: 22.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccountRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Exiting User? ",
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
          onTap: () {

          },
          child: const Text(
            "Login",
            style: TextStyle(
                color: Colors.purpleAccent, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
  // Method to save form data to the database
  void appTableSet(BuildContext context) async {
    try {
      appDetailSet[ProfileTable.userId] = "123";
      appDetailSet[ProfileTable.name] = _name.text;
      appDetailSet[ProfileTable.phone] = _phone.text;
      appDetailSet[ProfileTable.totalSeats] = int.tryParse(_totalSeats.text) ?? 0;
      appDetailSet[ProfileTable.loginStatus] = 1;

      // Call insert method with profile data and context for navigation
      await ProfileTable().insert(appDetailSet, context);
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}
