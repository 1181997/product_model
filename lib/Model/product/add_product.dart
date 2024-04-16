import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart%20';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pract3/Model/product/product.dart';
import 'package:pract3/Model/productDetail.dart';
import '../CategoryDetail.dart';
import '../CompanyDetail.dart';

class AddProductController extends GetxController {

  final ProductModel editProduct;

  AddProductController(this.editProduct);

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  List<XFile> _images = [];
  final RxnInt _selectedCategoryId = RxnInt();
  final RxnInt _selectedCompanyId = RxnInt();

  List<CategoryModel> _categoryDropdownItems = [];
  List<CompanyModel> _companyDropdownItems = [];
  List<ProductModel> productlist = [];
  List<ProductModel> newproduct = [];

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    callback();

    _productName.text = editProduct.productName;
    _description.text = editProduct.description;
    _price.text = editProduct.price.toString();
    _qty.text = editProduct.qty.toString();
    if(editProduct.categoryId > 0) {
      _selectedCategoryId.value = editProduct.categoryId;
    }
    if(editProduct.companyId > 0) {
      _selectedCompanyId.value = editProduct.companyId;
    }

    await getCategoryData();
    await getCompanyData();

    if (_categoryDropdownItems.isEmpty) {
      _selectedCategoryId.value = _categoryDropdownItems[0].id;
    }
    if (_companyDropdownItems.isEmpty) {
      _selectedCompanyId.value = _companyDropdownItems[0].id;
    }

    if (editProduct.productImg.isNotEmpty) {
      _images = editProduct.productImg
          .map((img) => XFile(img.productImg!))
          .toList();
    }
  }

  callback() async {
    await getCategoryData();
    await getCompanyData();
  }

  Future<void> getCategoryData() async {
    try {
      var response = await Dio()
          .get('http://testecommerce.equitysofttechnologies.com/category/get');
      print(response);
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data["r"];
        _categoryDropdownItems =
            responseData.map((data) => CategoryModel.fromJson(data)).toList();
        update();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getCompanyData() async {
    try {
      var response = await Dio()
          .get('http://testecommerce.equitysofttechnologies.com/company/get');
      print(response);

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data["r"];
        _companyDropdownItems =
            responseData.map((data) => CompanyModel.fromJson(data)).toList();
        update();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _images.add(XFile(pickedFile.path));
      update();
    }
  }

  final _postingData = false.obs;
  Future<void> postData() async {
    _postingData.value = true;
    List<XFile> images = _images
        .where((element) => element.path.contains("com.example.pract3"))
        .toList();
    try {
      Map<String, dynamic> body = {
        "product_name": _productName.text,
        "category_id": _selectedCategoryId,
        "company_id": _selectedCompanyId,
        "description": _description.text,
        "price": int.parse(_price.text),
        "qty": int.parse(_qty.text),
        for (int i = 0; i < images.length; i++)
          "product_img[$i]": await dio.MultipartFile.fromFile(images[i].path)
      };
      if (editProduct.id > 0) {
        body["id"] = editProduct.id;
      }
      print(body);

      var response = await Dio().post(
          editProduct.id > 0
              ? 'http://testecommerce.equitysofttechnologies.com/product/update'
              : 'http://testecommerce.equitysofttechnologies.com/product/add',
          data: dio.FormData.fromMap(body));

      if (response.statusCode == 200) {
        print(response.data);

        Get.to(() => Product());
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    } finally {
      _postingData.value = false;
    }
  }

  void addProduct(ProductModel newProduct) {
    productlist.add(newProduct);
  }
}

class AddProduct extends StatelessWidget {
  final ProductModel editProduct;

  final GlobalKey<FormState> _productNameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _categoryFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _companyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _descriptionFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _priceFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _qtyFormKey = GlobalKey<FormState>();

  AddProduct(
      {super.key,
      required void Function(ProductModel newProduct) addProduct,
      required this.editProduct});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Products"),
        ),
        body: GetBuilder<AddProductController>(
          init: AddProductController(editProduct),
          builder: (controller) {
            controller._productName.text = editProduct.productName;
            controller._description.text = editProduct.description;
            controller._price.text = editProduct.price.toString();
            controller._qty.text = editProduct.qty.toString();
            controller._selectedCategoryId.value = editProduct.categoryId;
            controller._selectedCompanyId.value = editProduct.companyId;
            controller._images = editProduct.productImg
                .map((img) => XFile(img.productImg!))
                .toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),

                  Textfield(
                      labeltext: "Product Name",
                      keyboard: TextInputType.text,
                      formKey: _productNameFormKey,
                      controller: controller._productName),

                  Menu(
                    formKey: _categoryFormKey,
                    value: controller._selectedCategoryId.value ?? 0,
                    labeltext: "Category",
                    items: controller._categoryDropdownItems
                        .map((category) => DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(category.categoryName.toString())))
                        .toList(),
                    onChanged: (value) {
                      controller._selectedCategoryId.value = value!;
                    },
                  ),

                  Menu(
                    formKey: _companyFormKey,
                    value: controller._selectedCompanyId.value ?? 0,
                    labeltext: "Company Name",
                    items: controller._companyDropdownItems
                        .map((company) => DropdownMenuItem<int>(
                            value: company.id,
                            child: Text(company.companyName.toString())))
                        .toList(),
                    onChanged: (value) {
                      controller._selectedCompanyId.value = value!;
                    },
                  ),

                  Textfield(
                      labeltext: "Description",
                      keyboard: TextInputType.text,
                      formKey: _descriptionFormKey,
                      controller: controller._description),

                  Textfield(
                      labeltext: "Price",
                      keyboard: TextInputType.number,
                      formKey: _priceFormKey,
                      controller: controller._price),

                  Textfield(
                      labeltext: "Qty",
                      keyboard: TextInputType.number,
                      formKey: _qtyFormKey,
                      controller: controller._qty),

                  Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: const Text(
                      "Upload Image:",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children:
                          List.generate(controller._images.length + 1, (index) {
                        if (index == controller._images.length) {
                          return Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              height: 50,
                              child: IconButton(
                                onPressed: () {
                                  controller._pickImage(ImageSource.camera);
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ),
                          );
                        } else {
                          return Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              height: 50,
                              child: controller._images[index].path.isNotEmpty
                                  ? controller._images[index].path
                                          .contains('com.example.pract3')
                                      ? Image.file(
                                          File(controller._images[index].path),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          "https://testecommerce.equitysofttechnologies.com/uploads/product_img/${controller._images[index].path}",
                                          fit: BoxFit.cover,
                                        )
                                  : const Placeholder(
                                      color: Colors.red,
                                    ),
                            ),
                          );
                        }
                      }),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: const Text(
                      "Minimum 2 Image",
                      textAlign: TextAlign.end,
                    ),
                  ),
                  controller._postingData.value
                       ? const Center(child: CircularProgressIndicator())
                 : Container(
                      width: double.infinity,
                      color: Colors.grey,
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_productNameFormKey.currentState!.validate() &&
                                _categoryFormKey.currentState!.validate() &&
                                _companyFormKey.currentState!.validate() &&
                                _descriptionFormKey.currentState!.validate() &&
                                _priceFormKey.currentState!.validate() &&
                                _qtyFormKey.currentState!.validate()) {
                              await controller.postData();
                              Get.offAll(() => Product());
                            }
                          },
                          child: const Text("Save"))),
                ],
              ),
            );
          },
        ));
  }

  Widget Textfield(
      {required String labeltext,
      required GlobalKey<FormState> formKey,
      required TextEditingController controller,
      required TextInputType keyboard}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Form(
          key: formKey,
          child: TextFormField(
            keyboardType: keyboard,
            controller: controller,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Detail.....';
              }
              return null;
            },
            decoration: InputDecoration(
              label: Text(labeltext),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )),
    );
  }

  Widget Menu({
    required int value,
    required String labeltext,
    required List<DropdownMenuItem<int>> items,
    required void Function(int?) onChanged,
    required GlobalKey<FormState> formKey,
  }) {
    bool isValueValid = items.any((item) => item.value == value);
    return Container(
      margin: const EdgeInsets.all(10),
      child: Form(
        key: formKey,
        child: DropdownButtonFormField<int>(
            key: UniqueKey(),
            value: isValueValid ? value : null,
            decoration: InputDecoration(
                label: Text(labeltext),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            items: items,
            onChanged: onChanged),
      ),
    );
  }
}
