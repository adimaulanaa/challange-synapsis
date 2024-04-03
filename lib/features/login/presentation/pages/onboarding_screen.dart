import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapsis/config/string_resource.dart';
import 'package:synapsis/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:synapsis/features/auth/presentation/bloc/auth_event.dart';
import 'package:synapsis/features/login/presentation/pages/component/custom_button.dart';
import 'package:synapsis/service_locator.dart';
import 'package:synapsis/utils/colors.dart';
import 'package:synapsis/utils/text_style.dart';

class OnBoardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';

  OnBoardingScreen({
    Key? key,
  }) : super(key: key);
  final SharedPreferences prefs = serviceLocator.get<SharedPreferences>();

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final controller = PageController(initialPage: 0);
  // int _currentPage = 0;
  Timer? _timer;

  void _onIntroEnd(context) {
    _setPreference();
    BlocProvider.of<AuthBloc>(context).add(ShowLogin());
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      // if (_currentPage < 2) {
      //   _currentPage++;
      // } else {
      //   _currentPage = 0;
      // }

      // controller.animateToPage(
      //   _currentPage,
      //   duration: const Duration(milliseconds: 350),
      //   curve: Curves.easeIn,
      // );
    });
  }

  void _setPreference() async {
    await widget.prefs.setBool('seen', true);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        color: AppColors.primaryColor,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(top: 25, right: 10),
              width: size.width * 0.5,
              height: size.width * 0.5,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
              ),
            ),
            const Spacer(),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: StringResources.onBoardingTitle1,
                style: whiteTextstyle.copyWith(
                  fontSize: 18,
                  fontWeight: bold,
                  fontFamily: "Poppins",
                ),
                children: [
                  TextSpan(
                    text: StringResources.onBoardingTitleExtend1,
                    style: whiteTextstyle.copyWith(
                      fontSize: 18,
                      fontWeight: bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Column(
                children: [
                  CustomButton(
                    text: StringResources.BUTTON_LOGIN,
                    textColor: AppColors.primaryColor,
                    btnBgColor: AppColors.bgColor,
                    onPressed: () => _onIntroEnd(context),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
