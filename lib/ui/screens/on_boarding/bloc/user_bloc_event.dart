import 'package:expense1/data/model/user_model.dart';

abstract class UserBlocEvent{}

class UserRegisterEvent extends UserBlocEvent{
  UserModel newUser;
  UserRegisterEvent({required this.newUser});
}
class UserLoginEvent extends UserBlocEvent{
  String email,password;
  UserLoginEvent({required this.email,required this.password});
}
class GetAllUserEvent extends UserBlocEvent{}