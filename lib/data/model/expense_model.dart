import 'package:expense1/domain/constants/app_constants.dart';

class ExpenseModel {
  int? id;
  int? userId;
  String title;
  String desc;
  num amt;
  num bal;
  int expType;

  ///1->Debit, 2->Credit
  int catId;
  int createdAt;

  ExpenseModel({
    this.id,
    this.userId,
    required this.title,
    required this.desc,
    required this.amt,
    required this.bal,
    required this.expType,
    required this.catId,
    required this.createdAt,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map) => ExpenseModel(
    id: map[AppConstant.expenColumnId],
    userId: map[AppConstant.userColumnId],
    title: map[AppConstant.expenColumnTitle],
    desc: map[AppConstant.expenColumndesc],
    amt: map[AppConstant.expenColumnAmt],
    bal: map[AppConstant.expenColumnBal],
    expType: map[AppConstant.expenColumnExpType],
    catId: map[AppConstant.expenColumnCatId],
    createdAt: int.parse(map[AppConstant.expenColumnCreatedAt]),
  );

  Map<String, dynamic> toMap() => {
    AppConstant.userColumnId: userId,
    AppConstant.expenColumnTitle: title,
    AppConstant.expenColumndesc: desc,
    AppConstant.expenColumnAmt: amt,
    AppConstant.expenColumnBal: bal,
    AppConstant.expenColumnExpType: expType,
    AppConstant.expenColumnCatId: catId,
    AppConstant.expenColumnCreatedAt: createdAt.toString(),
  };
}
