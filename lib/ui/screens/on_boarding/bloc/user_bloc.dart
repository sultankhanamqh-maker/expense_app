import 'package:expense1/data/local/helper/db_helper.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc_event.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserBlocEvent , UserBlocState>{
  DbHelper dbHelper;
  UserBloc({required this.dbHelper}) : super(UserInitialState()){

    on<UserRegisterEvent>((event, emit)async{
      emit(UserLoadingState());
      int check = await dbHelper.registerUser(newUser: event.newUser);
      if(check == 3){
        emit(UserSuccessState());
      }
      else if (check == 2){
        emit(UserErrorState(errorMsg: "User Already Exist"));
      }
      else {
        emit(UserErrorState(errorMsg: "SomeThing went wrong!"));
      }

    });

    on<UserLoginEvent>((event,emit)async{
      emit(UserLoadingState());
      int check = await dbHelper.loginUser(email: event.email, pass: event.password);
      if(check == 3){
        emit(UserSuccessState());
      }
      else if(check == 1){
        emit(UserErrorState(errorMsg: "Your Password is Incorrect"));
      }
      else{
        emit(UserErrorState(errorMsg: "Your Email is Incorrect"));
      }


    });

    on<GetAllUserEvent>((event,emit)async{
      emit(UserLoadingState());
      var user = await dbHelper.getUser();
      if(user.isNotEmpty){
        emit(UserExistState(allUser: user));
      }
      else{
        emit(UserErrorState(errorMsg: "SomeThing Went Wrong!"));
      }

    });


  }
}