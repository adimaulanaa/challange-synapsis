import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:synapsis/features/survey/data/models/survey_model.dart';
import 'package:synapsis/utils/colors.dart';
import 'package:synapsis/utils/text_style.dart';

class InputSurveyRadio extends StatefulWidget {
  final List<Participant> data;
  const InputSurveyRadio({super.key, required this.data});

  @override
  State<InputSurveyRadio> createState() => _InputSurveyRadioState();
}

class _InputSurveyRadioState extends State<InputSurveyRadio> {
  bool isInterested = false;
  bool isNormal = false;
  bool isVeryInterested = false;
  bool isJustNormal = false;
  int index = 1;
  int total = 0;

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() {
    total = widget.data.length;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.whiteTextColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.07),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // width: size.width,
                    padding: const EdgeInsets.only(
                        left: 20, top: 5, bottom: 5, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    child: Text(
                      '45 Second Left',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        color: AppColors.primaryColor,
                        fontSize: 15,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                  Container(
                    // width: size.width,
                    padding: const EdgeInsets.only(
                        left: 10, top: 5, bottom: 5, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.blackColor,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/list-data.svg',
                          color: AppColors.bgColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '$index/$total',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.normal,
                            color: AppColors.bgColor,
                            fontSize: 15,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                'Section A',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: bold,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                '1. Apakah anda tertarik bergabung ke synapsis',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  color: AppColors.greyColor,
                  fontSize: 16,
                  fontWeight: light,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              width: size.width,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.secondBlue,
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                'Answer',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  color: AppColors.blackColor,
                  fontSize: 15,
                  fontWeight: light,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              width: size.width,
              height: 2,
              decoration: const BoxDecoration(
                color: AppColors.borderColor,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      isInterested = true;
                      isNormal = false;
                      isVeryInterested = false;
                      isJustNormal = false;
                      setState(() {});
                    },
                    child: SvgPicture.asset(
                      isInterested
                          ? 'assets/icons/radio-true.svg'
                          : 'assets/icons/radio-false.svg',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'tertarik',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      color: AppColors.blackColor,
                      fontSize: 15,
                      fontWeight: light,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      isNormal = true;
                      isInterested = false;
                      isVeryInterested = false;
                      isJustNormal = false;
                      setState(() {});
                    },
                    child: SvgPicture.asset(
                      isNormal
                          ? 'assets/icons/radio-true.svg'
                          : 'assets/icons/radio-false.svg',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'biasa',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      color: AppColors.blackColor,
                      fontSize: 15,
                      fontWeight: light,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      isVeryInterested = true;
                      isNormal = false;
                      isInterested = false;
                      isJustNormal = false;
                      setState(() {});
                    },
                    child: SvgPicture.asset(
                      isVeryInterested
                          ? 'assets/icons/radio-true.svg'
                          : 'assets/icons/radio-false.svg',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'sangat tertarik',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      color: AppColors.blackColor,
                      fontSize: 15,
                      fontWeight: light,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      isJustNormal = true;
                      isVeryInterested = false;
                      isNormal = false;
                      isInterested = false;
                      setState(() {});
                    },
                    child: SvgPicture.asset(
                      isJustNormal
                          ? 'assets/icons/radio-true.svg'
                          : 'assets/icons/radio-false.svg',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'biasa saja',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      color: AppColors.blackColor,
                      fontSize: 15,
                      fontWeight: light,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
