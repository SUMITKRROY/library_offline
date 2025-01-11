part of 'social_login_bloc.dart';

@immutable
sealed class SocialLoginState {}


final class SocialLoginInitial extends SocialLoginState {}

final class SocialLoginLoading extends SocialLoginState {}

final class SocialLoginLoaded extends SocialLoginState {
  final String userName;

  SocialLoginLoaded({required this.userName});
}

final class SocialLoginError extends SocialLoginState {
  final String errorMessage;

  SocialLoginError({required this.errorMessage});
}
