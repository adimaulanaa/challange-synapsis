import 'dart:io';
import 'package:synapsis/features/survey/data/models/survey_model.dart';
import 'package:synapsis/framework/managers/http_manager.dart';
import 'package:synapsis/framework/managers/hive_db_helper.dart';
import 'package:synapsis/framework/core/exceptions/app_exceptions.dart';

abstract class SurveyRemoteDataSource {
  Future<SurveyModel> getSurvey();
}

class SurveyRemoteDataSourceImpl implements SurveyRemoteDataSource {
  SurveyRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<SurveyModel> getSurvey() =>
      _getDasboardFromUrl('/assessments?page=1&limit=10');

  Future<SurveyModel> _getDasboardFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);
    final response = await httpManager.get(
      url: url,
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );

    if (response != null && response.statusCode == 200) {
      return SurveyModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
