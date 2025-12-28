import 'dart:async';

import 'package:expense1/domain/constants/app_constants.dart';
import 'package:expense1/domain/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatelessWidget{
  const SplashPage({super.key});


  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2),()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
     int userId =  prefs.getInt(AppConstant.app_login_prefs) ?? 0;

      String  nextPage = AppRoutes.loginPage;
      if(userId>0){
        nextPage = AppRoutes.dashBoardPage;
      }
      Navigator.pushReplacementNamed(context, nextPage);

    } );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppConstant.imgIcAppLogo,width: 200,height: 250,),
            Text("Expense",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ],
        )

      ),
    );
  }

}