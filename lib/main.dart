import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickform/firebase_options.dart';

import 'Admin/form_provider.dart';
import 'Admin/user_provider.dart';
import 'Authentication/Auth_Change.dart';
import 'Authentication/LoginScreen.dart';
import 'Student/Filled_Form_Provider.dart';


final adminProviders = <ChangeNotifierProvider>[
  ChangeNotifierProvider<FormsProvider>(create: (_) => FormsProvider()),
  ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
  ChangeNotifierProvider<FilledFormsProvider>(create: (_) => FilledFormsProvider()),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: adminProviders, // <-- use the common provider list
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthChange(),
      debugShowCheckedModeBanner: false,
    );
  }
}