import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foxtask/DetailNotifire.dart';
import 'package:foxtask/widget/buildItem.dart';

import 'DetailScreen.dart';
import 'model/ServiceProvider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(homeNotifierProvider.notifier).fetchHomeData(
            userId: 946,
            accessToken: "935849072025250773",
            serviceCategoryId: 19,
            lat: 22.3187483,
            long: 70.7671133,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        scrolledUnderElevation: 4,
        centerTitle: false,
        titleSpacing: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Home cleaning",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildCategoryItem(
                        categoryList[index].title,
                        categoryList[index].imageURl,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'Sponsor Service Provider',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.length,
                itemBuilder: (context, index) {
                  return buildCategory(context, provider[index], () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Detailscreen(service: provider[index]),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
