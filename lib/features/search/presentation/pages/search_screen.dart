import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/search/presentation/widgets/search_header.dart';
import 'package:yumm_ai/features/search/presentation/widgets/search_history_section.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static Route<void> route() {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SearchScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final fade = FadeTransition(opacity: curved, child: child);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: fade,
        );
      },
    );
  }

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _history = const [
    'Chicken Alfredo',
    'High protein',
    'Avocado toast',
    'Pasta',
    'Low carb',
    'Salad',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchHeader(
              onBack: () => Navigator.of(context).maybePop(),
              controller: _controller,
              onClear: () => _controller.clear(),
            ),
            _history.isEmpty
                ? Padding(
                  padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2),
                  child: Center(
                    child: Text(
                        "No search history available",
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.lightPrimaryColor,
                        ),
                      ),
                  ),
                )
                : Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        SearchHistorySection(
                          items: _history,
                          onClearAll: () {},
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
