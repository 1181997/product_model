import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pract3/Model/product/product.dart';
import '../productDetail.dart';
import 'add_product.dart';

class DetailScreen extends StatelessWidget {
  final ProductModel product;
  DetailScreen({super.key, required this.product});

  final ProductController productController = Get.put(ProductController());

  void deleteData(int id) async {
    try {
      var response = await Dio().post(
        'http://testecommerce.equitysofttechnologies.com/product/delete',
        data: {"id": id},
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Product deleted successfully');
        productController.getData();
      } else {
        Get.snackbar('Error', 'Failed to delete product');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Error deleting product');
    }
  }

  void navigateToEditProduct(ProductModel product) {
    Get.to(() => AddProduct(
          editProduct: product,
          addProduct: (ProductModel newProduct) {},
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Detail Screen"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            height: 200,
            width: double.infinity,
            color: Colors.grey,
            child: product.productImg.isNotEmpty
                ? PageView.builder(
                    itemCount: product.productImg.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        "https://testecommerce.equitysofttechnologies.com/uploads/product_img/${product.productImg[index].productImg!}",
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      );
                    },
                  )
                : const SizedBox(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Text(product.productName),
                    Text(product.categoryName),
                  ],
                ),
              ),
              const SizedBox(width: 125),
              Row(
                children: [
                  const Text("Price:"),
                  Text("${product.price}"),
                ],
              )
            ],
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(product.companyName),
                const SizedBox(width: 125),
                Row(
                  children: [
                    const Text("Qty:"),
                    Text("${product.qty}"),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width - 20,
                child: Text(
                  "Description:\n  ${product.description}",
                  maxLines: null,
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      navigateToEditProduct(product);
                    },
                    child: const Text("Edit"),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      deleteData(product.id);
                    },
                    child: const Text("Delete"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
