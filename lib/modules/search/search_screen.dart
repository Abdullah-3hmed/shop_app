import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/search_cubit/search_cubit.dart';
import 'package:shop_app/cubit/search_cubit/search_states.dart';
import 'package:shop_app/shared/components/components.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultTextFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      prefixIcon: const Icon(Icons.search),
                      obscureText: false,
                      text: 'Search',
                      onSubmit: (String value) {
                        SearchCubit.get(context).searchProduct(text: value);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (state is SearchLoadingState)
                      const LinearProgressIndicator(),
                    if(state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) => buildListProduct(
                          SearchCubit.get(context)
                              .searchModel!
                              .data!
                              .data![index],
                          context,
                          isOldPrice: false,
                        ),
                        separatorBuilder: (context, index) => Divider(
                          thickness: 3,
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey[300],
                        ),
                        itemCount: SearchCubit.get(context)
                            .searchModel!
                            .data!
                            .data!.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
