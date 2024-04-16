import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Model/CategoryDetail.dart';

class CategoryController extends GetxController {
  var categoryList = <CategoryModel>[].obs;
  final TextEditingController _categoryName = TextEditingController();
  final _isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  void getData() async {
    try {
      var response = await Dio()
          .get('http://testecommerce.equitysofttechnologies.com/category/get');
      print(response);
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data["r"];
        List<CategoryModel> categorylist =
            responseData.map((data) => CategoryModel.fromJson(data)).toList();
        _isLoading.value = false;
        categoryList.assignAll(categorylist);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void postData() async {
    try {
      var response = await Dio().post(
        'http://testecommerce.equitysofttechnologies.com/category/add',
        data: {
          "category_name": _categoryName.text,
        },
      );

      print(response);

      if (response.statusCode == 200) {
        print("posted successfully..");
        _categoryName.clear();
        getData();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteData(int? categoryId) async {
    try {
      var response = await Dio().post(
        'http://testecommerce.equitysofttechnologies.com/category/delete',
        data: {
          "id": categoryId,
        },
      );

      if (response.statusCode == 200) {
        print("Deleted successfully..");
        getData();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
}

class Category extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CategoryController categoryController = Get.put(CategoryController());

  Category({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Category"),
        ),
        body: Obx(
          () => Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                    key: _formKey,
                    child: TextFormField(
                      key: const Key('categoryNameField'),
                      controller: categoryController._categoryName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Category Name.....';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text(
                          "Category Name",
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 70,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    final form = _formKey.currentState!;
                    if (form.validate()) {
                      categoryController.postData();
                    }
                  },
                  child: const Text("Add"),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "List Of Category.",
                  textAlign: TextAlign.start,
                ),
              ),
              categoryController._isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                      itemCount: categoryController.categoryList.length,
                      shrinkWrap: false,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          height: 50,
                          width: double.infinity,
                          color: Colors.grey,
                          child: ListTile(
                            title: Text(categoryController
                                .categoryList[index].categoryName),
                            trailing: IconButton(
                                onPressed: () {
                                  categoryController.deleteData(
                                      categoryController
                                          .categoryList[index].id);
                                },
                                icon: const Icon(Icons.delete)),
                          ),
                        );
                      },
                    ))
            ],
          ),
        ));
  }
}
