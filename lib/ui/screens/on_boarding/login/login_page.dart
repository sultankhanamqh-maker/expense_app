// ignore_for_file: must_be_immutable

import 'package:expense1/domain/constants/app_routes.dart';
import 'package:expense1/ui/custom_widgets/elevated_btn.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc_event.dart';
import 'package:expense1/ui/screens/on_boarding/bloc/user_bloc_state.dart';
import 'package:expense1/ui/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  bool passwordVisible = false;

  bool isLoading = false;
  bool isLogin = false;

  var emailController = TextEditingController();

  var passController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginPage({super.key});

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
              Text("Welcome' back "),
              SizedBox(height: 11),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  final bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value ?? "");
                  if (value == null || value.isEmpty) {
                    return "Please Enter your email";
                  }
                  if (!emailValid) {
                    return "Please Enter valid Email";
                  }
                  return null;
                },
                decoration: myDecor(hint: "Enter Your Email", label: "Email"),
              ),
              SizedBox(height: 11),
              StatefulBuilder(
                builder: (context, ss) {
                  return TextFormField(
                    controller: passController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter your Password";
                      }
                      return null;
                    },
                    obscureText: !passwordVisible,
                    decoration: myDecor(
                      hint: "Enter your Password",
                      label: "Password",
                      isPassword: true,
                      passWordVisible: passwordVisible,
                      onTap: () {
                        passwordVisible = !passwordVisible;
                        ss(() {});
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 11),
              BlocListener<UserBloc, UserBlocState>(
                listenWhen: (pre, curr) {
                  return isLogin;
                },
                listener: (context, state) async {
                  if (state is UserLoadingState) {
                    isLoading = true;
                  }
                  if (state is UserSuccessState) {
                    isLoading = false;
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.dashBoardPage,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Your are Logged in Successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  if (state is UserErrorState) {
                    isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMsg),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: ElevatedBtn(
                  isWidget: true,
                  widget: isLoading ? CircularProgressIndicator() : Container(),
                  title: "Log In",
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      isLogin = true;
                      context.read<UserBloc>().add(
                        UserLoginEvent(
                          email: emailController.text,
                          password: passController.text,
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 11),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.signUpPage);
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Already Have an Account ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "Create an account",
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
