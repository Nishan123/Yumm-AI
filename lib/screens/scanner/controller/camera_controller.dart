import 'package:camera/camera.dart';

Future<CameraController?> setupCameraController() async {
  final cameras = await availableCameras();
  if (cameras.isEmpty) return null;

  final controller = CameraController(
    cameras.first,
    ResolutionPreset.medium, // Use medium to significantly reduce buffer usage
    enableAudio: false,
    imageFormatGroup: ImageFormatGroup.jpeg,
  );

  await controller.initialize();
  return controller;
}
