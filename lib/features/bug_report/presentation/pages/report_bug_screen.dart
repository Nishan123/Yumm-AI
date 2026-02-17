import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/primary_text_field.dart';
import 'package:yumm_ai/core/enums/issue_type.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/features/bug_report/presentation/view_model/bug_report_view_model.dart';
import 'package:yumm_ai/features/bug_report/presentation/state/bug_report_state.dart';

class ReportBugScreen extends ConsumerStatefulWidget {
  final Uint8List? screenshot;
  const ReportBugScreen({super.key, this.screenshot});

  @override
  ConsumerState<ReportBugScreen> createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends ConsumerState<ReportBugScreen> {
  final descriptionController = TextEditingController();
  final issueTypeController = TextEditingController();
  IssueType? selectedIssueType;
  Uint8List? _screenshot;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _screenshot = widget.screenshot;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    issueTypeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _screenshot = bytes;
      });
    }
  }

  Future<void> _onReportBug() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (selectedIssueType == null) {
      CustomSnackBar.showErrorSnackBar(context, "Select issue type");
      return;
    }

    final userState = ref.read(currentUserProvider);
    final reportedBy = userState.value?.email ?? "Unknown User";

    String problemType = selectedIssueType!.text;
    if (selectedIssueType == IssueType.others &&
        issueTypeController.text.isNotEmpty) {
      problemType = issueTypeController.text;
    }

    await ref
        .read(bugReportViewModelProvider.notifier)
        .reportBug(
          description: descriptionController.text.trim(),
          problemType: problemType,
          reportedBy: reportedBy,
          screenshot: _screenshot,
        );
  }

  @override
  Widget build(BuildContext context) {
    final bugReportState = ref.watch(bugReportViewModelProvider);
    ref.watch(currentUserProvider);

    ref.listen(bugReportViewModelProvider, (previous, next) {
      if (next.status == BugReportStatus.success) {
        CustomSnackBar.showSuccessSnackBar(
          context,
          "Bug report sent successfully",
        );
        context.goNamed("main");
      } else if (next.status == BugReportStatus.error &&
          next.errorMessage != null) {
        CustomSnackBar.showErrorSnackBar(context, next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Report Bug")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                PrimaryTextField(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  hintText: "Describe the issue",
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please describe the issue";
                    }
                    return null;
                  },
                ),

                // screenshot container
                if (_screenshot != null)
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.extraLightBlackColor,
                        image: DecorationImage(
                          image: MemoryImage(_screenshot!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.extraLightBlackColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.image_plus,
                            size: 40,
                            color: AppColors.descriptionTextColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Tap to pick screenshot",
                            style: AppTextStyles.descriptionText.copyWith(
                              color: AppColors.descriptionTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text("Issue is related to:", style: AppTextStyles.h6),
                ),
                CustomChoiceChip<IssueType>(
                  padding: const EdgeInsetsGeometry.only(left: 16),
                  values: IssueType.values,
                  labelBuilder: (type) => type.text,
                  iconBuilder: (type) => type.icon,
                  onSelected: (value) {
                    setState(() {
                      selectedIssueType = value;
                    });
                  },
                  selectedValue: selectedIssueType,
                  isWrap: true,
                ),

                if (selectedIssueType == IssueType.others)
                  PrimaryTextField(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    hintText: "What is your issue related to",
                    controller: issueTypeController,
                    validator: (value) {
                      if (selectedIssueType == IssueType.others &&
                          (value == null || value.trim().isEmpty)) {
                        return "Please specify the issue type";
                      }
                      return null;
                    },
                  ),

                SecondaryButton(
                  isLoading: bugReportState.status == BugReportStatus.loading,
                  onTap: _onReportBug,
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  borderRadius: 40,
                  backgroundColor: AppColors.redColor,
                  text: "Send Report",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
