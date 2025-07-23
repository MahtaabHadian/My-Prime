import 'package:flutter/material.dart';
import 'base/colors.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BgColor,


      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.black.withOpacity(0.7),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'راهنمای استفاده از اپلیکیشن',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Primary,
                          fontFamily: 'AbarLow',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildGuideSection(
                  title: 'خوش آمدید!',
                  description:
                  "با این اپلیکیشن می‌تونی خیلی راحت پروژه‌هات و کارای روزمره‌ت رو جمع‌وجور کنی و همیشه بدونی چی کجاست و چه کاری مونده. ابزارهاش جوری طراحی شدن که هم بتونی کارات رو اولویت‌بندی کنی، هم روند پیشرفتشون رو دنبال کنی. تو ادامه، مرحله‌به‌مرحله می‌گیم چطور از قابلیت‌های مهمش استفاده کنی.",
                  imagePath: 'assets/img/Fun.png', height: 150 ,
                ),
                _buildGuideSection(
                  title: 'اضافه کردن پروژه جدید',
                  description:
                  'برای اضافه کردن یه پروژه جدید، روی دکمه شناور "+" در صفحه اصلی کلیک کنید. نام پروژه رو وارد کنید و "افزودن" رو انتخاب کنید. یه تصویر پس‌زمینه به صورت تصادفی برای پروژه انتخاب می‌شه.',
                  imagePath: 'assets/img/Add.png', height: 180,
                ),
                _buildGuideSection(
                  title: 'مدیریت تسک‌ها',
                  description:
                  'برای اضافه کردن تسک، وارد یه پروژه بشید و روی دکمه "+" کلیک کنید. عنوان، تاریخ، و اولویت تسک رو وارد کنید. برای علامت زدن تسک به عنوان انجام‌شده، چک‌باکس کنارش رو تیک بزنید. برای حذف تسک، اون رو به سمت راست بکشید.',
                  imagePath: 'assets/img/manage.png', height: 170,
                ),
                _buildGuideSection(
                  title: 'ویرایش یا حذف پروژه',
                  description:
                  'برای ویرایش یا حذف یه پروژه، روی منوی سه‌نقطه در باکس پروژه در صفحه اصلی یا داخل صفحه پروژه ضربه بزنید. می‌تونید نام پروژه رو تغییر بدید یا اون رو کامل حذف کنید.',
                  imagePath: 'assets/img/Edit.png', height: 170,
                ),
                _buildGuideSection(
                  title: 'نوار پیشرفت',
                  description:
                  'نوار پیشرفت در هر پروژه نشون می‌ده که چند درصد از تسک‌ها انجام شدن. این نوار به صورت خودکار با اضافه کردن، حذف کردن، یا علامت زدن تسک‌ها به‌روزرسانی می‌شه.',
                  imagePath: 'assets/img/Progress.png', height: 190,
                ),
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: SecendText,
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        'ساخته شده توسط مهتاب هادیان',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'AbarLow',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuideSection({
    required String title,
    required String description,
    required String imagePath,
    required double height,

  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Primary,
              fontFamily: 'AbarLow',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontFamily: 'AbarLow',
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10),
          Center(
            child: Image.asset(
              imagePath,
              height: height,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}