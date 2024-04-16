class ProductModel {
  int id;
  String productName;
  int categoryId;
  String categoryName;
  int companyId;
  String companyName;
  String description;
  int price;
  int qty;
  String createdAt;
  int status;
  List<ProductImage> productImg;

  ProductModel({
    this.id = 0,
    this.productName = "",
    this.categoryId = 0,
    this.categoryName = "",
    this.companyId = 0,
    this.companyName = "",
    this.description = "",
    this.price = 0,
    this.qty = 0,
    this.createdAt = "",
    this.status = 0,
    this.productImg = const [],
  });

  // productlist.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   productName = json['product_name'];
  //   categoryId = json['category_id'];
  //   categoryName = json['category_name'];
  //   companyId = json['company_id'];
  //   companyName = json['company_name'];
  //   description = json['description'];
  //   price = json['price'];
  //   qty = json['qty'];
  //   createdAt = json['created_at'];
  //   status = json['status'];
  //   if (json['product_img'] != null) {
  //     productImg = <ProductImg>[];
  //     json['product_img'].forEach((v) {
  //       productImg!.add(new ProductImg.fromJson(v));
  //     });
  //   }
  // }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'] ?? 0,
        productName: json['product_name'] ?? ",",
        categoryId: json['category_id'] ?? 0,
        categoryName: json['category_name'] ?? ",",
        companyId: json['company_id'] ?? 0,
        companyName: json['company_name'] ?? ",",
        description: json['description'] ?? ",",
        price: json['price'] ?? 0,
        qty: json['qty'] ?? 0,
        createdAt: json['created_at'] ?? ",",
        status: json['status'] ?? ",",
        productImg: List<ProductImage>.from(
            (json['product_img'] ?? []).map((e) => ProductImage.fromJson(e)))
        // productImg : <ProductImg>[]
        // json['product_img'].forEach((v) {
        //   productImg!.add(new ProductImg.fromJson(v));
        // );
        );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['product_name'] = productName;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['company_id'] = companyId;
    data['company_name'] = companyName;
    data['description'] = description;
    data['price'] = price;
    data['qty'] = qty;
    data['created_at'] = createdAt;
    data['status'] = status;
    if (productImg != null) {
      data['product_img'] = productImg!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductImage {
  int? id;
  int? productId;
  String? productImg;
  String? createdAt;

  ProductImage({this.id, this.productId, this.productImg, this.createdAt});

  // ProductImg.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   productId = json['product_id'];
  //   productImg = json['product_img'];
  //   createdAt = json['created_at'];
  // }

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productImg: json['product_img'] ?? ",",
      createdAt: json['created_at'] ?? ",",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['product_img'] = this.productImg;
    data['created_at'] = this.createdAt;
    return data;
  }
}
