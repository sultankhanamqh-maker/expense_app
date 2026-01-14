import 'package:expense1/data/model/expense_model.dart';
import 'package:expense1/domain/constants/app_constants.dart';
import 'package:expense1/ui/screens/add_expense_page/expense_bloc/expense_bloc.dart';

abstract class ExpenseBlocEvent {}

class AddExpenseEvent extends ExpenseBlocEvent{
  ExpenseModel mExpense;
  AddExpenseEvent({required this.mExpense});
}
class FetchInitialExpenseEvent extends ExpenseBlocEvent{
  int flag;
  FetchInitialExpenseEvent({this.flag = 1});
}