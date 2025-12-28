import 'dart:math';

import 'package:expense1/data/local/helper/db_helper.dart';
import 'package:expense1/domain/constants/app_constants.dart';
import 'package:expense1/domain/constants/app_routes.dart';
import 'package:expense1/ui/screens/add_expense_page/expense_bloc/expense_bloc.dart';
import 'package:expense1/ui/screens/add_expense_page/expense_bloc/expense_bloc_event.dart';
import 'package:expense1/ui/screens/add_expense_page/expense_bloc/expense_bloc_state.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../on_boarding/bloc/user_bloc_state.dart' show UserBlocState, UserLoadingState, UserExistState, UserErrorState;

class NavHomePage extends StatefulWidget {
  const NavHomePage({super.key});

  @override
  State<NavHomePage> createState() => _NavHomePageState();
}

class _NavHomePageState extends State<NavHomePage> {
  List<String> dropItemList = ["Days", "Months", "Years", "Debit/Credit","Category"];

  DbHelper dbHelper = DbHelper.instance;
  int selectedType = 1;

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(
      FetchInitialExpenseEvent(flag:1),
    );
    context.read<UserBloc>().add(GetAllUserEvent());
    getCurrBalance();
  }
  Future<double> getCurrBalance()async{
    return await dbHelper.currBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
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
                                    selectedType = value!;
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
              BlocBuilder<ExpenseBloc, ExpenseBlocState>(
                builder: (context, state) {
                  if (state is ExpenseLoadingState) {
                    return CircularProgressIndicator();
                  }
                  if (state is ExpenseErrorState) {
                    return ScaffoldMessenger(
                      child: Text("Something has went Wrong"),
                    );
                  }
                  if (state is ExpenseLoadedState) {
                    return state.allExp.isNotEmpty ? Column(
                      children: [
                        Container(
                          height: 156,
                          padding: EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xff6674d3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Expense total ",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                "",//${state.allExp[i].balance}
                                style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 11),
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
                         ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: state.allExp.length,
                          itemBuilder: (context, index) {
                            var filterList = state.allExp[index];
                            return Container(
                              padding: EdgeInsets.all(11),
                              margin: EdgeInsets.symmetric(vertical: 6)   ,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: BoxBorder.all(color: Colors.grey),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        filterList.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        filterList.balance.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 11),
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 11),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                    state.allExp[index].allExp.length,
                                    itemBuilder: (_, childIndex) {
                                      var expList = state
                                          .allExp[index]
                                          .allExp[childIndex];
                                      String imgPath = AppConstant.allCat
                                          .firstWhere((e) {
                                        return e.id == expList.catId;
                                      })
                                          .imgPath;
                                      return ListTile(
                                        leading: Container(
                                          padding: EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .primaries[Random().nextInt(
                                              Colors.primaries.length,
                                            )]
                                                .shade100,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Image.asset(
                                            imgPath,
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                        title: Text(
                                          expList.title,
                                          style: TextStyle(fontSize: 19),
                                        ),
                                        subtitle: Text(
                                          expList.desc,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        trailing: expList.expType == 1
                                            ? Text(
                                          "-${expList.amt}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.pink.shade200,
                                          ),
                                        )
                                            : Text(
                                          "${expList.amt}",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ) : Center(child: Text("No Expense Yet"));
                  }

                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
