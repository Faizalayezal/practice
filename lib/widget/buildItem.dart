import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foxtask/DetailNotifire.dart';
import 'package:foxtask/model/ServiceProvider.dart';

import '../RoundedCachedImage.dart';

Widget buildCategoryItem(String title, String ImageUrl) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        height: 70,
        width: 70,
        child: ClipOval(
          child: Image.network(
            ImageUrl,
            height: 70,
            width: 70,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: 6),
      SizedBox(
        height: 50,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}

Widget buildCategory(
  BuildContext context,
  ServiceProvider service,
  VoidCallback Click,
) {
  return GestureDetector(
    onTap: () {
      Click.call();
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'profile_${service.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                service.imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, err, stackTrace) =>
                    Container(width: 80, height: 80, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    Text(
                      "${service.distance} km away",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    Text(
                      service.rating > 0
                          ? '${service.rating} (${service.reviews})'
                          : '--',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 14,
                      width: 1,
                      color: Colors.grey,
                    ),
                    const Icon(
                      Icons.work_outline,
                      size: 14,
                      color: Colors.grey,
                    ),
                    Text(
                      ' ${service.jobs}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                SizedBox(height: 4),

                Text(
                  service.services.join(', '),
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildTapButton(String text, IconData icon, int index) {
  return Consumer(
    builder: (context, ref, child) {
      final selectedIndex = ref.watch(selectTabProvider);
      bool isSelected = selectedIndex == index;
      return GestureDetector(
        onTap: () {
          ref.read(selectTabProvider.notifier).state = index;
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.shade50 : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.green : Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.green : Colors.black87,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.green : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildPackageView() {
  return Consumer(
    builder: (context, ref, child) {
      final packageState = ref.watch(packageNotifierProvider);

      if (packageState.isLoading) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Center(child: CircularProgressIndicator(color: Colors.green)),
        );
      }

      if (packageState.error != null) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Error loading packages: ${packageState.error}',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      }

      final packageList = packageState.packageList;
      final selectedIndex = packageState.selectedCategoryIndex;
      final safeIndex = selectedIndex < packageList.length ? selectedIndex : 0;
      final selectedCategory = packageList[safeIndex];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: packageList.length,
              itemBuilder: (context, index) {
                final isSelected = index == safeIndex;
                return GestureDetector(
                  onTap: () {
                    ref
                        .read(packageNotifierProvider.notifier)
                        .selectCategory(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildServiceChip(
                      packageList[index].title,
                      isSelected,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: selectedCategory.packageData.length,
            itemBuilder: (context, index) {
              final subData = selectedCategory.packageData[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildPackageItem(
                  title: subData.title,
                  price: '\$ ${subData.amount}',
                  description: subData.description,
                  packageData: subData,
                ),
              );
            },
          ),
          const Divider(height: 32, thickness: 1),
        ],
      );
    },
  );
}

Widget _buildPackageItem({
  required String title,
  required String price,
  required String description,
  required PackageData packageData,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            Consumer(
              builder: (context, ref, child) {
                ref.watch(packageNotifierProvider);
                final notifier = ref.read(packageNotifierProvider.notifier);
                final isAdded = packageData.isAdd ?? false;
                final currentQty = int.tryParse(packageData.count) ?? 1;

                if (isAdded) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            notifier.decrementPackage(packageData);
                          },
                          child: const Icon(
                            Icons.remove,
                            size: 16,
                            color: Colors.green,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                          child: Text(
                            '$currentQty',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            notifier.incrementPackage(packageData);
                          },
                          child: const Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return OutlinedButton(
                    onPressed: () {
                      notifier.addPackage(packageData);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.green),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(color: Colors.grey, height: 1.5),
        ),
      ],
    ),
  );
}

Widget _buildServiceChip(String text, bool isSelected) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? Colors.green.shade50 : Colors.white,
      border: Border.all(
        color: isSelected ? Colors.green : Colors.grey.shade400,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.black54,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    ),
  );
}

Widget buildReviewView() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=200&auto=format&fit=crop',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ft Jeel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '27/05/2025',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                    (index) => const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "I couldn't be happier with the service I received! This is hands-down the best home cleaning and handyman service I've ever used. From the moment I booked, the entire process was smooth, professional, and reliable. The team arrived on time, well-prepared, and ready to tackle everything on my list—from deep cleaning the kitchen and bathrooms to fixing a leaky faucet and assembling a new shelf.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}

Widget buildGalleryView() {
  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    shrinkWrap: true,
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: gridList.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 1.0,
    ),
    itemBuilder: (context, index) {
      return RoundedCachedImage(imageUrl: gridList[index].imageURl);
    },
  );
}
