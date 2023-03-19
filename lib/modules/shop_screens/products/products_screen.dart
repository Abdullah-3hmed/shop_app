import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_cubit/shop_app_cubit.dart';
import 'package:shop_app/cubit/shop_cubit/shop_app_states.dart';
import 'package:shop_app/models/categories_model/categories_model.dart';
import 'package:shop_app/shared/components/components.dart';

import '../../../models/home_model/shop_home_model.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
        listener: (context, state) {
      if (state is ShopAppChangeFavoritesSuccessState) {
        if (state.changeFavoritesModel.status == false) {
          showToast(
            message: state.changeFavoritesModel.message ?? '',
            state: ToastStates.error,
          );
        }
      }
    }, builder: (context, state) {
      return ConditionalBuilder(
        condition: ShopAppCubit.get(context).homeModel != null &&
            ShopAppCubit.get(context).categoriesModel != null,
        builder: (context) => productsBuilder(
          ShopAppCubit.get(context).homeModel!,
          ShopAppCubit.get(context).categoriesModel!,
          context,
        ),
        fallback: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  Widget productsBuilder(
    HomeModel model,
    CategoriesModel categoriesModel,
    context,
  ) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data.banners
                  .map(
                    (e) => CachedNetworkImage(
                      imageUrl: e.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 220.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                viewportFraction: 1.0,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 100.0,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => buildCategoryItem(
                        categoriesModel,
                        index,
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10.0,
                      ),
                      itemCount: categoriesModel.data!.data.length,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1 / 1.6,
                children: List.generate(
                  model.data.products.length,
                  (index) => buildGridProduct(index, model, context),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildCategoryItem(
    CategoriesModel model,
    int index,
  ) =>
      Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          CachedNetworkImage(
            imageUrl: model.data!.data[index].image,
            placeholder: (context, url) => const CircularProgressIndicator(),
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
          Container(
            width: 100.0,
            color: Colors.black.withOpacity(.8),
            child: Text(
              model.data!.data[index].name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );

  Widget buildGridProduct(
    int index,
    HomeModel model,
    context,
  ) =>
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                CachedNetworkImage(
                  imageUrl: model.data.products[index].image,
                  height: 200.0,
                  width: double.infinity,
                ),
                if (model.data.products[index].discount != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.red,
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.data.products[index].name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        r'$' ' ${model.data.products[index].price.round()}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if (model.data.products[index].discount != 0)
                        Text(
                          r'$'
                          ' ${model.data.products[index].oldPrice.round()}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopAppCubit.get(context).changeFavorites(
                            model.data.products[index].id,
                          );
                        },
                        icon: CircleAvatar(
                          backgroundColor: ShopAppCubit.get(context).favorites[
                                      model.data.products[index].id] ??
                                  true
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
      );
}
