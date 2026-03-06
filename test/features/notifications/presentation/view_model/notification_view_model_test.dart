import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/features/notifications/domain/usecases/get_notifications_usecase.dart';

import 'package:yumm_ai/features/notifications/presentation/view_model/notification_view_model.dart';

class MockGetNotificationsUsecase extends Mock
    implements GetNotificationsUsecase {}

class FakeGetNotificationsParams extends Fake
    implements GetNotificationsParams {}

void main() {
  late ProviderContainer container;
  late MockGetNotificationsUsecase mockGetNotificationsUsecase;

  setUpAll(() {
    registerFallbackValue(FakeGetNotificationsParams());
  });

  setUp(() {
    mockGetNotificationsUsecase = MockGetNotificationsUsecase();

    container = ProviderContainer(
      overrides: [
        getNotificationsUsecaseProvider.overrideWithValue(
          mockGetNotificationsUsecase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is properties default', () {
    final state = container.read(notificationViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, null);
    expect(state.hasMore, true);
    expect(state.page, 1);
  });

  test('fetchNotifications success updates state with notifications', () async {
    when(
      () => mockGetNotificationsUsecase.call(any()),
    ).thenAnswer((_) async => const Right([]));

    final viewModel = container.read(notificationViewModelProvider.notifier);
    await viewModel.fetchNotifications();

    final state = container.read(notificationViewModelProvider);
    expect(state.isLoading, false);
    expect(state.notifications, isEmpty);
    // Since we return 0 items, hasMore should be false (0 < 20)
    expect(state.hasMore, false);
  });
}
