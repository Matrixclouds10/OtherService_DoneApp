class InvoiceModel {
  int? id;
  String? providerName;
  String? clientName;
  String? serviceName;
  dynamic price;
  dynamic? taxes;
  dynamic? total;

  InvoiceModel(
      {this.id,
        this.providerName,
        this.clientName,
        this.serviceName,
        this.price,
        this.taxes,
        this.total});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerName = json['provider_name'];
    clientName = json['client_name'];
    serviceName = json['service_name'];
    price = json['price'];
    taxes = json['taxes'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['provider_name'] = providerName;
    data['client_name'] = clientName;
    data['service_name'] = serviceName;
    data['price'] = price;
    data['taxes'] = taxes;
    data['total'] = total;
    return data;
  }
}
