import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Screens/homepage.dart';
import 'constants.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(const Duration(milliseconds: 550)).then((value) {
    FlutterNativeSplash.remove();
  });
  runApp(const MyApp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'INDEXA',
      routes: {"homepage": (context) => const HomePage()},
      theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: color1,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            bodyLarge: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          appBarTheme: AppBarTheme(
              color: color3,
              foregroundColor: color1,
              titleTextStyle: GoogleFonts.yuseiMagic(
                color: color1,
                fontSize: 25,
              ))),
      home: const HomePage(),
    );
  }
}
