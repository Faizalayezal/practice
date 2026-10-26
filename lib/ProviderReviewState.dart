import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'model/ReviewItem.dart';
import 'network_manager/repository.dart';

// 1. Pagination State Class
class ProviderReviewState {
  final bool isLoading;         // Initial page load spinner
  final bool isLoadingMore;     // Bottom loader spinner for next pages
  final List<ReviewItem> reviews;
  final int currentPage;
  final bool hasMore;           // Further pages available or not
  final String? error;

  ProviderReviewState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.reviews = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.error,
  });

  ProviderReviewState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<ReviewItem>? reviews,
    int? currentPage,
    bool? hasMore,
    String? error,
  }) {
    return ProviderReviewState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      reviews: reviews ?? this.reviews,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

// 2. Repository Provider
final repositoryProvider = Provider<Repository>((ref) => Repository());

// 3. StateNotifier Logic
class ProviderReviewNotifier extends StateNotifier<ProviderReviewState> {
  final Repository _repository;

  ProviderReviewNotifier(this._repository) : super(ProviderReviewState());

  // Pehla Page Fetch Karne Ke Liye
  Future<void> fetchInitialReviews({
    required int userId,
    required String accessToken,
    required int serviceCategoryId,
    required int providerId,
    int perPage = 10,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: 1,
      reviews: [],
    );

    try {
      final response = await _repository.getProviderReview(
        userId: userId,
        accessToken: accessToken,
        serviceCategoryId: serviceCategoryId,
        providerId: providerId,
        page: 1,
        perPage: perPage,
      );

      final hasMore = response.reviews.length >= perPage &&
          response.currentPage < response.totalPages;

      state = state.copyWith(
        isLoading: false,
        reviews: response.reviews,
        currentPage: 1,
        hasMore: hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Page Scroll Karne Par Load More (Pagination)
  Future<void> loadMoreReviews({
    required int userId,
    required String accessToken,
    required int serviceCategoryId,
    required int providerId,
    int perPage = 10,
  }) async {
    // Agar already loading ho rahi hai ya aur pages bache nahi hain to exit karo
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;

      final response = await _repository.getProviderReview(
        userId: userId,
        accessToken: accessToken,
        serviceCategoryId: serviceCategoryId,
        providerId: providerId,
        page: nextPage,
        perPage: perPage,
      );

      final newReviews = response.reviews;
      final hasMore = newReviews.length >= perPage &&
          nextPage < response.totalPages;

      state = state.copyWith(
        isLoadingMore: false,
        reviews: [...state.reviews, ...newReviews], // Old + New data join
        currentPage: nextPage,
        hasMore: hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

// 4. Provider Declaration
final providerReviewNotifierProvider =
StateNotifierProvider<ProviderReviewNotifier, ProviderReviewState>((ref) {
  return ProviderReviewNotifier(ref.watch(repositoryProvider));
});
