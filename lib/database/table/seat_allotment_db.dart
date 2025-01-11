import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class SeatAllotment {
  static const String SEAT_ALLOTMENT = "SEAT_ALLOTMENT";
  static const String shift = "SHIFT";
  static const String shiftIndex = "Shift_Index";
  static const String name = "Name";
  static const String amount = "Amount";
  static const String memberId = "MEMBER_ID";
  static const String chairNo = "CHAIR_NO";
  static const String chairIndex = "Chair_Index";
  static const String dateOfJoining = "Date_Of_Joining";
  static const String memberStatus = "MemberStatus";

  // static const String totalCollection = "TotalCollection";

  static const String CREATE = '''
CREATE TABLE IF NOT EXISTS $SEAT_ALLOTMENT (
  $memberId TEXT PRIMARY KEY,
  $name TEXT DEFAULT '',
  $shift TEXT DEFAULT '',
  $shiftIndex INTEGER DEFAULT 0,
  $chairNo TEXT DEFAULT '',
  $chairIndex INTEGER DEFAULT 0,
  $amount INTEGER DEFAULT 0, 
  $dateOfJoining TEXT DEFAULT '',
  $memberStatus TEXT DEFAULT ''
)
''';



  // Define a function that inserts notes into the database
  Future<void> insert(Map<String, dynamic> map) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    // Get a reference to the database.
    final db = await databaseHelper.database;
    // In this case, replace any previous data.
    await db.insert(
      SEAT_ALLOTMENT,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Method to retrieve all notes from the database
  Future<List<Map<String, dynamic>>> getUserData() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    return await db.query(SEAT_ALLOTMENT);
  }

  // Method to delete a note from the database
  Future<int> deleteUserData() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    return await db.delete(
      SEAT_ALLOTMENT,
    );
  }

  // Method to get active members
  Future<List<Map<String, dynamic>>> getActiveMembers() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    return await db.query(
      SEAT_ALLOTMENT,
      where: '$memberStatus = ?',
      whereArgs: ['Active'],
    );
  }

  Future<List<Map<String, dynamic>>> getInactiveMembers() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    return await db.query(
      SEAT_ALLOTMENT,
      where: '$memberStatus = ?',
      whereArgs: ['inactive'], // Fetch only members with 'inactive' status
    );
  }


  Future<void> activateMemberStatus({required String memberId}) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;

    try {
      // Update the member status to 'active'
      await db.update(
        SEAT_ALLOTMENT,
        {memberStatus: 'Active'}, // Set the status to active
        where: 'MEMBER_ID = ?', // Use the column name MEMBER_ID correctly
        whereArgs: [memberId], // Bind the memberId argument
      );
      print("Successfully updated member ID: $memberId to status: active");
    } catch (e) {
      print("Error updating member status to active: $e");
    }
  }

  Future<void> updateMemberStatus({required String memberId}) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;

    try {
      // Update the member status to 'inactive'
      await db.update(
        SEAT_ALLOTMENT,
        {memberStatus: 'inactive'}, // Set the status to inactive
        where: 'MEMBER_ID = ?', // Use the column name MEMBER_ID correctly
        whereArgs: [memberId], // Bind the memberId argument
      );
      print("Successfully updated member ID: $memberId to status: inactive");
    } catch (e) {
      print("Error updating member status to inactive: $e");
    }
  }


  Future<int> getTotalCollection() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;

    try {
      // Use the SUM aggregate function to calculate the total amount
      final List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT SUM($amount) as total FROM $SEAT_ALLOTMENT where $memberStatus = "Active"'
      );

      // If there's a result, return the total amount, otherwise return 0
      if (result.isNotEmpty && result.first['total'] != null) {
        return result.first['total'] as int;
      } else {
        return 0; // No records found
      }
    } catch (e) {
      print("Error calculating total collection: $e");
      return 0; // Return 0 in case of an error
    }
  }


  Future<List<Map<String, dynamic>>> getFilteredSeatData() async {
    try {
      // Fetch the data from the SeatAllotment table
      List<Map<String, dynamic>> seatData = await SeatAllotment().getUserData();

      // Use map to filter only shift and chairNo
      List<Map<String, dynamic>> filteredData = seatData.map((data) {
        return {
          'shift': data['SHIFT'],
          'chairNo': data['CHAIR_NO'],
        };
      }).toList();

      return filteredData;
    } catch (e) {
      print("Error fetching and filtering seat data: $e");
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> getUsersEligibleForReminder() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;

    try {
      // Fetch all users with their joining date
      final List<Map<String, dynamic>> members = await db.query(SEAT_ALLOTMENT);

      // Get today's date
      final DateTime today = DateTime.now();

      // Filter members who joined 30 days ago
      List<Map<String, dynamic>> eligibleMembers = members.where((member) {
        final String? dateStr = member[dateOfJoining];
        if (dateStr != null && dateStr.isNotEmpty) {
          DateTime joiningDate = DateFormat('dd/MM/yyyy').parse(dateStr); // Use 'dd/MM/yyyy' format
          return today.difference(joiningDate).inDays >= 30;
        }
        return false;
      }).toList();

      return eligibleMembers;
    } catch (e) {
      print("Error checking eligible members for reminder: $e");
      return [];
    }
  }



}
