import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:library_offline/provider/Social%20login/social_login_bloc.dart';
import 'package:library_offline/provider/member_details/member_details_bloc.dart';
import 'package:library_offline/provider/seat_allotment/getseat_bloc.dart';
import 'package:library_offline/route/pageroute.dart';
import 'package:library_offline/route/route_generater.dart';
import 'package:library_offline/utils/theme_changer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:library_offline/view/auth/social_login.dart';
import 'firebase_options.dart';
import 'database/table/seat_allotment_db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GetSeatBloc(), // Provide the GetSeatBloc
          ),  
          BlocProvider(
            create: (context) => SocialLoginBloc(firebaseAuth: FirebaseAuth.instance, googleSignIn: GoogleSignIn(),  ), // Provide the GetSeatBloc
          ),
          BlocProvider(create: (context) => MemberBloc(SeatAllotment())),
        ],
        child: MaterialApp(
          initialRoute: RoutePath.splash,
          onGenerateRoute: MyRoutes.generateRoute,
          debugShowCheckedModeBanner: false,
          title: 'My Library',
          theme: lightMode,
        ),
      ),
    );
  }
}
