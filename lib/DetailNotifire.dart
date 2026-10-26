import 'package:flutter_riverpod/legacy.dart';

import 'model/ServiceProvider.dart';

final selectTabProvider = StateProvider<int>((ref) => 0);
final quantityProvider = StateProvider<int>((ref) => 1);

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
