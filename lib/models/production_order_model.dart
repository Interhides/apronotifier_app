class ProductionOrderModel {
  final int id;
  final int requestId; // Foreign key to approval_requests
  final String type;
  final String orderDate;
  final String brand;
  final String line;
  final String sapPoNumber;
  final String materialCode;
  final int orderQty;
  final String batchCardNo;
  final int pcs;
  final double sf;
  final String packDate;
  final String source; // เหตุผล/Reason

  ProductionOrderModel({
    required this.id,
    required this.requestId,
    required this.type,
    required this.orderDate,
    required this.brand,
    required this.line,
    required this.sapPoNumber,
    required this.materialCode,
    required this.orderQty,
    required this.batchCardNo,
    required this.pcs,
    required this.sf,
    required this.packDate,
    required this.source,
  });

  factory ProductionOrderModel.fromJson(Map<String, dynamic> json) {
    return ProductionOrderModel(
      id: json['id'],
      requestId: json['requestId'],
      type: json['type'] ?? '',
      orderDate: json['orderDate'] ?? '',
      brand: json['brand'] ?? '',
      line: json['line'] ?? '',
      sapPoNumber: json['sapPoNumber'] ?? '',
      materialCode: json['materialCode'] ?? '',
      orderQty: json['orderQty'] ?? 0,
      batchCardNo: json['batchCardNo'] ?? '',
      pcs: json['pcs'] ?? 0,
      sf: json['sf'] != null ? (json['sf'] as num).toDouble() : 0.0,
      packDate: json['packDate'] ?? '',
      source: json['source'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestId': requestId,
      'type': type,
      'orderDate': orderDate,
      'brand': brand,
      'line': line,
      'sapPoNumber': sapPoNumber,
      'materialCode': materialCode,
      'orderQty': orderQty,
      'batchCardNo': batchCardNo,
      'pcs': pcs,
      'sf': sf,
      'packDate': packDate,
      'source': source,
    };
  }
}
