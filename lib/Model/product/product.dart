import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../productDetail.dart';
import 'add_product.dart';
import 'detail_screen.dart';

class ProductController extends GetxController {
  var productList = <ProductModel>[].obs;
  final _isLoading = true.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
    update();
  }

  void getData() async {
    try {
      var response = await Dio()
          .get('http://testecommerce.equitysofttechnologies.com/product/get');
      print(response);

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data["r"];
        List<ProductModel> productlist =
            responseData.map((data) => ProductModel.fromJson(data)).toList();
        _isLoading.value = false;
        productList.assignAll(productlist);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteData(int id) async {
    try {
      var response = await Dio().post(
          'http://testecommerce.equitysofttechnologies.com/product/delete',
          data: {
            "id": id,
          });
      if (response.statusCode == 200) {
        productList.removeWhere((product) => product.id == id);
        Get.snackbar('Success', 'Product Deleted Successfully...',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      } else {
        Get.snackbar('Error', 'Failed To Delete Product...',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Error deleting product',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void addProduct(ProductModel newProduct) {
    productList.add(newProduct);
  }

  void navigateToAddProductPage(ProductModel product) {
    Get.to(() => AddProduct(addProduct: addProduct, editProduct: product));
  }
}

class Product extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  Product({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AddProduct(
                    addProduct: productController.addProduct,
                    editProduct: ProductModel(),
                  ));
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10))
        ],
        title: const Text("Product"),
      ),
      body: Obx(
        () => productController._isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: productController.productList.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = productController.productList[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => DetailScreen(product: product));
                    },
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      margin: const EdgeInsets.all(10),
                      color: Colors.grey,
                      child: ListTile(
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: product.productImg.isNotEmpty
                              ? Image(
                                  image: NetworkImage(
                                    "https://testecommerce.equitysofttechnologies.com/uploads/product_img/${product.productImg.first.productImg!}",
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        title: Column(
                          children: [
                            Text(product.productName),
                            Text(product.categoryName),
                            Text(product.qty.toString()),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              width: 100,
                              height: 20,
                              child: ElevatedButton(
                                onPressed: () {
                                  productController
                                      .navigateToAddProductPage(product);
                                },
                                child: const Text("Edit"),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              height: 20,
                              child: ElevatedButton(
                                onPressed: () {
                                  productController.deleteData(product.id);
                                },
                                child: const Text("Delete"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
