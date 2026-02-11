import 'package:yumm_ai/features/scanner/presentation/view_model/scanner_chef_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/macro_chef_view_model.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/master_chef_view_model.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/pantry_chef_view_model.dart';

enum ActiveChefType { pantry, master, macro, scanner }

/// Tracks which chef is currently active
final activeChefTypeProvider = StateProvider<ActiveChefType>((ref) {
  return ActiveChefType.pantry;
});

final activeChefStateProvider = Provider<ChefState>((ref) {
  final activeType = ref.watch(activeChefTypeProvider);

  switch (activeType) {
    case ActiveChefType.pantry:
      return ref.watch(pantryChefViewModelProvider);
    case ActiveChefType.master:
      return ref.watch(masterChefViewModelProvider);
    case ActiveChefType.macro:
      return ref.watch(macroChefViewModelProvider);
    case ActiveChefType.scanner:
      return ref.watch(scannerChefViewModelProvider);
  }
});
