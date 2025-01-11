import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_offline/component/my_container.dart';
import '../component/myText.dart';
import '../database/table/seat_allotment_db.dart';
import '../provider/member_details/member_details_bloc.dart';
import '../provider/member_details/member_details_event.dart';
import '../provider/member_details/member_details_state.dart';
import 'seat_allotment.dart';

class TotalCollection extends StatefulWidget {
  const TotalCollection({super.key});

  @override
  State<TotalCollection> createState() => _TotalCollectionState();
}

class _TotalCollectionState extends State<TotalCollection> {
  final SeatAllotment _seatAllotment = SeatAllotment();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MemberBloc>(context).add(FetchMembersEvent(index: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(label: "Total Collection", fontSize: 18, fontColor: Colors.white),
      ),
      body: GradientContainer(
        child: BlocBuilder<MemberBloc, MemberState>(
          builder: (context, state) {
            if (state is MemberLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MemberTotalCollectionSuccess) {
              final totalCollection = state.totalCollection; // Total of all active members
              final activeMembersCount = state.activeMembersCount;
              final inactiveMembersCount = state.inactiveMembersCount;
              final collections = state.collections;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the total collection at the top
                    MyText(
                      label: "Total Collection from Active Members: ₹$totalCollection",
                      fontSize: 20,
                      fontColor: Colors.white,

                    ),
                    const SizedBox(height: 20),
                    MyText(label: "Active Members: $activeMembersCount", fontSize: 16,),
                    MyText(label: "Inactive Members: $inactiveMembersCount", fontSize: 16),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: collections.length,
                        itemBuilder: (context, index) {
                          final item = collections[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: MyText(label: item['Name'], fontSize: 16, fontColor: Colors.black),
                              subtitle: MyText(label: "Amount: ₹${item['Amount']}", fontSize: 14, fontColor: Colors.grey),
                              trailing: MyText(
                                label: item['MemberStatus'].toUpperCase(),
                                fontSize: 14,
                                fontColor: item['MemberStatus'] == 'Active' ? Colors.green : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Select an option to view data'));
            }
          },
        ),
      ),
    );
  }
}
