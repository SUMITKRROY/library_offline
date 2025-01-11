import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class Utils {
  //dialog
  static showLoadingProgress(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ));

  }

  static String getFormattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy'); // Customize the format
    return formatter.format(date);
  }

  static showDialogBox({
    required BuildContext context,
    required String label,
    required String content,
    required Function()? onPressedClose,
    required Function()? onPressedOk,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(label),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: onPressedClose,
            child: Text('Close'),
          ),
          TextButton(
            onPressed: onPressedOk,
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  static NotAvailableDialogBox(
      BuildContext context, String label, String content) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          label,
          style: TextStyle(fontSize: 20.sp),
        ),
        content: Text(
          content,
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }

  static Function emailValidator() {
    return (String? value) {
      RegExp regex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (value == null || value.isEmpty) {
        return "Email is required";
      } else if (!regex.hasMatch(value)) {
        return "Enter a valid email address";
      }
      return null;
    };
  }


  // Validator for User ID in the format "NAME04"
  static Function userIdValidator() {
    return (String? value) {
      RegExp regex = RegExp(r'^[A-Za-z]+\d{2}$');
      if (value == null || value.isEmpty) {
        return "User ID is required";
      } else if (!regex.hasMatch(value)) {
        return "User ID must be in the format Name45 (e.g., Sumit45)";
      }
      return null;
    };
  }



  static Function passwordValidator() {
    return (String? value) {
      RegExp regex = RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
      if (value == null || value.isEmpty) {
        return "Password is required";
      } else if (value.length < 8) {
        return "Password must be more than 7 characters";
      } else if (!regex.hasMatch(value)) {
        return "Password should contain upper, lower, digit, and special character";
      }
      return null;
    };
  }

  static Function validateUserName() {
    return (String? value) {
      RegExp regex = RegExp(r'^[a-zA-Z]');

      if (value == null || value.isEmpty) {
        return "Name is required";
      } else if (value.length < 3) {
        return "Name must be more than 2 characters";
      } else if (!regex.hasMatch(value)) {
        return "Name should only contain letters";
      }

      return null;
    };
  }

  static Function phoneValidator() {
    return (String? value) {
      RegExp regex =
          RegExp(r'^[0-9]{10}$'); // Assuming a 10-digit phone number format

      if (value == null || value.isEmpty) {
        return "Phone number is required";
      } else if (!regex.hasMatch(value)) {
        return "phone number must be 10 digit";
      }

      return null;
    };
  }

  // //converter
  // static String convertToMD5(String data) {
  //   // Convert the input string to bytes
  //   List<int> bytes = utf8.encode(data);
  //
  //   // Generate the MD5 hash
  //   Digest md5Result = md5.convert(bytes);
  //
  //   // Convert the result to a hexadecimal string
  //   String md5String = md5Result.toString();
  //   log("md5String : $md5String");
  //   return md5String;
  // }

  static String convertToBase64(String data) {
    String base64String = base64.encode(utf8.encode(data));
    return base64String;
  }

  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Widget getSizedBoxHeight(double height) {
    return SizedBox(height: height);
  }

  // static snackbarToast(String msg) {
  //   Fluttertoast.showToast(
  //       msg: msg,
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //       textColor: Colors.white,
  //       fontSize: 20.sp);
  // }
}
