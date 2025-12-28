import 'package:expense1/domain/constants/app_routes.dart';
import 'package:expense1/ui/screens/dashbaord/nav_pages/nav_home_page.dart';
import 'package:expense1/ui/screens/dashbaord/nav_pages/nav_noti_page.dart';
import 'package:expense1/ui/screens/dashbaord/nav_pages/nav_profile_page.dart';
import 'package:expense1/ui/screens/dashbaord/nav_pages/nav_stats_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/constants/app_constants.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  int selectedIndex = 0;
  List<Widget> mPages = [
    NavHomePage(),
    NavStatsPage(),
    NavHomePage(),
    NavNotificationPage(),
    NavProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  prefs.setInt(AppConstant.app_login_prefs, 0);
                  Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
                },
                child: Image.asset(
                  AppConstant.imgIcAppLogo,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                "Expense",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.search),
          ],
        ),
      ),
      body: mPages[selectedIndex],
      bottomNavigationBar:  BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink.shade200,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 26,
        unselectedItemColor: Colors.grey,

        onTap: (index){
          if(index==2){
            Navigator.pushNamed(context, AppRoutes.addExpensePage);
          }
          selectedIndex = index;
          setState(() {
          });
        },
        currentIndex: selectedIndex,
        items:[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined),label: "Stats"),
          BottomNavigationBarItem(icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.pink.shade200,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(Icons.add,color: Colors.white,),
          ),label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none),label: "Notification"),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined),label: "Profile"),
        ],
      ),
    );
  }
}
