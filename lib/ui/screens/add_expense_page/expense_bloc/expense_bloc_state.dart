import 'package:expense1/data/model/filterExpenseModel.dart';

abstract class ExpenseBlocState {}

class ExpenseInitialState extends ExpenseBlocState{}
class ExpenseLoadingState extends ExpenseBlocState{}
class ExpenseLoadedState extends ExpenseBlocState{
  List<FilteredExpenseModel> allExp;
  ExpenseLoadedState({required this.allExp ,});
}

class ExpenseErrorState extends ExpenseBlocState{
  String errorMsg;
  ExpenseErrorState({required this.errorMsg});
}

class ExpenseBalanceLoadedState extends ExpenseBlocState{
  double bal;
  ExpenseBalanceLoadedState({required this.bal});
}