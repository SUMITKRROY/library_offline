import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_offline/component/my_container.dart';
import 'package:library_offline/component/myText.dart';
import 'package:library_offline/component/myTextForm.dart';
import 'package:library_offline/component/mybutton.dart';
import 'package:library_offline/database/table/seat_allotment_db.dart';
import 'package:library_offline/database/table/user_profile_db.dart';
import 'package:library_offline/provider/seat_allotment/getseat_bloc.dart';
import 'package:library_offline/route/pageroute.dart';
import 'package:library_offline/utils/utils.dart';
import 'package:library_offline/utils/image.dart';
import 'package:uuid/uuid.dart';

class BookSeats extends StatefulWidget {
  final String totalSeats;

  const BookSeats({
    super.key,
    required this.totalSeats,
  });

  @override
  State<BookSeats> createState() => _BookSeatsState();
}

class _BookSeatsState extends State<BookSeats> {
  late int _selectedChairIndex;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _memberIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateOfJoiningController =
      TextEditingController();
  int _selectedPeriodIndex = -1; // To keep track of the selected period index
  int _totalMembers = 0;
  int _totalSeats = 0;
  Map<String, List<String>> shiftData = {};

// Function to generate and store UUID in the global variable
  void generateUuid() {
    var uuid = Uuid();
    _memberIdController.text =
        uuid.v4(); // Store the generated UUID in the global variable
    // Print the generated UUID
  }

  @override
  void initState() {
    super.initState();
    _selectedChairIndex = -1; // No chair selected initially
    _selectedPeriodIndex = 0; // Automatically select the Morning shift
    _dateOfJoiningController.text =
        Utils.getFormattedDate(DateTime.now()); // Set today's date
    _fetchTotalMembers();
    generateUuid();
  }

  @override
  void dispose() {
    _memberIdController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _dateOfJoiningController.dispose();
    super.dispose();
  }

  Future<void> _fetchTotalMembers() async {
    try {
      List<Map<String, dynamic>> data = await SeatAllotment().getUserData();
      List<Map<String, dynamic>> profileData =
          await ProfileTable().getProfile();

      // Call the filter function to get shift data
      shiftData = _filterDataByShift(data);

      setState(() {
        _totalMembers = data.length;
        _totalSeats = profileData.isNotEmpty
            ? profileData.first['TOTAL_SEATS']
            : 0; // Check if profileData is not empty
        print("_totalSeats: $_totalSeats");
        print("_totalMembers: $_totalMembers");
        print("Filtered Shift Data: $shiftData"); // Print the filtered data
      });
    } catch (e) {
      print("Error fetching total members: $e");
    }
  }

  // Function to filter the data by shift
  Map<String, List<String>> _filterDataByShift(
      List<Map<String, dynamic>> data) {
    // Initialize the shiftData map
    Map<String, List<String>> shiftData = {
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
      'Night': [],
      'FullDay': [],
      'Unknown': [],
    };

    // Filter data by shift and populate the map
    for (var member in data) {
      String shift =
          member['SHIFT'] ?? 'Unknown'; // Default to 'Unknown' if SHIFT is null
      String chairNo =
          member['CHAIR_NO'] ?? 'N/A'; // Default to 'N/A' if CHAIR_NO is null

      // Check if the shift exists in the map and add the chair number
      if (shiftData.containsKey(shift)) {
        shiftData[shift]!.add(chairNo);
      } else {
        // Add to 'Unknown' category for shifts not defined in the map
        shiftData['Unknown']!.add(chairNo);
      }
    }

    return shiftData;
  }

  Future<void> _refreshData() async {
    await _fetchTotalMembers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetSeatBloc, GetSeatState>(
      listener: (context, state) {
        if (state is GetSeatSuccess) {
          Navigator.pushReplacementNamed(context, RoutePath.homeScreen);
        } else if (state is GetSeatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error allotting seat. Please try again.'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: MyText(
            label: "My Library (${_totalSeats} seats)",
            fontSize: 14.sp,
            fontColor: Colors.white,
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: GradientContainer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Seat info columns
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSeatInfoColumn("All Seats", "${_totalSeats}"),
                          _buildSeatInfoColumn("Allotted", "${_totalMembers}"),
                          _buildSeatInfoColumn(
                              "Un Allotted", "${_totalSeats - _totalMembers}"),
                        ],
                      ),
                      // Shift selection buttons
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildPeriodButton(0, "Morning"),
                              _buildPeriodButton(1, "Afternoon"),
                              _buildPeriodButton(2, "Evening"),
                              _buildPeriodButton(3, "Night"),
                              _buildPeriodButton(4, "FullDay"),
                            ],
                          ),
                        ),
                      ),
                      // Form fields
                      // _buildTextFormField(
                      //     _memberIdController, "Enter member id", keyboardType: TextInputType.number),
                      SizedBox(
                        height: 10.h,
                      ),
                      MyTextForm(
                        label: "Enter name",
                        controller: _nameController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                        ],
                        keyboardType: TextInputType.name,
                        validator: true,
                        validatorFunc: Utils.validateUserName(),
                        //prefix: const Icon(Icons.email, color: Colors.white),
                        onChanged: (String) {},
                      ),

                      SizedBox(
                        height: 10.h,
                      ),
                      MyTextForm(
                        label: "Enter amount",
                        controller: _amountController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                        ],
                        keyboardType: TextInputType.number,
                        validator: true,
                        validatorLabel: "amount",
                        //prefix: const Icon(Icons.email, color: Colors.white),
                        onChanged: (String) {},
                      ),

                      SizedBox(
                        height: 10.h,
                      ),
                      MyTextForm(
                        label: "Date of Joining",
                        controller: _dateOfJoiningController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          DateTextInputFormatter()
                        ],
                        readOnly: true,
                        keyboardType: TextInputType.datetime,
                        validator: true,
                        validatorLabel: "date",
                        suffix: IconButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000), // Set the minimum date
                              lastDate: DateTime(2025), // Set the maximum date
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _dateOfJoiningController.text = Utils.getFormattedDate(pickedDate);
                              });
                            }
                          },
                          icon: Icon(Icons.calendar_month, color: Colors.white),
                        ),

                          onChanged: (String) {},
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      // Get Seat button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: MyButton(
                                onTap: () async {
                                  if (_selectedChairIndex == -1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Please select a chair before proceeding.'),
                                      ),
                                    );
                                  } else if (_selectedPeriodIndex == -1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Please select a shift before proceeding.'),
                                      ),
                                    );
                                  } else if (_formKey.currentState!
                                      .validate()) {
                                    context.read<GetSeatBloc>().add(
                                          InsertSeatEvent(
                                            selectedShift: _getShiftLabel(
                                                _selectedPeriodIndex),
                                            memberId:
                                                _memberIdController.text.trim(),
                                            chairNo:
                                                "S-${_selectedChairIndex + 1}",
                                            memberStatus: 'Active',
                                            name: _nameController.text.trim(),
                                            amount: int.tryParse(
                                                    _amountController.text
                                                        .trim()) ??
                                                0, // Convert to int
                                            dateOfJoining:
                                                _dateOfJoiningController.text
                                                    .trim(),
                                            selectedShiftIndex:
                                                _selectedPeriodIndex,
                                            chairIndex: _selectedChairIndex,
                                          ),
                                        );
                                  }
                                },
                                text: "Get Seat",
                                textColor: Colors.white,
                                color: Color(0xffBC30AA).withOpacity(0.7),
                                width: double.infinity,
                                height: 50.h),
                          ),
                        ],
                      ),

                      // Filtered Chair Grid
                      // Showing only chairs for the selected shift
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.4, // Limit grid height to 40% of the screen
                        child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(8.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: widget.totalSeats.isNotEmpty
                              ? int.parse(widget.totalSeats)
                              : 0,
                          itemBuilder: (context, index) {
                            // Check if the chair is already allocated in the selected shift
                            bool isChairAllocated =
                                shiftData[_getShiftLabel(_selectedPeriodIndex)]
                                        ?.contains("S-${index + 1}") ??
                                    false;

                            return GestureDetector(
                              onTap: () {
                                if (isChairAllocated) {
                                  // If chair is already allocated, show a message and don't allow selection
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Chair S-${index + 1} is already allotted in ${_getShiftLabel(_selectedPeriodIndex)} shift.'),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    _selectedChairIndex =
                                        _selectedChairIndex == index
                                            ? -1
                                            : index;
                                  });
                                }
                              },
                              child: Semantics(
                                label: 'Seat ${index + 1}',
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.asset(
                                        ImagePath.chair,
                                        fit: BoxFit.cover,
                                        color: isChairAllocated
                                            ? Colors.red.withOpacity(0.5)
                                            : null, // Red overlay for allocated chairs
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 4,
                                      left: 2,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: MyText(
                                          label: 'S-${index + 1}',
                                          fontColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (_selectedChairIndex == index)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 24,
                                        ),
                                      ),
                                    if (isChairAllocated)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds the shift selection buttons
  Widget _buildPeriodButton(int index, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriodIndex = _selectedPeriodIndex == index ? -1 : index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color:
              _selectedPeriodIndex == index ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        child: MyText(
          label: label,
          fontColor: Colors.white,
        ),
      ),
    );
  }

  // Builds the seat info display columns
  Widget _buildSeatInfoColumn(String title, String count) {
    return Column(
      children: [
        MyText(label: title, fontColor: Colors.white),
        MyText(label: count, fontColor: Colors.white),
      ],
    );
  }

  // Gets the shift label based on the selected index
  String _getShiftLabel(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return "Morning";
      case 1:
        return "Afternoon";
      case 2:
        return "Evening";
      case 3:
        return "Night";
      case 4:
        return "FullDay";
      default:
        return "";
    }
  }
}

class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', ''); // Remove existing slashes
    StringBuffer formatted = StringBuffer();

    // Format and add slashes after every 2 characters
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 2 == 0 && i < 6) {
        formatted.write('/');
      }
      formatted.write(text[i]);
    }

    List<String> parts = formatted.toString().split('/');
    if (parts.isNotEmpty) {
      // Validate day (cannot exceed 30)
      if (parts.length > 0 &&
          int.tryParse(parts[0]) != null &&
          int.parse(parts[0]) > 31) {
        return oldValue;
      }

      // Validate month (cannot exceed 12)
      if (parts.length > 1 &&
          int.tryParse(parts[1]) != null &&
          int.parse(parts[1]) > 12) {
        return oldValue;
      }

      // Validate year (cannot exceed 2025)
      if (parts.length > 2 &&
          int.tryParse(parts[2]) != null &&
          int.parse(parts[2]) > 2025) {
        return oldValue;
      }
    }

    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
