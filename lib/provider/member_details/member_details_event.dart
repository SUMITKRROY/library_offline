import 'package:equatable/equatable.dart';

abstract class MemberEvent extends Equatable {
 const MemberEvent();

 @override
 List<Object> get props => [];
}

class FetchMembersEvent extends MemberEvent {
 final int index;

 const FetchMembersEvent({required this.index});

 @override
 List<Object> get props => [index];
}

class UpdateMemberStatusEvent extends MemberEvent {
 final int index;
 final String memberId;

 const UpdateMemberStatusEvent({required this.memberId, required this.index});

 @override
 List<Object> get props => [memberId];
}
