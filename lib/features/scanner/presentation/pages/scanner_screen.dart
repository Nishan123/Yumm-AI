import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/chef/presentation/pages/recipe_generation_loading_screen.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/active_chef_provider.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/visibility_selector.dart';
import 'package:yumm_ai/features/scanner/domain/usecases/camera_controller.dart';
import 'package:yumm_ai/features/scanner/presentation/view_model/scanner_chef_view_model.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  final String selectedScanner;
  const ScannerScreen({super.key, required this.selectedScanner});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  CameraController? cameraController;
  Meal _selectedMealType = Meal.anything;
  bool _isPublic = true;
  late String _currentScanner;

  @override
  void initState() {
    super.initState();
    _currentScanner = widget.selectedScanner;
    // Initialize camera
    setupCameraController().then((controller) {
      if (!mounted) return;
      setState(() => cameraController = controller);
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  void _onGenerateRecipe() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      CustomSnackBar.showErrorSnackBar(context, "Camera not initilized");
      return;
    }

    try {
      final image = await cameraController!.takePicture();
      final userAsync = ref.read(currentUserProvider);
      final user = userAsync.value;

      if (user == null) {
        if (mounted) {
          CustomSnackBar.showErrorSnackBar(context, "Login to generate recipe");
          return;
        }
      }

      // Set active chef to scanner so loading screen watches the right provider
      ref.read(activeChefTypeProvider.notifier).state = ActiveChefType.scanner;

      if (_currentScanner == "fridgeScanner") {
        ref
            .read(scannerChefViewModelProvider.notifier)
            .generateRecipeFromFridge(
              image: image,
              currentUserId: user!.uid!,
              isPublic: _isPublic,
              mealType: _selectedMealType.text,
            );
      } else {
        ref
            .read(scannerChefViewModelProvider.notifier)
            .generateRecipeFromReceipt(
              image: image,
              currentUserId: user!.uid!,
              isPublic: _isPublic,
              mealType: _selectedMealType.text,
            );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showErrorSnackBar(context, "No food items detected !");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ChefState>(scannerChefViewModelProvider, (previous, next) {
      if (next.isLoading && previous?.isLoading != true) {
        // We push the loading screen, which will handle success navigation
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RecipeGenerationLoadingScreen(),
          ),
        );
      }

      if (next.status == ChefStatus.error && next.errorMessage != null) {
        CustomSnackBar.showErrorSnackBar(context, "${next.errorMessage}");
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Scanner  "),
            Icon(LucideIcons.chef_hat, color: AppColors.primaryColor),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //camera container
              CameraBox(cameraController: cameraController),
              CustomChoiceChip(
                values: Meal.values,
                labelBuilder: (meal) => meal.text,
                iconBuilder: (meal) => meal.icon,
                onSelected: (value) {
                  setState(() {
                    _selectedMealType = value;
                  });
                },
              ),
              SizedBox(height: 16),
              CustomTabBar(
                tabItems: ["Scan Fridge", "Scan Receipt"],
                values: ["fridgeScanner", "receiptScanner"],
                initialValue: widget.selectedScanner,
                onTabChanged: (value) {
                  setState(() {
                    _currentScanner = value;
                  });
                },
              ),
              SizedBox(height: 16),

              VisibilitySelector(
                isPublic: _isPublic,
                onChanged: (val) => setState(() => _isPublic = val),
              ),

              SizedBox(height: 24),

              SecondaryButton(
                borderRadius: 30,
                backgroundColor: AppColors.blackColor,
                onTap: _onGenerateRecipe,
                text: "Generate Recipe",
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class CameraBox extends StatelessWidget {
  const CameraBox({super.key, required this.cameraController});

  final CameraController? cameraController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      width: MediaQuery.of(context).size.width,
      height:
          MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppColors.extraLightBlackColor,
        border: Border.all(width: 4, color: AppColors.whiteColor),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [ContainerProperty.mainShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(34),
        child:
            (cameraController != null && cameraController!.value.isInitialized)
            ? CameraPreview(cameraController!)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
