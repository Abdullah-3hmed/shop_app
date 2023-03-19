import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_login_cubit/login_cubit.dart';
import 'package:shop_app/cubit/shop_login_cubit/login_states.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../register/shop_register_screen.dart';

class ShopLoginScreen extends StatelessWidget {
  const ShopLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status) {
              showToast(
                message: state.loginModel.message!,
                state: ToastStates.success,
              );
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value) {
                token = state.loginModel.data!.token;
                navigateAndFinish(
                  context,
                  const ShopLayoutScreen(),
                );
              });
            } else {
              showToast(
                message: state.loginModel.message!,
                state: ToastStates.error,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:
                              Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'login now to browse our hot offers ',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                          text: 'Email Address',
                          prefixIcon: const Icon(Icons.email_outlined),
                          type: TextInputType.text,
                          controller: emailController,
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                            text: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            type: TextInputType.visiblePassword,
                            controller: passwordController,
                            obscureText: ShopLoginCubit.get(context).isPassword,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                ShopLoginCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              child: Icon(
                                ShopLoginCubit.get(context).suffix,
                              ),
                            ),
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            }),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => Container(
                            height: 65.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              child: const Text('LOGIN'),
                            ),
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ShopRegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text('REGISTER NOW'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
