// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';

import '../../core/utilities/constants.dart';

class BorderedCard extends StatelessWidget {
  BorderedCard({super.key, required this.child});

  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(
            color: Constants.primaryColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: child,
    );
  }
}
