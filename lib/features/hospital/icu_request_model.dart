class IcuRequest {
  final String? id;
  final String patientName;
  final String phone;
  final String status;
  final String serviceType;
  final String time;

  const IcuRequest({
    this.id,
    required this.patientName,
    required this.phone,
    required this.status,
    required this.serviceType,
    required this.time,
  });
}
