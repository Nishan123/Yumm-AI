import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/custom_shadow.dart';
import 'package:yumm_ai/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/widgets/secondary_button.dart';
import 'package:yumm_ai/screens/scanner/controller/camera_controller.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? cameraController;

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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: AppColors.extraLightBlackColor,
                border: Border.all(width: 4, color: AppColors.whiteColor),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [CustomShadow.mainShadow],
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(34),
                child:
                    (cameraController != null &&
                        cameraController!.value.isInitialized)
                    ? CameraPreview(cameraController!)
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
            CustomChoiceChip(),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              child: CustomTabBar(tabItems: ["Scan Fridge", "Scan Receipt"]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SecondaryButton(
                borderRadius: 30,
                backgroundColor: AppColors.blackColor,
                onTap: () {},
                text: "Generate Recipe",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
