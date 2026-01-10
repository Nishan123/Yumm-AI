import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/scanner/domain/usecases/camera_controller.dart';

class ScannerScreen extends StatefulWidget {
  final String selectedScanner;
  const ScannerScreen({super.key, required this.selectedScanner});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? cameraController;
  Meal _selectedMealType = Meal.anything;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
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
            ),
            SizedBox(height: 16),

            SecondaryButton(
              borderRadius: 30,
              backgroundColor: AppColors.blackColor,
              onTap: () {},
              text: "Generate Recipe",
            ),
          ],
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
      height: MediaQuery.of(context).size.height * 0.6,
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
