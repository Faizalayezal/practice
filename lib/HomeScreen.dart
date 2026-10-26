import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foxtask/widget/buildItem.dart';

import 'DetailScreen.dart';
import 'model/ServiceProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text(
          "Home cleaning",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
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
                physics: NeverScrollableScrollPhysics(),
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
