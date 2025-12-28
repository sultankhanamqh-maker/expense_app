import 'package:expense1/data/local/helper/db_helper.dart';
import 'package:expense1/domain/constants/app_routes.dart';
import 'package:expense1/ui/screens/add_expense_page/expense_bloc/expense_bloc.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(create: (context) => UserBloc(dbHelper: DbHelper.instance)),
      BlocProvider(create: (context) => ExpenseBloc(dbHelper: DbHelper.instance))
    ], child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.splashPage,
      routes: AppRoutes.routes,
    );
  }
}
