class SOModel {
  final int id;
  final int requestId; // เชื่อมกับ approval request
  final String type; // Z12M, Z12H
  final String orderDate; // Order date
  final String brand; // ADIDAS, etc.
  final String sapSoNumber; // SAP SO NUMBER
  final String line; // Line number
  final String sapPoNumber; // SAP PO NUMBER
  final String materialCode; // Material Code
  final int orderQty; // Order quantity
  final String batchCardNo; // BATCH CARD NO.
  final int pcs; // PCS (pieces)
  final double sf; // SF (square feet)
  final String packDate; // PACK DATE
  final String source; // SOURCE
  final String status; // Pending, Approved

  SOModel({
    required this.id,
    required this.requestId,
    required this.type,
    required this.orderDate,
    required this.brand,
    required this.sapSoNumber,
    required this.line,
    required this.sapPoNumber,
    required this.materialCode,
    required this.orderQty,
    required this.batchCardNo,
    required this.pcs,
    required this.sf,
    required this.packDate,
    required this.source,
    required this.status,
  });

  factory SOModel.fromJson(Map<String, dynamic> json) {
    return SOModel(
      id: json['id'],
      requestId: json['requestId'] ?? 0,
      type: json['type'] ?? '',
      orderDate: json['orderDate'] ?? '',
      brand: json['brand'] ?? '',
      sapSoNumber: json['sapSoNumber'] ?? '',
      line: json['line'] ?? '',
      sapPoNumber: json['sapPoNumber'] ?? '',
      materialCode: json['materialCode'] ?? '',
      orderQty: json['orderQty'] ?? 0,
      batchCardNo: json['batchCardNo'] ?? '',
      pcs: json['pcs'] ?? 0,
      sf: json['sf']?.toDouble() ?? 0.0,
      packDate: json['packDate'] ?? '',
      source: json['source'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestId': requestId,
      'type': type,
      'orderDate': orderDate,
      'brand': brand,
      'sapSoNumber': sapSoNumber,
      'line': line,
      'sapPoNumber': sapPoNumber,
      'materialCode': materialCode,
      'orderQty': orderQty,
      'batchCardNo': batchCardNo,
      'pcs': pcs,
      'sf': sf,
      'packDate': packDate,
      'source': source,
      'status': status,
    };
  }
}
