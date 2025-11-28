import 'package:camera/camera.dart';

Future<CameraController?> setupCameraController() async {
  final cameras = await availableCameras();
  if (cameras.isEmpty) return null;

  final controller = CameraController(cameras.first, ResolutionPreset.max);
  await controller.initialize();
  return controller;
}
