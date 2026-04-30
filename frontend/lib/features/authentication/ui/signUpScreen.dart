import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/colors.dart';
import '../../../model/signUp_request_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfeild.dart';
import '../bloc/auth_bloc.dart';
import 'loginScreen.dart';
import '../../../core/di/injection.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is SignUpInProgressState) {
              setState(() {
                isLoading = true;
              });
            }

            if (state is SignUpSuccessState) {
              setState(() {
                isLoading = false;
              });

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Loginscreen()),
              );
            }

            if (state is SignUpErrorState) {
              setState(() {
                isLoading = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final authBloc = context.read<AuthBloc>();

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.asset('assets/images/signUp_image.jpg'),
                  ),

                  Expanded(
                    flex: 2,
                    child: Container(
                      width: screenWidth,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.signUpAccentColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: AppColors.fontColorBlack,
                            ),
                          ),

                          const SizedBox(height: 25),

                          CusttomTextfeild(
                            controller: _nameController,
                            labelText: "Name",
                            borderColor: Colors.white,
                          ),

                          const SizedBox(height: 25),

                          CusttomTextfeild(
                            controller: _emailController,
                            labelText: "Email",
                            borderColor: Colors.white,
                          ),

                          const SizedBox(height: 25),

                          CusttomTextfeild(
                            controller: _passwordController,
                            labelText: "Password",
                            borderColor: Colors.white,
                          ),

                          const SizedBox(height: 25),

                          isLoading
                              ? const Center(
                            child: CircularProgressIndicator(),
                          )
                              : GestureDetector(
                            onTap: () {
                              final request = SignUpRequestModel(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              authBloc.add(
                                SignUpEvent(request: request),
                              );
                            },
                            child: CusttomButton(
                              btnWidth: screenWidth,
                              btnText: "SignUp",
                            ),
                          ),

                          const SizedBox(height: 25),

                          Row(
                            children: const [
                              Text(
                                'Already have an account ?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 25),
                              Text(
                                'Login',
                                style: TextStyle(
                                  color: AppColors.accentColor,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}