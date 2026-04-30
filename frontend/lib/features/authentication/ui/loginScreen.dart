import 'package:ecommerce_frontend/features/authentication/ui/signUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfeild.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class _LoginscreenState extends State<Loginscreen> {
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
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: AppColors.fontColorBlack,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Welcome back to',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'My Task',
                          style: TextStyle(
                            color: AppColors.accentColor,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    CusttomTextfeild(
                      controller: _emailController,
                      labelText: "Email",
                      borderColor: AppColors.textFieldBorderColor,
                    ),
                    SizedBox(height: 25),
                    CusttomTextfeild(
                      controller: _passwordController,
                      labelText: "Password",
                      borderColor: AppColors.textFieldBorderColor,
                    ),
                    SizedBox(height: 20),
                    CusttomButton(btnWidth: screenWidth, btnText: "Login"),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'dont have an account',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: AppColors.accentColor,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
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
      ),
    );
  }
}