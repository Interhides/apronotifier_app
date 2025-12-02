class ProductionOrderModel {
  final int id;
  final String orderNumber;
  final String productName;
  final int quantity;
  final String status;

  ProductionOrderModel({
    required this.id,
    required this.orderNumber,
    required this.productName,
    required this.quantity,
    required this.status,
  });

  factory ProductionOrderModel.fromJson(Map<String, dynamic> json) {
    return ProductionOrderModel(
      id: json['id'],
      orderNumber: json['orderNumber'],
      productName: json['productName'],
      quantity: json['quantity'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'productName': productName,
      'quantity': quantity,
      'status': status,
    };
  }
}
