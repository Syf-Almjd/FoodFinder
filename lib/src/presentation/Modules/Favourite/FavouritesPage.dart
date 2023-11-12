import 'package:flutter/material.dart';
import 'package:foodfinder/src/config/utils/managers/app_constants.dart';
import 'package:foodfinder/src/data/local/localData_cubit/local_data_cubit.dart';
import 'package:foodfinder/src/presentation/Shared/Components.dart';

import '../../../config/utils/styles/app_colors.dart';
import '../../../domain/models/FoodModel.dart';
import '../Home/Builders/FoodItem.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Meal> meals = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getLocalData();
  }

  getLocalData() async {
    var items = await LocalDataCubit.get(context)
        .getSharedDataList(AppConstants.favListNum);
    for (var element in items) {
      meals.add(Meal.fromJson(
          await LocalDataCubit.get(context).getSharedMap(element.toString())));
    }
    setState(() {
      meals = meals;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Favorites",
                style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: getWidth(10, context)),
                textAlign: TextAlign.left,
              ),
              Text(
                "Swipe to remove..",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                    fontSize: getWidth(4, context)),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(10),
            child: Visibility(
              visible: isLoaded,
              replacement: Center(
                child: (meals.isEmpty
                    ? const Text("There are no saved list!")
                    : const CircularProgressIndicator()),
              ),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height - 300.0,
                  child: listData()),
            ))
      ],
    );
  }

  Widget listData() {
    return ListView.builder(
      padding: const EdgeInsets.all(25),
      physics: const BouncingScrollPhysics(),
      itemCount: meals.length,
      itemBuilder: (context, index) => getDataList(index),
    );
  }

  getDataList(index) {
    if (index < meals.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Dismissible(
          background: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.redColor.withOpacity(0.8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Delete",
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.white),
              ),
            ),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              showToast("Deleted Successfully", context);
              LocalDataCubit.get(context).deleteSharedItem(
                  AppConstants.favListNum, meals[index].strMeal ?? "");
              setState(() {
                meals.remove(meals[index]);
              });
            }
          },
          direction: DismissDirection.endToStart,
          key: Key(meals[index].strMeal ?? ''),
          child: SizedBox(
            width: getWidth(80, context),
            child: FoodItemBuilder(foodModel: meals[index], index: index),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
