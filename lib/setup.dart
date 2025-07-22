import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'colors.dart';
import 'home_page.dart';

class Setup extends StatefulWidget {
  final Box myBox;
  const Setup({super.key, required this.myBox});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();


  List<String> images = [
    'assets/img/pfp/1.png',
    'assets/img/pfp/2.png',
    'assets/img/pfp/3.png',
    'assets/img/pfp/4.png',
    'assets/img/pfp/5.png',
    'assets/img/pfp/6.png',
    'assets/img/pfp/7.png',
    'assets/img/pfp/8.png',
    'assets/img/pfp/9.png',
  ];

  int? selectedIndex;

  bool get isFormValid {
    return (_formKey.currentState?.validate() ?? false) && selectedIndex != null;

  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void trySubmit() {
    if (_formKey.currentState!.validate() && selectedIndex != null) {
      String name = _nameController.text.trim();
      String selectedImage = images[selectedIndex!];

      // ذخیره‌سازی در Hive
      widget.myBox.put("userName", name);
      widget.myBox.put("userImage", selectedImage);
      widget.myBox.put("isSetupDone", true);  // پرچم اینکه کاربر ثبت‌نام کرده

      // رفتن به صفحه‌ی Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            name: name,
            selectedImage: selectedImage,
            myBox: widget.myBox,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً نام و پروفایل را انتخاب کنید')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60,),
            Center(child: Image.asset("assets/img/logo.png", scale: 4)),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    "خوش اومدی!",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30, color: Primary),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "از ایده تا انجام - یک قدم یک تیک",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: SecendText),
                  ),
                  const SizedBox(height: 40),

                  Form(
                    key: _formKey,
                    onChanged: () {
                      setState(() {});
                    },
                    child: TextFormField(
                      maxLength: 25,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                      ],
                      controller: _nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: TextFieldColor,
                        labelText: "نام شما",
                        hintStyle: TextStyle(
                            color: Colors.grey[800], fontWeight: FontWeight.w100),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'لطفاً نام خود را وارد کنید';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "انتخاب پروفایل",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Primary),
                    ),
                  ),

                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: images.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12),
                    itemBuilder: (context, index) {
                      bool isSelected = selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.transparent,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(images[index], fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: isFormValid ? trySubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Primary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "شروع",
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
