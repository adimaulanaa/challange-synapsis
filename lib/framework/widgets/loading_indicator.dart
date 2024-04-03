// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:synapsis/utils/colors.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.width * 0.1,
          child: const LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [
              AppColors.primaryColor,
            ],
          ),
        ),
      ),
    );
  }
}
