import 'package:flutter/material.dart';
import 'package:foodfinder/src/config/utils/styles/app_colors.dart';
import 'package:foodfinder/src/domain/models/FoodModel.dart';
import 'package:foodfinder/src/presentation/Shared/Components.dart';

import '../detailsPage.dart';

class FoodItemBuilder extends StatelessWidget {
  final Meal foodModel;
  final int index;

  const FoodItemBuilder(
      {super.key, required this.foodModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailsPage(
                    foodModel,
                    index: index,
                  )));
        },
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondaryColor),
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: index,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              image: NetworkImage(foodModel.strMealThumb ?? ""),
                              fit: BoxFit.fill),
                        ),
                        height: 65.0,
                        width: 65.0),
                  ),
                ),
                const SizedBox(width: 20.0),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  FittedBox(
                    child: Text(foodModel.strMeal ?? "Food Name",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  getCube(1, context),
                  FittedBox(
                    child: Text(foodModel.strCategory ?? "Food Category",
                        style: const TextStyle(color: Colors.grey)),
                  )
                ])
              ]),
              IconButton(
                  icon: const Icon(Icons.read_more_sharp),
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsPage(
                              foodModel,
                              index: index,
                            )));
                  })
            ],
          ),
        ));
  }
}
