import 'package:flutter/material.dart';
import 'package:foodfinder/src/config/utils/managers/app_constants.dart';

import '../../../data/local/localData_cubit/local_data_cubit.dart';
import '../../../domain/models/FoodModel.dart';
import '../../Shared/Components.dart';

class DetailsPage extends StatefulWidget {
  final Meal meal;

  final int index;

  const DetailsPage(this.meal, {super.key, required this.index});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  var selectedCard = 'Food Country';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(widget.meal.strMeal ?? "Details",
              style: const TextStyle(fontSize: 18.0, color: Colors.white)),
          centerTitle: true,
        ),
        body:
            ListView(physics: const NeverScrollableScrollPhysics(), children: [
          Stack(children: [
            Container(
                height: MediaQuery.of(context).size.height - 82.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent),
            Positioned(
                top: 75.0,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                        color: Theme.of(context).hoverColor),
                    height: MediaQuery.of(context).size.height - 100.0,
                    width: MediaQuery.of(context).size.width)),
            Positioned(
                top: 30.0,
                left: (MediaQuery.of(context).size.width / 2) - 100.0,
                child: Hero(
                    tag: widget.index,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.meal.strMealThumb ?? "Photo"),
                              fit: BoxFit.fill),
                        ),
                        height: 200.0,
                        width: 200.0))),
            Positioned(
              top: 250.0,
              left: 25.0,
              right: 25.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.meal.strMeal ?? "strMeal",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.titleMedium?.color,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(widget.meal.strCategory ?? "strCategory",
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.grey)),
                      Container(height: 25.0, color: Colors.grey, width: 1.0),
                      InkWell(
                        onTap: () {
                          openUrl(widget.meal.strYoutube ?? "");
                          showToast(
                              "Click the back Button to go back", context);
                        },
                        child: Container(
                          width: 125.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17.0),
                              color: const Color(0xFF39BF21)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              const Text("Cook It!",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0)),
                              Container(
                                height: 25.0,
                                width: 25.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    color: Colors.white),
                                child: const Center(
                                  child: Icon(
                                    Icons.fastfood_outlined,
                                    color: Color(0xFF39BF21),
                                    size: 20.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  const Text(
                    "See More Info",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        _buildInfoCard(
                            'Food Country', widget.meal.strArea ?? "Area", ""),
                        const SizedBox(width: 10.0),
                        _buildInfoCard('Food Includes 1',
                            widget.meal.strIngredient1 ?? "1", ''),
                        const SizedBox(width: 10.0),
                        _buildInfoCard('Ingredient 2',
                            widget.meal.strIngredient2 ?? "2", ''),
                        const SizedBox(width: 10.0),
                        _buildInfoCard('Ingredient 3',
                            widget.meal.strIngredient3 ?? "3", ''),
                        const SizedBox(width: 10.0),
                        _buildInfoCard('Ingredient 4',
                            widget.meal.strIngredient4 ?? "4", ''),
                        const SizedBox(width: 10.0),
                        _buildInfoCard('Ingredient 5',
                            widget.meal.strIngredient5 ?? "5", ''),
                        const SizedBox(width: 10.0),
                        _buildInfoCard('Ingredient 6',
                            widget.meal.strIngredient6 ?? "6", ''),
                        const SizedBox(width: 10.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  SizedBox(
                    height: getHeight(5, context),
                    width: getWidth(90, context),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                      onPressed: () async {
                        showToast("Item have been added!", context);
                        await LocalDataCubit.get(context).saveSharedMap(
                            AppConstants.favListNum, widget.meal.toJson());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite_border),
                          getCube(1, context),
                          const Text(
                            "Add to Favourite",
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ])
        ]));
  }

  Widget _buildInfoCard(String cardTitle, String info, String unit) {
    return InkWell(
        onTap: () {
          selectCard(cardTitle);
        },
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: cardTitle == selectedCard
                  ? const Color(0xFF39BF21)
                  : Theme.of(context).unselectedWidgetColor.withOpacity(0.05),
              border: Border.all(
                  color: cardTitle == selectedCard
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.3),
                  style: BorderStyle.solid,
                  width: 0.75),
            ),
            height: 130.0,
            width: 130.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                    child: Text(cardTitle,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: cardTitle == selectedCard
                              ? Colors.white
                              : Colors.grey.withOpacity(0.7),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(info,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: cardTitle == selectedCard
                                    ? Colors.white
                                    : Colors.blueGrey,
                                fontWeight: FontWeight.bold)),
                        Text(unit,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: cardTitle == selectedCard
                                  ? Colors.white
                                  : Colors.blueGrey,
                            ))
                      ],
                    ),
                  )
                ])));
  }

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }
}
