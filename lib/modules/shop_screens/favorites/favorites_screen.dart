import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_cubit/shop_app_cubit.dart';
import 'package:shop_app/cubit/shop_cubit/shop_app_states.dart';
import 'package:shop_app/shared/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopAppCubit.get(context).favoritesModel != null,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildListProduct(
              ShopAppCubit.get(context)
                  .favoritesModel!
                  .data!
                  .data[index]
                  .product!,
              context,
            ),
            separatorBuilder: (context, index) => Divider(
              thickness: 3,
              indent: 10,
              endIndent: 10,
              color: Colors.grey[300],
            ),
            itemCount:
                ShopAppCubit.get(context).favoritesModel!.data!.data.length,
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
