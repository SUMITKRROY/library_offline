part of 'social_login_bloc.dart';

@immutable
sealed class SocialLoginEvent {}
class GoogleLoginEvent extends SocialLoginEvent{}