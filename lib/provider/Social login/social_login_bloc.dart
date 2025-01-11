import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'social_login_event.dart';
part 'social_login_state.dart';

class SocialLoginBloc extends Bloc<SocialLoginEvent, SocialLoginState> {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  SocialLoginBloc({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        super(SocialLoginInitial()) {
    on<GoogleLoginEvent>(_onGoogleLoginEvent);
  }

  Future<void> _onGoogleLoginEvent(
      GoogleLoginEvent event, Emitter<SocialLoginState> emit) async {
    emit(SocialLoginLoading());
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(SocialLoginError(errorMessage: "Sign-In canceled by user."));
        return;
      }

      // Obtain the authentication details
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign-In to Firebase
      final userCredential =
      await _firebaseAuth.signInWithCredential(credential);

      emit(SocialLoginLoaded(userName: userCredential.user!.displayName ?? ""));
    } catch (e) {
      emit(SocialLoginError(errorMessage: "Error: $e"));
    }
  }
}
