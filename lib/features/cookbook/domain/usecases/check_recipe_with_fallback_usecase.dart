import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/cookbook/data/repositories/cookbook_repository_impl.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/domain/repositories/cookbook_repository.dart';

/// Result object for the combined cookbook check operation
class CookbookCheckResult extends Equatable {
  /// Whether the recipe is in the user's cookbook
  final bool isInCookbook;

  /// The user's copy of the recipe (null if not in cookbook or fetch failed)
  final CookbookRecipeEntity? userRecipe;

  /// Whether to fallback to showing the original recipe
  /// This is true when recipe is in cookbook but we couldn't fetch the user's copy
  final bool shouldFallback;

  /// Optional error message for debugging
  final String? errorMessage;

  const CookbookCheckResult({
    required this.isInCookbook,
    this.userRecipe,
    required this.shouldFallback,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    isInCookbook,
    userRecipe,
    shouldFallback,
    errorMessage,
  ];
}

class CheckRecipeWithFallbackParams extends Equatable {
  final String userId;
  final String originalRecipeId;

  const CheckRecipeWithFallbackParams({
    required this.userId,
    required this.originalRecipeId,
  });

  @override
  List<Object> get props => [userId, originalRecipeId];
}

final checkRecipeWithFallbackUsecaseProvider = Provider((ref) {
  final repository = ref.watch(cookbookRepositoryProvider);
  return CheckRecipeWithFallbackUsecase(repository: repository);
});

/// Combined usecase that checks if a recipe is in cookbook and fetches the user's copy
///
/// This usecase improves upon the previous 2-call pattern by:
/// - Combining both operations into a single call from the presentation layer
/// - Providing graceful fallback when user recipe fetch fails
/// - Returning structured result that allows the UI to handle partial failures
///
/// Clean Architecture Note: This usecase orchestrates two repository methods
/// which is acceptable as it's business logic handled in the domain layer.
class CheckRecipeWithFallbackUsecase
    implements
        UsecaseWithParms<CookbookCheckResult, CheckRecipeWithFallbackParams> {
  final ICookbookRepository _repository;

  CheckRecipeWithFallbackUsecase({required ICookbookRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CookbookCheckResult>> call(
    CheckRecipeWithFallbackParams params,
  ) async {
    // Step 1: Check if recipe is in cookbook
    final checkResult = await _repository.isRecipeInCookbook(
      userId: params.userId,
      originalRecipeId: params.originalRecipeId,
    );

    return checkResult.fold(
      // If check fails, return error
      (failure) => Left(failure),
      (isInCookbook) async {
        // If not in cookbook, return result immediately
        if (!isInCookbook) {
          return const Right(
            CookbookCheckResult(isInCookbook: false, shouldFallback: false),
          );
        }

        // Step 2: Recipe is in cookbook, try to fetch user's copy
        final fetchResult = await _repository.getUserRecipeByOriginal(
          userId: params.userId,
          originalRecipeId: params.originalRecipeId,
        );

        return fetchResult.fold(
          // Recipe is in cookbook but fetch failed - graceful fallback
          (failure) {
            return Right(
              CookbookCheckResult(
                isInCookbook: true,
                userRecipe: null,
                shouldFallback: true,
                errorMessage: failure.errorMessage,
              ),
            );
          },
          // Successfully fetched user's recipe
          (userRecipe) {
            return Right(
              CookbookCheckResult(
                isInCookbook: true,
                userRecipe: userRecipe,
                shouldFallback: false,
              ),
            );
          },
        );
      },
    );
  }
}
