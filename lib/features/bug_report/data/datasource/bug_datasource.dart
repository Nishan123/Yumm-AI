import 'dart:typed_data';
import 'package:yumm_ai/features/bug_report/data/model/bug_report_model.dart';

abstract interface class IRemoteBugDatasource {
  Future<BugReportModel> reportBug(BugReportModel bugReport);
  Future<String> uploadScreenshot(Uint8List screenshot);
}
