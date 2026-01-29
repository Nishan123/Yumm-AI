import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/master_chef_view_model.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/pantry_chef_view_model.dart';

enum ActiveChefType { pantry, master }

/// Tracks which chef is currently active
final activeChefTypeProvider = StateProvider<ActiveChefType>((ref) {
  return ActiveChefType.pantry;
});

/// Returns the state of the currently active chef
final activeChefStateProvider = Provider<ChefState>((ref) {
  final activeType = ref.watch(activeChefTypeProvider);

  switch (activeType) {
    case ActiveChefType.pantry:
      return ref.watch(pantryChefViewModelProvider);
    case ActiveChefType.master:
      return ref.watch(masterChefViewModelProvider);
  }
});
