import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../database/table/seat_allotment_db.dart';

part 'getseat_event.dart';
part 'getseat_state.dart';

class GetSeatBloc extends Bloc<GetSeatEvent, GetSeatState> {
  GetSeatBloc() : super(GetSeatInitial()) {
    // Handle seat fetching
    on<GetSeatSuccessEvent>((event, emit) async {
      emit(GetSeatLoading());
      try {
        var seatData = await fetchSeatData();
        if (seatData != null) {
          emit(GetSeatSuccess());
        } else {
          emit(GetSeatError("No seats available"));
        }
      } catch (e) {
        emit(GetSeatError(e.toString()));
      }
    });

    // Handle seat insertion
    on<InsertSeatEvent>((event, emit) async {
      emit(GetSeatLoading());
      try {
        Map<String, dynamic> appDetailSet = {};
        appDetailSet[SeatAllotment.shift] = event.selectedShift;
        appDetailSet[SeatAllotment.shiftIndex] = event.selectedShiftIndex; // Storing the selected shift index as int
        appDetailSet[SeatAllotment.memberId] = event.memberId;
        appDetailSet[SeatAllotment.name] = event.name;
        appDetailSet[SeatAllotment.chairNo] = event.chairNo; // Storing the selected chair number
        appDetailSet[SeatAllotment.chairIndex] = event.chairIndex; // Storing the selected chair index as int
        appDetailSet[SeatAllotment.amount] = event.amount;
        appDetailSet[SeatAllotment.dateOfJoining] = event.dateOfJoining;
        appDetailSet[SeatAllotment.memberStatus] = 'Active';
        await SeatAllotment().insert(appDetailSet);
        emit(GetSeatSuccess());
      } catch (e) {
        emit(GetSeatError("Error inserting seat: ${e.toString()}"));
      }
    });

    // Handle delete all seats
    on<DeleteAllSeatsEvent>((event, emit) async {
      emit(GetSeatLoading());
      try {
        await deleteAllSeats();  // Perform delete all operation
        emit(GetSeatSuccess());  // Emit success state if deletion was successful
      } catch (e) {
        emit(GetSeatError("Error deleting seats: ${e.toString()}"));
      }
    });
  }

  // Simulate fetching seat data (replace this with actual data fetching logic)
  Future<List<dynamic>> fetchSeatData() async {
    await Future.delayed(Duration(seconds: 2));
    return ["Seat 1", "Seat 2", "Seat 3"];
  }

  // Simulate inserting seat data (replace this with actual database insertion logic)
  Future<void> insertSeatData(String seatData) async {
    await Future.delayed(Duration(seconds: 1));  // Simulate delay
    print("Seat inserted: $seatData");
  }

  // Simulate deleting all seats (replace this with actual database deletion logic)
  Future<void> deleteAllSeats() async {
    await Future.delayed(Duration(seconds: 1));  // Simulate delay
    print("All seats deleted");
  }
}
