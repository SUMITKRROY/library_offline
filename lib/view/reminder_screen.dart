import 'package:flutter/material.dart';
import 'package:library_offline/component/myText.dart';
import '../component/my_container.dart';
import '../database/table/seat_allotment_db.dart';
import 'seat_allotment.dart';

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  List<Map<String, dynamic>> eligibleMembers = [];

  @override
  void initState() {
    super.initState();
    fetchEligibleMembers();
  }

  Future<void> fetchEligibleMembers() async {
    SeatAllotment seatAllotment = SeatAllotment();
    eligibleMembers = await seatAllotment.getUsersEligibleForReminder();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "30-Day Membership Reminders",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GradientContainer(
        child: eligibleMembers.isEmpty
            ? Center(
                child: Text("No members have completed 30 days yet.",
                    style: TextStyle(color: Colors.white)))
            : ListView.builder(
                itemCount: eligibleMembers.length,
                itemBuilder: (context, index) {
                  final member = eligibleMembers[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name: ${member['Name']}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text("Amount: ${member['Amount']}"),
                                  SizedBox(height: 4),
                                  Text("Date of Joining: ${member[SeatAllotment.dateOfJoining]}"),
                                  SizedBox(height: 4),
                                  Text(
                                    "30 days complete!",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                              InkWell(child: MyText(label: "Pay amount",fontColor: Colors.green,),)
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
