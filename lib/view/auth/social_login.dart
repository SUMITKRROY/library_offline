import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../provider/Social login/social_login_bloc.dart';
import '../../route/pageroute.dart';


class SocialLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialLoginBloc, SocialLoginState>(
      builder: (context, state) {
        if (state is SocialLoginLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SocialLoginLoaded) {
          Navigator.pushReplacementNamed(context, RoutePath.homeScreen);
          return Center(
            child: Text("Welcome, ${state.userName}!"),
          );
        }

        if (state is SocialLoginError) {
          return Center(
            child: Text("Error: ${state.errorMessage}"),
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                context.read<SocialLoginBloc>().add(GoogleLoginEvent());
              },
              child: const CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 25,
                backgroundImage: AssetImage('assets/images/Google.png'),
              ),
            ),
            InkWell(
              onTap: () {
                //context.read<SocialLoginBloc>().add(GoogleLoginEvent());
              },
              child: const CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 25,
                backgroundImage: AssetImage('assets/images/truecaller.png'),
              ),
            ),
          ],
        );
      },
    );
  }
}

