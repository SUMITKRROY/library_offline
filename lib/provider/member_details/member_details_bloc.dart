import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/table/seat_allotment_db.dart';
import 'member_details_event.dart';
import 'member_details_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final SeatAllotment seatAllotment;

  MemberBloc(this.seatAllotment) : super(MemberInitial()) {
    on<FetchMembersEvent>((event, emit) async {
      emit(MemberLoading());
      try {
        if (event.index == 3) {
          // Fetch total collection if index is 3
// Inside your BLoC or the appropriate function
          final totalCollection = await seatAllotment.getTotalCollection();


          print("total collaction ${totalCollection}");
          var getUser = await seatAllotment.getUserData();
          int activeMembersCount =
              (await seatAllotment.getActiveMembers()).length;
          int inactiveMembersCount =
              (await seatAllotment.getInactiveMembers()).length;
          emit(MemberTotalCollectionSuccess(
              totalCollection: totalCollection,
              activeMembersCount: activeMembersCount,
              inactiveMembersCount: inactiveMembersCount,
              collections: getUser ));
        } else {
          List<Map<String, dynamic>> members;

          // Fetch members based on index
          if (event.index == 0) {
            members = await seatAllotment.getActiveMembers();
          } else if (event.index == 1) {
            members = await seatAllotment.getUserData();
          } else if (event.index == 2) {
            members = await seatAllotment.getInactiveMembers();
          } else {
            members = []; // Empty list for default
          }

          emit(MemberSuccess(members));
        }
      } catch (error) {
        emit(MemberFailure(error.toString()));
      }
    });

    on<UpdateMemberStatusEvent>((event, emit) async {
      emit(MemberLoading());

      try {
        // Determine the action: activate if index == 2, otherwise deactivate
        if (event.index == 2) {
          // Activate member status
          await seatAllotment.activateMemberStatus(memberId: event.memberId);
        } else {
          // Deactivate member status
          await seatAllotment.updateMemberStatus(memberId: event.memberId);
        }

        emit(MemberUpdated());

        // Refetch members to update the UI after the status change
        add(FetchMembersEvent(index: event.index)); // Keeps the same filter index for re-fetch
      } catch (error) {
        emit(MemberFailure(error.toString()));
      }
    });

  }
}
