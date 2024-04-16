import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pract3/category.dart';
import 'package:pract3/company.dart';
import 'package:pract3/Model/product/product.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Space(),
            getCard(
                title: "Product",
                onTap: () {
                  Get.to(() => Product());
                }),
            Space(),
            getCard(
              title: "Manage Category",
              onTap: () {
                Get.to(() => Category());
              },
            ),
            Space(),
            getCard(
              title: "Manage Company",
              onTap: () {
                Get.to(() => Company());
              },
            )
          ],
        ),
      ),
    );
  }

  Widget Space() {
    return const SizedBox(
      height: 10,
    );
  }

  Widget getCard({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
