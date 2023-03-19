import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/cubit/shop_cubit/shop_app_cubit.dart';
import '../../modules/login/shop_login_screen.dart';
import '../../network/local/cache_helper.dart';

void showToast({
  required String message,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state: state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastStates { success, error, warning }

Color chooseToastColor({required ToastStates state}) {
  Color color;
  switch (state) {
    case ToastStates.success:
      {
        color = Colors.green;
        break;
      }
    case ToastStates.error:
      {
        color = Colors.red;
        break;
      }
    case ToastStates.warning:
      {
        color = Colors.amberAccent;
        break;
      }
  }
  return color;
}

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      navigateAndFinish(
        context,
        const ShopLoginScreen(),
      );
    }
  });
}

Widget defaultTextFormField({
  TextEditingController? controller,
  required TextInputType type,
  required Widget prefixIcon,
  Widget? suffixIcon,
  required bool obscureText,
  required String text,
  Function(String)? onSubmit,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscureText,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        label: Text(
          text,
        ),
        contentPadding: const EdgeInsets.all(20.0),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$text required';
        }
        return null;
      },
    );

Future navigateAndFinish(
  BuildContext context,
  Widget screen,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (route) => false,
    );

Widget buildListProduct(model, context, {bool isOldPrice = true}) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 120.0,
        width: 120.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                CachedNetworkImage(
                  imageUrl: model.image ?? '',
                  width: 120.0,
                  height: 120.0,
                ),
                if (model.discount != 0 && isOldPrice)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.red,
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                        fontSize: 8.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        r'$'
                        ' ${model.price.round()}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0 && isOldPrice)
                        Text(
                          r'$'
                          ' ${model.oldPrice.round()}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          ShopAppCubit.get(context)
                              .changeFavorites(model.id ?? 1);
                        },
                        icon: CircleAvatar(
                          backgroundColor:
                              ShopAppCubit.get(context).favorites[model.id] ??
                                      false
                                  ? Colors.blue
                                  : Colors.grey,
                          radius: 20.0,
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
