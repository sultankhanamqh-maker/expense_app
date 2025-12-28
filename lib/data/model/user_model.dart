import 'package:expense1/domain/constants/app_constants.dart';

class UserModel {
  int? id;
  String name;
  String mobilNo;
  String email;
  String? pass;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.mobilNo,
    this.pass,

  });

  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
        id: map[AppConstant.userColumnId],
        name: map[AppConstant.userColumnName],
        email: map[AppConstant.userColumnEmail],
        mobilNo: map[AppConstant.userColumnMobile]);
  }

  Map<String, dynamic> toMap() {
    return {
      AppConstant.userColumnName : name,
      AppConstant.userColumnEmail : email,
      AppConstant.userColumnMobile : mobilNo,
      AppConstant.userColumnPassword : pass
    };
  }
}
