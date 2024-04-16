import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pract3/Model/CompanyDetail.dart';

class CompanyController extends GetxController {
  var companyList = <CompanyModel>[].obs;
  final TextEditingController _companyName = TextEditingController();
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
          .get('http://testecommerce.equitysofttechnologies.com/company/get');
      print(response);
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data["r"];
        List<CompanyModel> companylist =
            responseData.map((data) => CompanyModel.fromJson(data)).toList();
        _isLoading.value = false;
        companyList.assignAll(companylist);
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
        'http://testecommerce.equitysofttechnologies.com/company/add',
        data: {
          "company_name": _companyName.text,
        },
      );

      print(response);

      if (response.statusCode == 200) {
        print("posted successfully..");
        _companyName.clear();
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
        'http://testecommerce.equitysofttechnologies.com/company/delete',
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

class Company extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CompanyController companyController = Get.put(CompanyController());

  Company({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Company"),
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
                      controller: companyController._companyName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Category Name.....';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text(
                          "Company Name",
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
                    if (_formKey.currentState!.validate()) {
                      companyController.postData();
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
              companyController._isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                      itemCount: companyController.companyList.length,
                      shrinkWrap: false,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          height: 50,
                          width: double.infinity,
                          color: Colors.grey,
                          child: ListTile(
                            title: Text(companyController
                                .companyList[index].companyName),
                            trailing: IconButton(
                                onPressed: () {
                                  companyController.deleteData(
                                      companyController.companyList[index].id);
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
