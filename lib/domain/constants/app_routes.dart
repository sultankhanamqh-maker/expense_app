import 'package:expense1/ui/screens/add_expense_page/add_expense_page.dart';
import 'package:expense1/ui/screens/dashbaord/dashboard_page.dart';
import 'package:expense1/ui/screens/on_boarding/login/login_page.dart';
import 'package:expense1/ui/screens/on_boarding/signup/signup_page.dart';
import 'package:flutter/cupertino.dart';
import '../../ui/screens/splash_page/splash_page.dart';

class AppRoutes {

  static const String loginPage = "login_page";
  static const String signUpPage = "sign_up_page";
  static const String dashBoardPage = "/";
  static const String splashPage = "splash_page";
  static const String addExpensePage = "add_expense_page";


  static Map<String , WidgetBuilder> routes = {
    loginPage : (_) => LoginPage(),
    signUpPage : (_) => SignUpPage(),
    splashPage : (_) => SplashPage(),
    dashBoardPage : (_) => DashBoardPage(),
    addExpensePage : (_) => AddExpensePage(),
  };



}