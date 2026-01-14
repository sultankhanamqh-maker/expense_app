import 'package:expense1/data/model/filterExpenseModel.dart';

abstract class ExpenseBlocState {
}

class ExpenseInitialState extends ExpenseBlocState{}
class ExpenseLoadingState extends ExpenseBlocState{}
class ExpenseLoadedState extends ExpenseBlocState{
  List<FilteredExpenseModel> allExp;
  num mainBalance;
  ExpenseLoadedState({required this.allExp ,required this.mainBalance});
}

class ExpenseErrorState extends ExpenseBlocState{
  String errorMsg;
  ExpenseErrorState({required this.errorMsg});
}

