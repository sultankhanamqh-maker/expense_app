import 'package:expense1/data/local/helper/db_helper.dart';
import 'package:expense1/data/model/expense_model.dart';
import 'package:expense1/domain/constants/app_constants.dart';
import 'package:expense1/ui/custom_widgets/elevated_btn.dart';
import 'package:expense1/ui/custom_widgets/outlined_btn.dart';
import 'package:expense1/ui/screens/add_expense_page/expense_bloc/expense_bloc.dart';
import 'package:expense1/ui/screens/add_expense_page/expense_bloc/expense_bloc_event.dart';
import 'package:expense1/ui/screens/add_expense_page/expense_bloc/expense_bloc_state.dart';
import 'package:expense1/ui/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  DbHelper dbHelper = DbHelper.instance;
  List<String> mTypes = ["Debit", "Credit"];

  String selectedType = "Debit";

  /// for select category
  int selectedIndex = -1;

  bool isWidget = false;

  bool isAdded = false;

  /// to check expense bloc called or not
  bool isExpenseBuildCalled = false;

  /// these are for datea and time
  DateTime? selectedDate;

  TimeOfDay? selectedTime;

  DateTime? selectedDateTime;

  DateFormat df = DateFormat();

  num prevBal = 0;

  /// to check wheather clicked or not
  bool isClicked = false;

  /// this key is for validator
  GlobalKey<FormState> mKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var descController = TextEditingController();

  var amtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     prevBal = ModalRoute.of(context)!.settings.arguments as num;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: mKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Your title";
                  }
                  return null;
                },
                decoration: myDecor(hint: "Enter Your Title", label: "Title"),
              ),
              SizedBox(height: 11),
              TextFormField(
                controller: descController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Your Description";
                  }
                  return null;
                },
                decoration: myDecor(hint: "Enter Your Desc", label: "Desc"),
              ),
              SizedBox(height: 11),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: amtController,
                validator: (value) {
                  final numberRegExp = RegExp(r'^\d+$');
                  if (value == null || value.isEmpty) {
                    return "Please Enter Your Amount";
                  }
                  if (!numberRegExp.hasMatch(value)) {
                    return "Invalid Amount";
                  }

                  return null;
                },
                decoration: myDecor(hint: "Enter Your Amount", label: "Amount"),
              ),
              SizedBox(height: 11),
              StatefulBuilder(
                builder: (context, ss) {
                  return DropdownMenu(
                    label: Text("Type"),
                    width: double.infinity,
                    initialSelection: selectedType,
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onSelected: (value) {
                      selectedType = value!;
                      ss(() {});
                    },
                    dropdownMenuEntries: mTypes.map((e) {
                      return DropdownMenuEntry(value: e, label: e);
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 11),
              StatefulBuilder(
                builder: (context, ss) {
                  return OutlinedBtn(
                    title: selectedIndex > -1
                        ? AppConstant.allCat[selectedIndex].title
                        : "Select Category",
                    isWidget: selectedIndex > -1 ? isWidget : isWidget = false,
                    widget: selectedIndex > -1
                        ? Image.asset(
                            AppConstant.allCat[selectedIndex].imgPath,
                            width: 30,
                            height: 30,
                          )
                        : null,
                    onTap: () {
                      isClicked = true;
                      showModalBottomSheet(
                        context: context,
                        builder: ((context) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            child: GridView.builder(
                              itemCount: AppConstant.allCat.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                  ),
                              itemBuilder: ((context, index) {
                                return InkWell(
                                  onTap: () {
                                    selectedIndex = index;
                                    isWidget = true;
                                    ss(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        AppConstant.allCat[index].imgPath,
                                        width: 40,
                                        height: 40,
                                      ),
                                      SizedBox(height: 5),
                                      Text(AppConstant.allCat[index].title),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 11),
              StatefulBuilder(
                builder: (_, ss) {
                  return OutlinedBtn(
                    onTap: () async {
                      selectedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );

                      selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: DateTime.now().hour,
                          minute: DateTime.now().minute,
                        ),
                      );

                      DateTime userDate = selectedDate ?? DateTime.now();
                      TimeOfDay userTime = selectedTime ?? TimeOfDay.now();

                      selectedDateTime = DateTime(
                        userDate.year,
                        userDate.month,
                        userDate.day,
                        userTime.hour,
                        userTime.minute,
                      );
                      ss(() {});
                    },
                    title: df.format(selectedDateTime ?? DateTime.now()),
                  );
                },
              ),
              SizedBox(height: 11),
              BlocListener<ExpenseBloc, ExpenseBlocState>(
                listenWhen: (pre, curr) {
                  return isExpenseBuildCalled;
                },
                listener: (_, state) {
                  if (state is ExpenseErrorState) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.errorMsg)));
                  }
                  if (state is ExpenseLoadedState) {
                    isAdded = true;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Expense has added successfully"),backgroundColor: Colors.green,),
                    );
                    Navigator.pop(context);
                  }
                },
                  child: ElevatedBtn(
                    title: "Add Expense",
                    onTap: () async{
                       num updateBal = 0;
                      double amt = double.parse(amtController.text);
                      if(selectedType == "Debit"){
                        updateBal = prevBal - amt;
                      }
                      else {
                        updateBal = prevBal + amt;
                      }


                      if (mKey.currentState!.validate()){
                        isExpenseBuildCalled = true;
                        if (isClicked){
                          context.read<ExpenseBloc>().add(
                            AddExpenseEvent(
                              mExpense: ExpenseModel(
                                title: titleController.text,
                                desc: descController.text,
                                amt: double.parse(amtController.text),
                                bal: updateBal,
                                expType: selectedType == "Debit" ? 1 : 2,
                                catId: AppConstant.allCat[selectedIndex].id,
                                createdAt: (selectedDateTime ?? DateTime.now())
                                    .millisecondsSinceEpoch,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please Select Category"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    bgColor: Colors.pink.shade200,
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
