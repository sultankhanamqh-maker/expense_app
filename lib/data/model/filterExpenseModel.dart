import 'package:expense1/data/model/expense_model.dart';

class FilteredExpenseModel{
  String title;
  num balance;
  List<ExpenseModel> allExp;
  FilteredExpenseModel({required this.title, required this.balance,required this.allExp});
}