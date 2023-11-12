import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodfinder/src/presentation/Shared/Components.dart';

import '../../../../config/utils/managers/app_assets.dart';
import '../../../Cubits/theme_bloc/theme_bloc.dart';

class FoodAnimation extends StatefulWidget {
  const FoodAnimation({super.key});

  @override
  State<FoodAnimation> createState() => _ThemeHeaderState();
}

class _ThemeHeaderState extends State<FoodAnimation> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Container(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            height: getHeight(5, context),
            width: getWidth(90, context),
            child: Visibility(
                visible: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                    ThemeState.darkTheme.themeData,
                replacement: Image.asset(AppAssets.assetsHomeAnimation),
                child: Image.asset(AppAssets.assetsHomeAnimation)));
      },
    );
  }
}
