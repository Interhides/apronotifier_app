class ApprovalRequestModel {
  final int id;
  final String requestMessage; // คำขอ เช่น "Below order packed qty over 30%..."
  final String requesterName; // ชื่อคนขอ
  final String requestDate; // วันที่ขอ
  final String requestTime; // เวลา
  final int soCount; // จำนวน SO ในคำร้อง
  final String status; // Pending, Approved, Rejected

  ApprovalRequestModel({
    required this.id,
    required this.requestMessage,
    required this.requesterName,
    required this.requestDate,
    required this.requestTime,
    required this.soCount,
    required this.status,
  });

  factory ApprovalRequestModel.fromJson(Map<String, dynamic> json) {
    return ApprovalRequestModel(
      id: json['id'],
      requestMessage: json['requestMessage'] ?? '',
      requesterName: json['requesterName'] ?? '',
      requestDate: json['requestDate'] ?? '',
      requestTime: json['requestTime'] ?? '',
      soCount: json['soCount'] ?? 0,
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestMessage': requestMessage,
      'requesterName': requesterName,
      'requestDate': requestDate,
      'requestTime': requestTime,
      'soCount': soCount,
      'status': status,
    };
  }
}
