import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/search/presentation/widgets/filter_bottom_sheet.dart';
import 'package:yumm_ai/features/search/presentation/widgets/search_header.dart';
import 'package:yumm_ai/features/search/presentation/widgets/search_history_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/search/presentation/view_model/search_view_model.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  static Route<void> route({bool? focus, bool focusFilter = false}) {
    return PageRouteBuilder<void>(
      settings: RouteSettings(arguments: {'focusFilter': focusFilter}),
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
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _hasShownInitialFilter = false;

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

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    ref.read(searchViewModelProvider.notifier).search(query);
    context.pushNamed('search_results');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasShownInitialFilter) return;

    bool shouldFocusFilter = false;

    // Check GoRouter extra
    try {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      if (extra != null && extra['focusFilter'] == true) {
        shouldFocusFilter = true;
      }
    } catch (_) {
      // Not a GoRouter route or GoRouterState not available
    }

    // Check Navigator arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['focusFilter'] == true) {
      shouldFocusFilter = true;
    }

    if (shouldFocusFilter) {
      _hasShownInitialFilter = true;
      // Small delay to ensure the screen is built before showing the modal
      Future.delayed(Duration.zero, () {
        if (mounted) _showFilterBottomSheet();
      });
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);
    final history = searchState.searchHistory;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchHeader(
              onBack: () => Navigator.of(context).maybePop(),
              controller: _controller,
              onClear: () => _controller.clear(),
              onSubmitted: _performSearch,
              onFilterTap: _showFilterBottomSheet,
            ),
            history.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2,
                    ),
                    child: Center(
                      child: Text(
                        "No search history available",
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.descriptionTextColor,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        SearchHistorySection(
                          items: history,
                          onClearAll: () {
                            ref
                                .read(searchViewModelProvider.notifier)
                                .clearHistory();
                          },
                          onSearch: (term) {
                            _controller.text = term;
                            _performSearch(term);
                          },
                          onDelete: (term) {
                            ref
                                .read(searchViewModelProvider.notifier)
                                .removeHistoryItem(term);
                          },
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
