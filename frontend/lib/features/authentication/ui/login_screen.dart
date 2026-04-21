import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfeild.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.loginBgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: SizedBox(
                  width: screenWidth - 100,
                  child: Lottie.asset('assets/animation/loginAnimation.json'),
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text("Login",
                        style: TextStyle(fontSize: 36)),

                    const SizedBox(height: 25),

                    CusttomTextfeild(
                      controller: _emailController,
                      labelText: "Email",
                      borderColor: AppColors.textFieldBorderColor,
                    ),

                    const SizedBox(height: 20),

                    CusttomTextfeild(
                      controller: _passwordController,
                      labelText: "Password",
                      borderColor: AppColors.textFieldBorderColor,
                    ),

                    const SizedBox(height: 20),

                    BlocConsumer<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }

                        if (state is LoginFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },

                      builder: (context, state) {
                        return CusttomButton(
                          btnWidth: screenWidth,
                          btnText: state is LoginLoading
                              ? "Loading..."
                              : "Login",
                          onTap: () {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();

                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Fill all fields")),
                              );
                              return;
                            }

                            context.read<LoginBloc>().add(
                              LoginButtonPressed(
                                email: email,
                                password: password,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}