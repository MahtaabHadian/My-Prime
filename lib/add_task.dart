import 'package:flutter/material.dart';
import 'colors.dart';

class AddTask extends StatefulWidget {
  final String projectName;

  const AddTask({super.key, required this.projectName});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _workController = TextEditingController();
  int selectedDateIndex = 0;
  int selectedPriorityIndex = 1;

  List<String> dateOptions = [
    'امروز',
    'فردا',
    'این هفته',
    'هفته آینده',
    'این ماه',
    'ماه آینده',
    'بلند مدت',
  ];

  List<String> priorityOptions = [
    'خیلی مهم!',
    'متوسط',
    'کم اهمیت',
  ];

  bool get isFormValid {
    return _workController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _workController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _workController.dispose();
    super.dispose();
  }

  void trySubmit() {
    if (_formKey.currentState!.validate()) {
      final newTaskMap = {
        'title': _workController.text.trim(),
        'date': dateOptions[selectedDateIndex],
        'priority': selectedPriorityIndex,
        'projectName': widget.projectName,
        'isDone': false,
      };
      print('AddTask: Submitting task: $newTaskMap');
      Navigator.pop(context, newTaskMap);
    } else {
      print('AddTask: Form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً عنوان تسک را وارد کنید')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              print('AddTask: Back button pressed');
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Primary, width: 2),
                              ),
                              child: Icon(Icons.arrow_back_ios_new_rounded,
                                  size: 24, color: Primary),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "افزودن تسک جدید",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                            color: Primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "زمان:",
                          style: TextStyle(color: SecendText, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dateOptions.length,
                          itemBuilder: (context, index) {
                            bool isSelected = index == selectedDateIndex;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDateIndex = index;
                                  print('AddTask: Selected date: ${dateOptions[index]}');
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                margin: EdgeInsets.only(left: 8, right: index == 0 ? 25 : 0),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.black : const Color(0xffECE1D4),
                                  borderRadius: BorderRadius.circular(20),
                                  border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  dateOptions[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    color: isSelected ? Colors.white : Colors.black45,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "چه کاری باید انجام بشه؟",
                          style: TextStyle(color: SecendText, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: _workController,
                          maxLength: 50,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: TextFieldColor,
                            hintText: 'عنوان تسک',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'لطفاً عنوان تسک را وارد کنید';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            print('AddTask: Title input: $value');
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "اولویت این تسک چقدره؟",
                          style: TextStyle(color: SecendText, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: priorityOptions.length,
                          itemBuilder: (context, index) {
                            bool isSelected = index == selectedPriorityIndex;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPriorityIndex = index;
                                  print('AddTask: Selected priority: ${priorityOptions[index]}');
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                margin: EdgeInsets.only(left: 8, right: index == 0 ? 25 : 0),
                                decoration: BoxDecoration(
                                  color: isSelected ? _getPriorityColor(index) : const Color(0xffECE1D4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  priorityOptions[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    color: isSelected ? Colors.white : Colors.black45,
                                  ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: ElevatedButton(
                onPressed: isFormValid ? trySubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid ? Primary : Primary.withOpacity(0.4),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "افزودن",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(int index) {
    switch (index) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      default:
        return const Color(0xffECE1D4);
    }
  }
}