import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/domain/usecases/generate_scan_recipe_fridge.dart';
import 'package:yumm_ai/features/chef/domain/usecases/generate_scan_recipe_receipt.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/base_chef_view_model.dart';

final scannerChefViewModelProvider =
    NotifierProvider<ScannerChefViewModel, ChefState>(
      () => ScannerChefViewModel(),
    );

class ScannerChefViewModel extends BaseChefViewModel {
  late final GenerateScanRecipeFridge _generateScanRecipeFridge;
  late final GenerateScanRecipeReceipt _generateScanRecipeReceipt;

  @override
  ChefState build() {
    initBaseUsecases();
    _generateScanRecipeFridge = ref.read(
      generateScanRecipeFridgeUsecaseProvider,
    );
    _generateScanRecipeReceipt = ref.read(
      generateScanRecipeReceiptUsecaseProvider,
    );
    return const ChefState();
  }

  Future<void> generateRecipeFromFridge({
    required XFile image,
    required String currentUserId,
    required bool isPublic,
    required String mealType,
  }) async {
    state = state.copyWith(
      status: ChefStatus.generatingRecipe,
      loadingMessage: "Analyzing your fridge...",
    );

    final result = await _generateScanRecipeFridge.call(
      GenerateScanRecipeFridgeParams(image: image, mealType: mealType),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ChefStatus.error,
        errorMessage: failure.errorMessage,
        loadingMessage: null,
      ),
      (recipe) async {
        await generateImagesAndSave(
          tempRecipe: recipe,
          currentUserId: currentUserId,
          isPublic: isPublic,
        );
      },
    );
  }

  Future<void> generateRecipeFromReceipt({
    required XFile image,
    required String currentUserId,
    required bool isPublic,
    required String mealType,
  }) async {
    state = state.copyWith(
      status: ChefStatus.generatingRecipe,
      loadingMessage: "Scanning your receipt...",
    );

    final result = await _generateScanRecipeReceipt.call(
      GenerateScanRecipeReceiptParams(image: image, mealType: mealType),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ChefStatus.error,
        errorMessage: failure.errorMessage,
        loadingMessage: null,
      ),
      (recipe) async {
        await generateImagesAndSave(
          tempRecipe: recipe,
          currentUserId: currentUserId,
          isPublic: isPublic,
        );
      },
    );
  }
}
