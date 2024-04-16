class CategoryModel {
  int id;
  String categoryName;

  CategoryModel({this.id = 0, this.categoryName = ""});


  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      categoryName: json['category_name'] ?? ",",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    return data;
  }
}
