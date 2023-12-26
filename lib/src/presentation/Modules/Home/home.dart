import 'package:flutter/material.dart';
import 'package:foodfinder/src/config/utils/styles/app_colors.dart';

import '../../../config/utils/managers/app_assets.dart';
import '../../../data/Remote/RemoteHttpRequest.dart';
import '../../../domain/models/FoodModel.dart';
import '../../Shared/Components.dart';
import '../Theme/ThemeButton.dart';
import 'Builders/FoodICard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  List<FoodModel> foodModels = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  searchData(foodname) async {
    if (!mounted) return;
    setState(() {
      isLoaded = false;
      foodModels.clear();
    });
    await HttpRequestPage().searchFoodData(foodname).then((value) {
      if (value != null) {
        if (!mounted) return;
        setState(() {
          foodModels.add(value);
          isLoaded = true;
        });
      }
    });
  }

  getData() async {
    if (!mounted) return;
    await HttpRequestPage().getFoodData().then((value) {
      if (value != null) {
        if (!mounted) return;
        setState(() {
          foodModels.add(value);
          isLoaded = true;
        });
      }
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40.0, bottom: 5, top: 30),
          child: Row(
            children: <Widget>[
              const Text('Hey',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
              const SizedBox(width: 7.0),
              Text('Foodie!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 25.0)),
              const Expanded(child: SizedBox()),
              const SizedBox(
                height: 25.0,
                width: 25.0,
              ),
              const ThemeHeader(),
              const SizedBox(
                width: 20,
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          height: getHeight(5, context),
          width: getWidth(90, context),
          child: Image.asset(AppAssets.assetsHomeAnimation),
        ),
        Container(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          width: double.infinity,
          height: 60.0,
          child: TextField(
            onChanged: (value) {
              // print(value);
              // Future.delayed(const Duration(seconds: 3));
              searchData(value);
            },
            onSubmitted: (value) {
              searchData(value);
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                ),
                hintText: "Search...",
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                )),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(
              color: Theme.of(context).hoverColor,
              border: Border.all(color: AppColors.secondaryColor),
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(60.0)),
            ),
            child: Visibility(
              visible: isLoaded,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height - 300.0,
                  child: listData()),
            ))
      ],
    );
  }

  Widget listData() {
    return RefreshIndicator(
      color: Colors.green,
      onRefresh: () async {
        foodModels.clear();
        getData();
        await Future.delayed(const Duration(seconds: 2));
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 25.0, right: 20.0, top: 25.0),
        physics: const BouncingScrollPhysics(),
        itemCount: foodModels.length,
        itemBuilder: (context, index) => getDataList(index),
      ),
    );
  }

  getDataList(index) {
    if (index < foodModels.length) {
      final meals = foodModels[index].meals;
      if (meals != null &&
          meals.isNotEmpty &&
          meals[0].strCategory != 'Pork' &&
          meals[0].strMeal!.length <= 15) {
        if (foodModels.length < 20) {
          getData();
        }
        return Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0),
          child: FoodItemBuilder(
            foodModel: meals[0],
            index: index,
          ),
        );
      }
    }
    // Return a placeholder widget or an empty container if data is missing.
    return Container();
  }
}
