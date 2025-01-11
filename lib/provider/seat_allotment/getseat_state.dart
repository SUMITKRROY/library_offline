part of 'getseat_bloc.dart';

@immutable
sealed class GetSeatState {}

final class GetSeatInitial extends GetSeatState {}
class GetSeatLoading extends GetSeatState {}
class GetSeatSuccess extends GetSeatState {}
class GetSeatError extends GetSeatState {
  String error;

  GetSeatError(this.error);
}