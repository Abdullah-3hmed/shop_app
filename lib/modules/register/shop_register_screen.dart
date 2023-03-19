import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_register_cubit/register_cubit.dart';
import 'package:shop_app/cubit/shop_register_cubit/register_states.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_screen.dart';

import '../../network/local/cache_helper.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class ShopRegisterScreen extends StatelessWidget {
  const ShopRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocProvider(
      create: (context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.loginModel.status) {
              showToast(
                message: state.loginModel.message!,
                state: ToastStates.success,
              );
              CacheHelper.saveData(
                key: 'token',
                value: ShopRegisterCubit.get(context).loginModel!.data!.token,
              ).then((value) {
                token = ShopRegisterCubit.get(context).loginModel!.data!.token;
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
                          'Register',
                          style:
                              Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Register now to browse our hot offers ',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                          text: 'User Name',
                          prefixIcon: const Icon(Icons.person),
                          type: TextInputType.name,
                          controller: nameController,
                          obscureText: false,
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
                            obscureText: ShopRegisterCubit.get(context).isPassword,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                ShopRegisterCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              child: Icon(
                                ShopRegisterCubit.get(context).suffix,
                              ),
                            ),
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                ShopRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            }),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                          text: 'Phone',
                          prefixIcon: const Icon(Icons.phone),
                          type: TextInputType.phone,
                          controller: phoneController,
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => Container(
                            height: 60.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  ShopRegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const ShopRegisterScreen(),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Register'),
                            ),
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
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
