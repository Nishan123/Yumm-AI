import 'package:yumm_ai/features/food_pref/data/model/food_pref_api_model.dart';

abstract interface class IRemoteFoodPrefDatasource {
  Future<FoodPrefApiModel?> saveFoodPref(FoodPrefApiModel foodPref);
  Future<FoodPrefApiModel?> updateFoodPref(
    String prefId,
    FoodPrefApiModel foodPref,
  );
  Future<FoodPrefApiModel?> getUserFoodPref(String uid);
}
