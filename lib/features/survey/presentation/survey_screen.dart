import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synapsis/features/survey/data/models/survey_model.dart';
import 'package:synapsis/features/survey/presentation/bloc/survey_event.dart';
import 'package:synapsis/features/survey/presentation/input_survey.dart';
import 'package:synapsis/framework/managers/helper.dart';
import 'package:synapsis/framework/widgets/loading_indicator.dart';
import 'package:synapsis/utils/colors.dart';
import 'package:synapsis/features/survey/presentation/bloc/survey_bloc.dart';
import 'package:synapsis/features/survey/presentation/bloc/survey_state.dart';
import 'package:synapsis/utils/text_style.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  bool isLoading = false;
  SurveyModel model = SurveyModel();
  List<Survey> listSurvey = [];
  var random = Random();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SurveyBloc>(context).add(LoadSurvey());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SurveyBloc, SurveyState>(listener: (context, state) async {
          if (state is SurveyLoading) {
            isLoading = false;
            setState(() {});
          } else if (state is SurveyLoaded) {
            if (state.data != null) {
              model = state.data!;
              listSurvey = model.data!;
            }
            isLoading = true;
            setState(() {});
          } else if (state is SurveyFailure) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.07),
              Text(
                'Halaman Assessment',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  color: AppColors.blackColor,
                  fontSize: 17,
                  fontWeight: medium,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              listSurvey.isNotEmpty
                  ? Column(
                      children: listSurvey.map((e) {
                        // create at
                        DateTime parsedDate =
                            DateTime.parse(e.createdAt.toString());
                        String createAt =
                            DateFormat('dd MMM yyyy').format(parsedDate);
                        // download
                        String dowloadAt = '';
                        if (e.downloadedAt != null) {
                          DateTime parsedDates =
                              DateTime.parse(e.downloadedAt.toString());
                          dowloadAt =
                              DateFormat('dd MMM yyyy').format(parsedDates);
                        }
                        return InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const InputSurvey(data: '4l3bjupuwj'),
                              ),
                            );
                          },
                          child: Container(
                            width: size.width,
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.greyColor,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/data-A+.svg',
                                      color: AppColors.primaryColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Survei A',
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontStyle: FontStyle.normal,
                                            color: AppColors.blackColor,
                                            fontSize: 14,
                                            fontWeight: medium,
                                          ),
                                        ),
                                        Text(
                                          'Created At: $createAt',
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontStyle: FontStyle.normal,
                                            color: AppColors.green,
                                            fontSize: 12,
                                            fontWeight: medium,
                                          ),
                                        ),
                                        Text(
                                          e.downloadedAt == null
                                              ? 'Last Download: -'
                                              : 'Last Download: $dowloadAt',
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontStyle: FontStyle.normal,
                                            color: AppColors.green,
                                            fontSize: 12,
                                            fontWeight: medium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    _saveImage(context, e.image!);
                                    var now = DateTime.now();
                                    e.downloadedAt = now;
                                    setState(() {});
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/download.svg',
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveImage(BuildContext context, String url) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;

    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(url));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/SaveImage${random.nextInt(100)}.png';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Image saved to disk';
      }
    } catch (e) {
      message = e.toString();
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFe91e63),
      ));
    }

    // ignore: unnecessary_null_comparison
    if (message != null) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFe91e63),
      ));
    }
  }
}
