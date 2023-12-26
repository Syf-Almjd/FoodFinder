import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

double getHeight(int percent, context) {
  return (MediaQuery.of(context).size.height * (percent / 100)).toDouble();
}

SizedBox getCube(int percent, context) {
  return SizedBox(
    width: (MediaQuery.of(context).size.width * (percent / 100)).toDouble(),
    height: (MediaQuery.of(context).size.height * (percent / 100)).toDouble(),
  );
}

double getWidth(int percent, context) {
  return (MediaQuery.of(context).size.width * (percent / 100)).toDouble();
}

Widget loadingAnimation({Widget? loadingType}) {
  if (loadingType != null) {
    return loadingType;
  } else {
    return Center(
        child: LoadingAnimationWidget.waveDots(color: Colors.blue, size: 30));
  }
}

//Show a toast
void showToast(String text, context) => toastification.show(
      context: context,
      title: text,
      alignment: Alignment.topCenter,
      primaryColor: Colors.green,
      autoCloseDuration: const Duration(seconds: 2),
    );

void openUrl(String url) {
  var openUrl = Uri.parse(url);
  launchUrl(
    openUrl,
    mode: LaunchMode.externalApplication,
  );
}
