import 'package:synapsis/features/survey/data/models/survey_model.dart';
import 'package:synapsis/framework/managers/realm_config/realm_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapsis/framework/managers/hive_db_helper.dart';

abstract class SurveyLocalDataSource {
  Future<void> cacheSurvey(SurveyModel surveyToCache);
  Future<SurveyModel> getLastCacheSurvey();
}

class SurveyLocalDataSourceImpl implements SurveyLocalDataSource {
  SurveyLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
    required this.realmDbService,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;
  final RealmDBServices realmDbService;

  @override
  Future<void> cacheSurvey(SurveyModel surveyToCache) async {
    await _cacheSurveyLocalStorage(surveyToCache);
  }

  @override
  Future<SurveyModel> getLastCacheSurvey() async {
    SurveyModel result = SurveyModel();
    try {
      final data = await dbServices.getData(HiveDbServices.boxSurvey);
      if (data != null) {
        result = surveyModelFromJson(data);
      }
      return result;
    } catch (e) {
      return result;
    }
  }

  Future<void> _cacheSurveyLocalStorage(SurveyModel surveyToCache) async {
    String data = surveyModelToJson(surveyToCache);
    await dbServices.addData(HiveDbServices.boxSurvey, data);
  }
}
