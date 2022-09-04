import 'package:finstagram/pages/home.dart';
import 'package:finstagram/pages/login.dart';
import 'package:finstagram/pages/register.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.instance.registerSingleton(
      FireBaseService(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
     theme: ThemeData(
       primarySwatch: Colors.red,
     ),
      initialRoute:'login',
      routes: {
       'register':(context) => const Register(),
       'login':(context) => const Login(),
        'home':(context) => const Home(),
      },
    );
  }
}
