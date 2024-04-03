import 'package:flutter/material.dart';

import '../../core/resources/style.dart';

class AppProcessingIndicator extends StatelessWidget {
  const AppProcessingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppStyle.surfaceColor.withOpacity(0.3),
      child: const Center(
        child: CircularProgressIndicator(color: AppStyle.neutralColor400),
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
      color: AppStyle.surfaceColor.withOpacity(0.3),
      child: const CircularProgressIndicator(color: AppStyle.neutralColor400),
    );
  }
}