import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/primary_icon_button.dart';
import 'package:yumm_ai/features/home/presentation/widgets/top_recipe_card.dart';
import 'package:yumm_ai/features/search/presentation/state/search_state.dart';
import 'package:yumm_ai/features/search/presentation/view_model/search_view_model.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  final searchFieldController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final query = ref.read(searchViewModelProvider).searchQuery;
      searchFieldController.text = query;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchFieldController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(searchViewModelProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 16, left: 16),
              child: Row(
                spacing: 8,
                children: [
                  PrimaryIconButton(
                    icon: LucideIcons.chevron_left,
                    onTap: () {
                      context.pop();
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        controller: searchFieldController,
                        onSubmitted: (value) {
                          ref
                              .read(searchViewModelProvider.notifier)
                              .search(value);
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 16,
                          ),
                          suffixIcon: Icon(LucideIcons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 12),
              child: RichText(
                softWrap: true,
                text: TextSpan(
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.descriptionTextColor,
                    fontWeight: FontWeight.normal,
                  ),
                  children: [
                    TextSpan(text: "Search results for "),
                    TextSpan(
                      text: '"${searchState.searchQuery}"',
                      style: AppTextStyles.h5.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Expanded(child: _buildContent(searchState)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(SearchState state) {
    if (state.status == SearchStatus.loading && state.page == 1) {
      return Center(child: CircularProgressIndicator());
    }
    if (state.status == SearchStatus.error && state.page == 1) {
      return Center(child: Text(state.errorMessage));
    }

    if (state.recipes.isEmpty && state.status == SearchStatus.loaded) {
      return Center(child: Text("No recipes found"));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: 20),
      itemCount: state.recipes.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.recipes.length) {
          return Center(child: CircularProgressIndicator());
        }
        final recipe = state.recipes[index];
        return TopRecipeCard(recipe: recipe);
      },
    );
  }
}
