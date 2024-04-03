import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:synapsis/features/survey/data/models/survey_id_model.dart';
import 'package:synapsis/features/survey/presentation/bloc/survey_bloc.dart';
import 'package:synapsis/features/survey/presentation/bloc/survey_event.dart';
import 'package:synapsis/features/survey/presentation/bloc/survey_state.dart';
import 'package:synapsis/framework/managers/helper.dart';
import 'package:synapsis/framework/widgets/loading_indicator.dart';
import 'package:synapsis/utils/colors.dart';
import 'package:synapsis/utils/text_style.dart';

class InputSurvey extends StatefulWidget {
  final String data;
  const InputSurvey({super.key, required this.data});

  @override
  State<InputSurvey> createState() => _InputSurveyState();
}

class _InputSurveyState extends State<InputSurvey> {
  bool isInterested = false;
  bool isNormal = false;
  bool isVeryInterested = false;
  bool isJustNormal = false;
  bool isLoading = false;
  int index = 1;
  int total = 0;

  String questionSction = '';
  String questionNumber = '';
  String questionType = '';
  String questionName = '';

  SurveyIdModel model = SurveyIdModel();
  SurveyId dataId = SurveyId();
  List<Question> question = [];
  List<Option> options = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SurveyBloc>(context).add(LoadSurveyId(id: widget.data));
  }

  void setQuestion() {
    total = question.length;
    for (var e in question) {
      if (e.number == '1') {
        questionSction = e.section ?? '';
        questionNumber = e.number!;
        questionType = e.type ?? '';
        questionName = e.questionName ?? '';
        index = int.parse(e.number!);
        options = e.options!;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SurveyBloc, SurveyState>(listener: (context, state) async {
          if (state is SurveyIdLoading) {
            isLoading = false;
            setState(() {});
          } else if (state is SurveyIdLoaded) {
            if (state.data != null) {
              model = state.data!;
              dataId = model.data!;
              question = dataId.question!;
              setQuestion();
            }
            isLoading = true;
            setState(() {});
          } else if (state is SurveyIdFailure) {
            catchAllException(context, state.error, true);
            setState(() {});
          }
        }),
      ],
      child: isLoading ? _buildBody(context) : const LoadingPage(),
    );
  }

  Widget _buildBody(BuildContext context) {
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
                InkWell(
                  onTap: () {
                    _showBottom(context);
                  },
                  child: Container(
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
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.04),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              questionSction,
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
              '$questionNumber. $questionName',
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
          questionType == 'multiple_choice'
              ? multipleChoice(size)
              : checkbox(size),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    int idx = int.parse(questionNumber);
                    int nextId = idx - 1;
                    questionNumber = nextId.toString();
                    back(questionNumber);
                  },
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * 0.4,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Back',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          color: AppColors.primaryColor,
                          fontSize: 15,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    int idx = int.parse(questionNumber);
                    int nextId = idx + 1;
                    questionNumber = nextId.toString();
                    next(questionNumber);
                  },
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * 0.4,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          color: AppColors.bgColor,
                          fontSize: 15,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.04),
        ],
      ),
    );
  }

  Column multipleChoice(Size size) {
    return Column(
      children: options.map((e) {
        return Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  e.check = true;
                  setState(() {});
                },
                child: SvgPicture.asset(
                  e.check
                      ? 'assets/icons/radio-true.svg'
                      : 'assets/icons/radio-false.svg',
                ),
              ),
              const SizedBox(width: 10),
              Text(
                e.optionName!,
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
        );
      }).toList(),
    );
  }

  Column checkbox(Size size) {
    return Column(
      children: [
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
    );
  }

  void next(String id) {
    for (var e in question) {
      if (e.number == id) {
        questionSction = e.section ?? '';
        questionNumber = e.number!;
        questionType = e.type ?? '';
        questionName = e.questionName ?? '';
        index = int.parse(e.number!);
        options = e.options!;
      }
    }
    setState(() {});
  }

  void back(String id) {
    for (var e in question) {
      if (e.number == id) {
        questionSction = e.section ?? '';
        questionNumber = e.number!;
        questionType = e.type ?? '';
        questionName = e.questionName ?? '';
        index = int.parse(e.number!);
        options = e.options!;
      }
    }
    setState(() {});
  }

  void choice(String id) {
    for (var e in question) {
      if (e.number == id) {
        questionSction = e.section ?? '';
        questionNumber = e.number!;
        questionType = e.type ?? '';
        questionName = e.questionName ?? '';
        index = int.parse(e.number!);
        options = e.options!;
      }
    }
    setState(() {});
  }

  Future<dynamic> _showBottom(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: size.height * 0.45),
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return Container(
              height: size.height - 30.0,
              width: size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Survei Question',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        color: AppColors.blackColor,
                        fontSize: 16,
                        fontWeight: bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Wrap(
                      children: question.map((op) {
                        return Wrap(
                          children: [
                            InkWell(
                              onTap: () {
                                choice(op.number!);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: size.height * 0.06,
                                width: size.width * 0.15,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    op.number!,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal,
                                      color: AppColors.blackColor,
                                      fontSize: 15,
                                      fontWeight: medium,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
