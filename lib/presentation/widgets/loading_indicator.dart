import 'package:flutter/material.dart';

import '../../core/resources/colors.dart';

class AppProcessingIndicator extends StatelessWidget {
  const AppProcessingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundColor.withOpacity(0.3),
      child: Center(
        child: CircularProgressIndicator(color: AppColor.onBackgroundColor),
      ),
    );
  }
}

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32.0),
      alignment: AlignmentDirectional.topCenter,
      color: AppColor.backgroundColor.withOpacity(0.3),
      child: CircularProgressIndicator(color: AppColor.onBackgroundColor),
    );
  }
}