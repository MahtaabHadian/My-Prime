import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_prime/home_page.dart';
import 'package:my_prime/project_deatils.dart';
import 'package:my_prime/setup.dart';

import 'add_task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  var box = await Hive.openBox("mybox");

  bool isSetupDone = box.get("isSetupDone", defaultValue: false);

  runApp(MyApp(myBox: box, isSetupDone: isSetupDone));
}

class MyApp extends StatelessWidget {
  final Box myBox;
  final bool isSetupDone;

  const MyApp({super.key, required this.myBox, required this.isSetupDone});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('fa'),
      supportedLocales: const [Locale('fa')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        fontFamily: 'AbarLow',
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
        useMaterial3: true,
      ),
      home: isSetupDone
          ? HomePage(
        name: myBox.get("userName"),
        selectedImage: myBox.get("userImage"),
        myBox: myBox,
      )
          : Setup(myBox: myBox),
    );
  }
}
