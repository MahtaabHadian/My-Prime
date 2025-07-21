import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_prime/home_page.dart';
import 'package:my_prime/project_deatils.dart';
import 'package:my_prime/setup.dart';

import 'add_task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: const Locale('fa'),
      supportedLocales: const [
        Locale('fa'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        fontFamily: 'AbarLow',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
        useMaterial3: true,
      ),
      home: Setup(),
      //
    );
  }
}

// HomePage(name: "dfsf", image: "assets/img/pfp/1.png")
