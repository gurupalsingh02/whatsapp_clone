import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Features/Landing/Screens/Landing_Screen.dart';
import 'package:whatsapp_clone/Common/widgets/utils/colors.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/router.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LandingScreen(),
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(color: appBarColor)),
      onGenerateRoute: generateRoute,
    );
  }
}
