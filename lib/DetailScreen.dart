import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foxtask/DetailNotifire.dart';
import 'package:foxtask/widget/buildItem.dart';

import 'model/ServiceProvider.dart';

class Detailscreen extends ConsumerStatefulWidget {
  final ServiceProvider service;

  Detailscreen({super.key, required this.service});

  @override
  ConsumerState<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends ConsumerState<Detailscreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Scroll listener tabhi pagination trigger karega jab selectedTabIndex == 1 (Review tab) hoga
    _scrollController.addListener(() {
      final selectedTabIndex = ref.read(selectTabProvider);
      if (selectedTabIndex == 1) {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          ref.read(providerReviewNotifierProvider.notifier).loadMoreReviews(
                userId: 881,
                accessToken: "713602132025270532",
                serviceCategoryId: 19,
                providerId: int.tryParse(widget.service.id) ?? 42,
              );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Review Tab (index == 1) select hone par hi initial API call call hogi
    ref.listen<int>(selectTabProvider, (previous, next) {
      if (next == 1) {
        ref.read(providerReviewNotifierProvider.notifier).fetchInitialReviews(
              userId: 881,
              accessToken: "713602132025270532",
              serviceCategoryId: 19,
              providerId: int.tryParse(widget.service.id) ?? 42,
            );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        scrolledUnderElevation: 4,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            ref.read(selectTabProvider.notifier).state = 0;
            ref.read(quantityProvider.notifier).state = 1;
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Select Package",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final selectedTabIndex = ref.watch(selectTabProvider);
              return SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  bottom: selectedTabIndex == 0 ? 120 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: buildCategory(context, widget.service, () {}),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTapButton('Packages', Icons.book, 0),
                          const SizedBox(width: 8),
                          buildTapButton(
                            'Review',
                            Icons.stop_circle_outlined,
                            1,
                          ),
                          const SizedBox(width: 8),
                          buildTapButton(
                            'Gallery',
                            Icons.photo_library_outlined,
                            2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (selectedTabIndex == 0) buildPackageView(),
                    if (selectedTabIndex == 1) buildReviewView(),
                    if (selectedTabIndex == 2) buildGalleryView(),
                  ],
                ),
              );
            },
          ),

          Consumer(
            builder: (context, ref, child) {
              final selectedTabIndex = ref.watch(selectTabProvider);
              if (selectedTabIndex != 0) return const SizedBox.shrink();

              ref.watch(packageNotifierProvider);
              final notifier = ref.read(packageNotifierProvider.notifier);
              final totalItems = notifier.totalItemCount;
              final totalPrice = notifier.totalPrice;

              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Value( $totalItems item${totalItems == 1 ? '' : 's'} )',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            '\$ ${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Proceed',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
