import 'package:expense1/data/model/cat_model.dart';
import 'package:expense1/ui/screens/add_expense_page/expense_bloc/expense_bloc_state.dart';
import 'package:expense1/ui/screens/dashbaord/nav_pages/nav_home_page.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../add_expense_page/expense_bloc/expense_bloc.dart' show ExpenseBloc;
import '../../add_expense_page/expense_bloc/expense_bloc_event.dart';

class NavStatsPage extends StatelessWidget{

  int selectedType = 1;
  List<String> dropItemList = ["Days", "Months", "Years", "Debit/Credit","Category"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
        child: Column(
          children: [
            BlocBuilder<UserBloc,UserBlocState>(
              builder: (context, state) {
                if(state is UserLoadingState){
                  return CircularProgressIndicator();
                }
                if(state is UserExistState){
                  for(int i = 0; i < state.allUser.length;){
                    return SizedBox(
                      height: 90,
                      child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(state.allUser[i].name),
                          subtitle: Text(state.allUser[i].email),
                          trailing: SizedBox(
                            width: 150,
                            child: DropdownMenu(
                                onSelected: (value){
                                  selectedType = value!+1;
                                  context.read<ExpenseBloc>().add(FetchInitialExpenseEvent(flag: value));
                                },
                                inputDecorationTheme: InputDecorationTheme(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                ),
                                initialSelection: selectedType,
                                dropdownMenuEntries: List.generate(dropItemList.length, (i){
                                  return DropdownMenuEntry(value: i+1, label: dropItemList[i]);
                                })),
                          )
                      ),
                    );
                  }
                }
                if(state is UserErrorState){
                  return ScaffoldMessenger(child: Text(state.errorMsg));
                }
                return Container();
              },

            ),
            Container(
              padding: EdgeInsets.all(15),
              height: 126,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff6674d3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Expense",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(0xffd86765),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text(
                            "+\$230",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 11),
                      Text(
                        "Then Last Month",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 11,),
            BlocBuilder<ExpenseBloc,ExpenseBlocState>(builder: (context, state){
              if(state is ExpenseLoadingState){
                return CircularProgressIndicator();
              }
              if (state is ExpenseLoadedState){
                return Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: state.allExp.isNotEmpty ? BarChart(
                      BarChartData(
                        barGroups: state.allExp.map((e){
                          String title = e.title;
                          double balance = e.balance.toDouble();
                           return  BarChartGroupData(x: title.length, barRods: [
                             BarChartRodData(toY: balance),
                           ]);
                        }).toList(),
                      ),
                      duration: Duration(milliseconds: 150), // Optional
                      curve: Curves.linear, // Optional
                    ) : Center(child: Text("No Data yet"),)
                );
              }
              if(state is ExpenseErrorState){
                return ScaffoldMessenger(child: Text(state.errorMsg));
              }
              return Container();

            }),
            SizedBox(height: 11,),

          ],
        ),
      ),
    );
  }

}