import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'model/ReviewItem.dart';
import 'model/ServiceProvider.dart';
import 'network_manager/repository.dart';

final selectTabProvider = StateProvider<int>((ref) => 0);
final quantityProvider = StateProvider<int>((ref) => 1);

// --- REPOSITORY PROVIDER ---
final repositoryProvider = Provider<Repository>((ref) => Repository());

// --- PACKAGE STATE & NOTIFIER ---
class PackageState {
  final bool isLoading;
  final List<MainCategoryPackageData> packageList;
  final int selectedCategoryIndex;
  final String? error;

  PackageState({
    this.isLoading = true,
    this.packageList = const [],
    this.selectedCategoryIndex = 0,
    this.error,
  });

  PackageState copyWith({
    bool? isLoading,
    List<MainCategoryPackageData>? packageList,
    int? selectedCategoryIndex,
    String? error,
  }) {
    return PackageState(
      isLoading: isLoading ?? this.isLoading,
      packageList: packageList ?? this.packageList,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      error: error,
    );
  }
}

class PackageNotifier extends StateNotifier<PackageState> {
  PackageNotifier() : super(PackageState()) {
    loadPackages();
  }

  Future<void> loadPackages() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      state = state.copyWith(
        isLoading: false,
        packageList: mainCategoryPackageList,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectCategory(int index) {
    state = state.copyWith(selectedCategoryIndex: index);
  }

  void addPackage(PackageData packageData) {
    packageData.isAdd = true;
    packageData.count = '1';
    state = state.copyWith(packageList: List.from(state.packageList));
  }

  void incrementPackage(PackageData packageData) {
    int currentQty = int.tryParse(packageData.count) ?? 1;
    packageData.count = (currentQty + 1).toString();
    packageData.isAdd = true;
    state = state.copyWith(packageList: List.from(state.packageList));
  }

  void decrementPackage(PackageData packageData) {
    int currentQty = int.tryParse(packageData.count) ?? 1;
    if (currentQty > 1) {
      packageData.count = (currentQty - 1).toString();
    } else {
      packageData.count = '0';
      packageData.isAdd = false;
    }
    state = state.copyWith(packageList: List.from(state.packageList));
  }

  int get totalItemCount {
    int total = 0;
    for (var cat in state.packageList) {
      for (var pkg in cat.packageData) {
        if (pkg.isAdd == true) {
          total += int.tryParse(pkg.count) ?? 0;
        }
      }
    }
    return total;
  }

  double get totalPrice {
    double total = 0.0;
    for (var cat in state.packageList) {
      for (var pkg in cat.packageData) {
        if (pkg.isAdd == true) {
          int count = int.tryParse(pkg.count) ?? 0;
          double price = double.tryParse(pkg.amount) ?? 0.0;
          total += (count * price);
        }
      }
    }
    return total;
  }
}

final packageNotifierProvider =
    StateNotifierProvider<PackageNotifier, PackageState>((ref) {
  return PackageNotifier();
});

// --- PROVIDER REVIEW STATE & NOTIFIER ---
class ProviderReviewState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<ReviewItem> reviews;
  final int currentPage;
  final bool hasMore;
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

class ProviderReviewNotifier extends StateNotifier<ProviderReviewState> {
  final Repository _repository;

  ProviderReviewNotifier(this._repository) : super(ProviderReviewState());

  bool _isAlreadyFetched = false;

  Future<void> fetchInitialReviews({
    required int userId,
    required String accessToken,
    required int serviceCategoryId,
    required int providerId,
    int perPage = 10,
  }) async {
    if (_isAlreadyFetched) return;

    state = state.copyWith(isLoading: true, error: null, currentPage: 1);

    try {
      final response = await _repository.getProviderReview(
        userId: userId,
        accessToken: accessToken,
        serviceCategoryId: serviceCategoryId,
        providerId: providerId,
        page: 1,
        perPage: perPage,
      );

      _isAlreadyFetched = true;
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

  Future<void> loadMoreReviews({
    required int userId,
    required String accessToken,
    required int serviceCategoryId,
    required int providerId,
    int perPage = 10,
  }) async {
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
        reviews: [...state.reviews, ...newReviews],
        currentPage: nextPage,
        hasMore: hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

final providerReviewNotifierProvider =
    StateNotifierProvider<ProviderReviewNotifier, ProviderReviewState>((ref) {
  return ProviderReviewNotifier(ref.watch(repositoryProvider));
});
