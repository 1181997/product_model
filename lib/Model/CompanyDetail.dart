class CompanyModel {
  int id;
  String companyName;

  CompanyModel({this.id =0, this.companyName=""});


  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? 0,
      companyName: json['company_name'] ?? ",",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['company_name'] = companyName;
    return data;
  }
}
