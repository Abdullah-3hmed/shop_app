import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_cubit/shop_app_cubit.dart';
import 'package:shop_app/cubit/shop_cubit/shop_app_states.dart';
import 'package:shop_app/modules/login/shop_login_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/components/components.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var emailController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopAppCubit.get(context).userModel;
        nameController.text = model!.data!.name!;
        phoneController.text = model.data!.phone!;
        emailController.text = model.data!.email!;
        return ConditionalBuilder(
          condition: ShopAppCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state is ShopAppUpdateUserDataLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultTextFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      prefixIcon: const Icon(Icons.person),
                      obscureText: false,
                      text: 'Name',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultTextFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email),
                      obscureText: false,
                      text: 'Email Address',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultTextFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone),
                      obscureText: false,
                      text: 'Phone',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ShopAppCubit.get(context).updateUserData(
                              name: nameController.text,
                              phone: phoneController.text,
                              email: emailController.text,
                            );
                          }
                        },
                        child: const Text('UPDATE'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          CacheHelper.removeData(key: 'token').then((value) {
                            if (value) {
                              navigateAndFinish(
                                context,
                                const ShopLoginScreen(),
                              );
                              ShopAppCubit.get(context).currentIndex = 0;
                            }
                          });
                        },
                        child: const Text('LOGOUT'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
