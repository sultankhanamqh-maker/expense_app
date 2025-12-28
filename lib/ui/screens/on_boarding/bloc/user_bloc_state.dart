import 'package:expense1/data/model/user_model.dart';

abstract class UserBlocState {}

class UserInitialState extends UserBlocState{}
class UserLoadingState extends UserBlocState{}
class UserSuccessState extends UserBlocState{}
class UserExistState extends UserBlocState{
  List<UserModel> allUser;
  UserExistState({required this.allUser});
}
class UserErrorState extends UserBlocState{
  String errorMsg;
  UserErrorState({required this.errorMsg});
}