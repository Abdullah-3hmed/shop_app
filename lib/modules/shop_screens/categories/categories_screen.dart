import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_cubit/shop_app_cubit.dart';
import 'package:shop_app/cubit/shop_cubit/shop_app_states.dart';
import 'package:shop_app/models/categories_model/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) =>
              buildCatItem(ShopAppCubit.get(context).categoriesModel, index),
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[300],
            thickness: 3,
            indent: 20.0,
            endIndent: 20.0,
          ),
          itemCount:
              ShopAppCubit.get(context).categoriesModel!.data!.data.length,
        );
      },
    );
  }

  Widget buildCatItem(CategoriesModel? model, int index) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: model!.data!.data[index].image,
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Text(
                model.data!.data[index].name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
            ),
          ],
        ),
      );
}
