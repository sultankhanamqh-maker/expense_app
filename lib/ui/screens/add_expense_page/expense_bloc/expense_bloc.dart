import 'package:expense1/data/local/helper/db_helper.dart';
import 'package:expense1/data/model/cat_model.dart';
import 'package:expense1/data/model/expense_model.dart';
import 'package:expense1/data/model/filterExpenseModel.dart';
import 'package:expense1/domain/constants/app_constants.dart';
import 'package:expense1/ui/screens/add_expense_page/expense_bloc/expense_bloc_event.dart';
import 'package:expense1/ui/screens/add_expense_page/expense_bloc/expense_bloc_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExpenseBloc extends Bloc<ExpenseBlocEvent, ExpenseBlocState> {
  DbHelper dbHelper;

  num totalBal = 0.0;

  /// this is for date
  DateFormat df = DateFormat.yMMMMd();

  /// this is for month and year
  DateFormat dfMonth = DateFormat('MMMM, yyyy');

  /// this is for year only
  DateFormat dfYear = DateFormat('yyyy');

  ExpenseBloc({required this.dbHelper}) : super(ExpenseInitialState()) {
    on<AddExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());

      bool isAdded = await dbHelper.addExpense(expenseModel: event.mExpense);
      if (isAdded) {
        var allExp = await dbHelper.getExpenses();
        emit(
          ExpenseLoadedState(allExp: filteredExpense(allExp: allExp, flag: 1)),
        );
      } else {
        emit(ExpenseErrorState(errorMsg: "Something Went Wrong"));
      }
    });

    on<FetchInitialExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());

      var allExp = await dbHelper.getExpenses();

      emit(
        ExpenseLoadedState(
          allExp: filteredExpense(allExp: allExp, flag: event.flag),
        ),
      );
    });

    on<CurrBalanceEvent>((event, emit) async {
      emit(ExpenseLoadingState());
      double currBal = await dbHelper.currBalance();
      if (currBal < 0) {
        emit(ExpenseErrorState(errorMsg: "You don't have that much Money!"));
      }
      emit(ExpenseBalanceLoadedState(bal: currBal));
    });
  }

  List<FilteredExpenseModel> filteredExpense({
    required List<ExpenseModel> allExp,
    required int flag,
  }) {
    if (flag == 1) {
      return dfFormat(allExp: allExp, format: df);
    } else if (flag == 2) {
      return dfFormat(allExp: allExp, format: dfMonth);
    } else if (flag == 3) {
      return dfFormat(allExp: allExp, format: dfYear);
    } else if(flag == 4) {
      return DebitCreditFormat(allExp: allExp);
    }
    else {
      return catType(allExp);
    }
  }

  /// this is search using date, month and year wise data
  List<FilteredExpenseModel> dfFormat({
    required List<ExpenseModel> allExp,
    required DateFormat format,
  }) {
    List<FilteredExpenseModel> allFilteredExpense = [];

    /// date wise -> flag  = 1
    Set<String> uniqueDates = {};

    for (ExpenseModel eachExp in allExp) {
      String eachDate = format.format(
        DateTime.fromMillisecondsSinceEpoch(eachExp.createdAt),
      );
      uniqueDates.add(eachDate);
    }

    for (String eachUniqueDate in uniqueDates) {
      totalBal = 0.0;
      List<ExpenseModel> eachDateExpense = [];
      for (ExpenseModel eachExp in allExp) {
        String eachDate = format.format(
          DateTime.fromMillisecondsSinceEpoch(eachExp.createdAt),
        );
        if (eachUniqueDate == eachDate) {
          eachDateExpense.add(eachExp);
          if (eachExp.expType == 1) {
            totalBal -= eachExp.amt;
          } else {
            totalBal += eachExp.amt;
          }
        }
      }
      allFilteredExpense.add(
        FilteredExpenseModel(
          title: eachUniqueDate,
          balance: totalBal,
          allExp: eachDateExpense,
        ),
      );
    }
    return allFilteredExpense;
  }

  List<FilteredExpenseModel> DebitCreditFormat({
    required List<ExpenseModel> allExp,
  }) {
    List<FilteredExpenseModel> allFilteredExpense = [];

    Set<int> debitCreditType = {1, 2};

    for (int type in debitCreditType) {
      totalBal = 0.0;
      List<ExpenseModel> uniqueExpense = [];

      for (ExpenseModel eachExp in allExp) {
        int eachType = eachExp.expType;
        if (type == eachType) {
          uniqueExpense.add(eachExp);
          if (type == 1) {
            totalBal += eachExp.amt;
          } else {
            totalBal += eachExp.amt;
          }
        }
      }
      if(uniqueExpense.isNotEmpty){
        allFilteredExpense.add(
          FilteredExpenseModel(
            title: type == 1 ? "Debit" : "Credit",
            balance: totalBal,
            allExp: uniqueExpense,
          ),
        );
      }
    }

    return allFilteredExpense;
  }

  List<FilteredExpenseModel> catType(List<ExpenseModel> allExp) {
    List<FilteredExpenseModel> allFilterExpense = [];

    List<CatModel> uniqueId = AppConstant.allCat;

    for (CatModel eachCat in uniqueId) {
      totalBal = 0.0;
      List<ExpenseModel> uniqueExp = [];

      for (ExpenseModel eachExp in allExp) {
        if (eachExp.catId == eachCat.id) {
          uniqueExp.add(eachExp);

          if (eachExp.expType == 1) {
            totalBal -= eachExp.amt;
          } else {
            totalBal += eachExp.amt;
          }
        }
      }
      if(uniqueExp.isNotEmpty){
        allFilterExpense.add(
          FilteredExpenseModel(
            title: eachCat.title,
            balance: totalBal,
            allExp: uniqueExp,
          ),
        );
      }

    }
    return allFilterExpense;
  }
}
