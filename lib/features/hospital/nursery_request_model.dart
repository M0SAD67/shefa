class NurseryRequest {
  final String? id;
  final String childName;
  final String phone;
  final String status;
  final String serviceType;
  final String time;

  NurseryRequest({
    this.id,
    required this.childName,
    required this.phone,
    required this.status,
    required this.serviceType,
    required this.time,
  });
}
