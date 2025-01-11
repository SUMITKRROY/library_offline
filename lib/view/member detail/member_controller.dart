// member_screen_controller.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/table/seat_allotment_db.dart';
import '../../provider/member_details/member_details_bloc.dart';
import '../../provider/member_details/member_details_event.dart';

class MemberScreenController {
  late final MemberBloc memberBloc;

  MemberScreenController(int index) {
    memberBloc = MemberBloc(SeatAllotment());
    // Pass the index to the Bloc to fetch members
    memberBloc.add(FetchMembersEvent(index: index));
  }

  void dispose() {
    memberBloc.close();
  }

  void updateMemberStatus({required String memberId, required int index}) {
    memberBloc.add(UpdateMemberStatusEvent(memberId: memberId, index: index));
  }

}
