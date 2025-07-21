import 'package:flutter/material.dart';
import 'colors.dart'; // رنگ‌های سفارشی خودت

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _workController = TextEditingController();

  List<String> Date = [
    'امروز',
    'فردا',
    'این هفته',
    'هفته آینده',
    'این ماه',
    'ماه آینده',
    'بلند مدت',
  ];

  List<String> Priority = [
    'خیلی مهم!',
    'متوسط',
    'کم اهمیت',
  ];

  int selectedIndex = 0;
  int selectedPeri = 1;

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

  Color getPriorityColor(int index) {
    switch (index) {
      case 0:
        return Colors.red; // خیلی مهم
      case 1:
        return Colors.orange; // متوسط
      case 2:
        return Colors.green; // کم اهمیت
      default:
        return Color(0xffECE1D4); // پیش‌فرض
    }
  }

  void trySubmit() {
    if (_formKey.currentState!.validate()) {
      String title = _workController.text.trim();
      int priority = selectedPeri;
      String selectedDate = Date[selectedIndex];

      final newTaskMap = {
        'title': title,
        'priority': priority,
        'isDone': false,
        'date': selectedDate,
      };

      Navigator.pop(context, newTaskMap);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً این بخش رو پر کنید')),
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
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Primary, width: 2),
                              ),
                              child: Icon(Icons.arrow_back_ios_new_rounded,
                                  size: 30, color: Primary),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "افزودن تسک جدید",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                            color: Primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text("زمان :",
                            style:
                            TextStyle(color: SecendText, fontSize: 20)),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: Date.length,
                          itemBuilder: (context, index) {
                            bool isSelected = index == selectedIndex;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                margin: EdgeInsets.only(
                                    left: 8, right: index == 0 ? 25 : 0),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.black
                                      : const Color(0xffECE1D4),
                                  borderRadius: BorderRadius.circular(50),
                                  border: isSelected
                                      ? Border.all(
                                      color: Colors.black, width: 2)
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  Date[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black45,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text("چه کاری باید انجام بشه؟",
                            style:
                            TextStyle(color: SecendText, fontSize: 20)),
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
                            hintStyle: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w100,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'لطفاً این بخش رو پر کنید';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text("الویت این تسک چقدره؟",
                            style:
                            TextStyle(color: SecendText, fontSize: 20)),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: Priority.length,
                          itemBuilder: (context, index) {
                            bool isSelected = index == selectedPeri;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPeri = index;
                                });
                              },
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 30),
                                margin: EdgeInsets.only(
                                    left: 8, right: index == 0 ? 25 : 0),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? getPriorityColor(index)
                                      : const Color(0xffECE1D4),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  Priority[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black45,
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
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                onPressed: isFormValid ? trySubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid
                      ? Primary
                      : Primary.withOpacity(0.4),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "افزودن",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
