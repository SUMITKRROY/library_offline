// member_screen_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_offline/component/myText.dart';
import '../../component/my_container.dart';
import '../../provider/member_details/member_details_bloc.dart';
import '../../utils/theme_changer.dart';
import '../../provider/member_details/member_details_state.dart';
import 'member_controller.dart';

class MemberScreen extends StatefulWidget {
  final String title;
  final int index;

  MemberScreen({super.key, required this.title, required this.index});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  late MemberScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = MemberScreenController(widget.index);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Helper function to get the "no members" message based on index
  String getNoMembersMessage() {
    switch (widget.index) {
      case 0:
        return 'No Active Live Member ';
      case 1:
        return 'No Active Members';
      case 2:
        return 'No Unactive Members';
      default:
        return 'Currently Data Empty';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(label: widget.title, fontSize: 18, fontColor: Colors.white),
      ),
      body: BlocBuilder<MemberBloc, MemberState>(
        bloc: controller.memberBloc,
        builder: (context, state) {
          if (state is MemberLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MemberSuccess) {
            print(state.members);
            return GradientContainer(
              child: state.members.isEmpty
                  ? Center(child: MyText(label: getNoMembersMessage()))
                  : ListView.builder(
                itemCount: state.members.length,
                itemBuilder: (context, index) {
                  // Determine the color based on member status
                  Color cardColor = state.members[index]['MemberStatus'] == 'inactive'
                      ? Colors.red
                      : Colors.deepPurple.withOpacity(0.8);

                  Color iconButtonColor = state.members[index]['MemberStatus'] == 'inactive'
                      ? Colors.white
                      : Colors.red;

                  return GestureDetector(
                    onTap: () {
                      print("Tapped on member ${state.members[index]['MEMBER_ID']}");
                    },
                    child: Card(
                      color: cardColor,
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(label: ' ${state.members[index]['Name']}',fontSize: 24.sp,),
                            ListTile(
                              title: MyText(
                                  label: 'Shift: ${state.members[index]['SHIFT']}',
                                  fontSize: 16.sp),
                              subtitle: MyText(
                                  label: 'Chair No: ${state.members[index]['CHAIR_NO']}',
                                  fontSize: 12.sp),
                              trailing: widget.index == 1
                                  ? null
                                  : IconButton(
                                onPressed: () {
                                  // Call the updateMemberStatus function in the controller
                                  controller.updateMemberStatus(
                                      memberId: state.members[index]['MEMBER_ID'],
                                      index: widget.index);
                                },
                                icon:   Icon(Icons.delete,size: 24.h,),
                                color: iconButtonColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is MemberFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
