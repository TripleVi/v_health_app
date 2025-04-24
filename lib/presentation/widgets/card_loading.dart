import "package:card_loading/card_loading.dart";
import "package:flutter/material.dart";

class AppCardLoading extends StatelessWidget {
  const AppCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardLoading(
            height: 30,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            width: 100,
            margin: EdgeInsets.only(bottom: 10),
          ),
          CardLoading(
            height: 100,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            margin: EdgeInsets.only(bottom: 10),
          ),
          CardLoading(
            height: 30,
            width: 200,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            margin: EdgeInsets.only(bottom: 10),
          ),
        ],
      ),
    );
  }
}