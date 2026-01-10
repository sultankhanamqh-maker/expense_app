import 'package:expense1/data/model/user_model.dart';
import 'package:expense1/domain/constants/app_routes.dart';
import 'package:expense1/ui/custom_widgets/elevated_btn.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc_event.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc_state.dart';
import 'package:expense1/ui/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class SignUpPage extends StatelessWidget {
  bool passWordVisible = false;
  bool confirmPassWordVisible = false;
  bool isLoading = false;
  bool isSignUpBuilder = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Create an Acount"),
              SizedBox(height: 11),
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter your Name";
                  }
                  if (value.length < 3) {
                    return "Please Enter valid Name";
                  }
                  return null;
                },
                decoration: myDecor(hint: "Enter your Name", label: "Name"),
              ),
              SizedBox(height: 11),
              TextFormField(

                controller: emailController,
                validator: (value) {
                  final bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value ?? "");
                  if (value == null || value.isEmpty) {
                    return "Please Enter your Email";
                  }
                  if (!emailValid) {
                    return "Please Enter a valid Email";
                  }
                  return null;
                },
                decoration: myDecor(hint: "Enter your Email", label: "Email"),
              ),
              SizedBox(height: 11),
              TextFormField(
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return "Please Enter your Name";
                  }
                  if(value!.length < 10){
                    return "Please enter a valid number";
                  }
                  return null;
                },
                controller: mobileController,
                decoration: myDecor(
                  hint: "Enter your Mobile No",
                  label: "Mobile No",
                ),
              ),
              SizedBox(height: 11),

              StatefulBuilder(
                builder: (context, ss) {
                  return TextFormField(
                    controller: passController,
                    validator: (value) {
                      final bool passValid = RegExp(
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                      ).hasMatch(value ?? "");
                      if (value == null || value.isEmpty) {
                        return "Please Enter  Password";
                      }
                      if (!passValid) {
                        return "Please Enter valid Password";
                      }
                      return null;
                    },
                    obscureText: !passWordVisible,
                    decoration: myDecor(
                      hint: "Enter your Password ",
                      label: "Password",
                      isPassword: true,
                      passWordVisible: passWordVisible,
                      onTap: () {
                        passWordVisible = !passWordVisible;
                        ss(() {});
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 11),
              StatefulBuilder(
                builder: (context, ss) {
                  return TextFormField(
                    controller: confirmPassController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Re_type Your Password";
                      }
                      if (value != passController.text) {
                        return "Please Enter Same Password";
                      }
                      return null;
                    },
                    obscureText: !confirmPassWordVisible,
                    decoration: myDecor(
                      hint: "Re_type to Confirm password",
                      label: "Confirm Password",
                      isPassword: true,
                      passWordVisible: confirmPassWordVisible,
                      onTap: () {
                        confirmPassWordVisible = !confirmPassWordVisible;
                        ss(() {});
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 11),
              BlocConsumer<UserBloc, UserBlocState>(
                buildWhen: (prev,curr){
                  return isSignUpBuilder;
                },
                  listenWhen: (prev,curr){
                  return isSignUpBuilder;
                  },
                listener: (context,state){
                  if(state is UserLoadingState){
                    isLoading = true;
                  }
                  if(state is UserSuccessState){
                    isLoading = false;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your Account has Created",style: TextStyle(color: Colors.white),),backgroundColor: Colors.amber,));
                  }
                  if(state is UserErrorState){
                    isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMsg,style: TextStyle(color: Colors.white),),backgroundColor: Colors.amber,));
                  }
                },
                builder: (context,state) {
                  return ElevatedBtn(
                    title: "Sign Up",
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        isSignUpBuilder = true;
                        context.read<UserBloc>().add(
                          UserRegisterEvent(
                            newUser: UserModel(
                              name: nameController.text,
                              email: emailController.text,
                              mobilNo: mobileController.text,
                              pass: passController.text,
                            ),
                          ),
                        );
                      }
                    },isWidget: isLoading,
                    widget: isLoading ?CircularProgressIndicator(backgroundColor: Colors.white,) : null,
                  );
                }
              ),
              SizedBox(height: 11),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.loginPage);
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Already Have an Account ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "Log In",
                        style: TextStyle(color: Colors.amber),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
