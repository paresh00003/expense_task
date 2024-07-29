import 'package:flutter/material.dart';
import 'package:sql_task_expense/expense_task/pages/splash_/splash.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  await PrefrenceManager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.blue),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),


      ),
      debugShowCheckedModeBanner: false,
      title: 'Expense App',
      home: Splash(),
    );
  }
}
