abstract class MemberState {}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MemberSuccess extends MemberState {
  final List<Map<String, dynamic>> members;
  MemberSuccess(this.members);
}

class MemberTotalCollectionSuccess extends MemberState {
  final int totalCollection;
  final int activeMembersCount;
  final int inactiveMembersCount;
  final List<Map<String, dynamic>> collections;
  MemberTotalCollectionSuccess({
    required this.totalCollection,
    required this.activeMembersCount,
    required this.inactiveMembersCount,
    required this.collections,
  });
}

class MemberFailure extends MemberState {
  final String error;
  MemberFailure(this.error);
}

class MemberUpdated extends MemberState {}
