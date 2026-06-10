class PatientService {
  const PatientService({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.description,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.hospitalPhone,
  });

  final String id;
  final String name;
  final String type;
  final int capacity;
  final List<String> description;
  final String hospitalName;
  final String hospitalAddress;
  final String hospitalPhone;

  bool get isAvailable => capacity > 0;
  bool get isNicu => name.toLowerCase().contains('nicu');

  String get availabilityText => isAvailable ? '$capacity متاح' : 'غير متاح';

  static List<PatientService> listFromServicesResponse(dynamic data) {
    final services = data?['data']?['services'];
    if (services is! List) return const [];

    final result = <PatientService>[];
    for (final item in services) {
      if (item is! Map) continue;

      final nestedServices = item['services'];
      if (nestedServices is List) {
        for (final service in nestedServices) {
          if (service is Map) {
            result.add(PatientService.fromService(service, item));
          }
        }
      } else {
        result.add(PatientService.fromService(item, item['hospital']));
      }
    }
    return result;
  }

  static List<PatientService> listFromChildcareResponse(dynamic data) {
    final childcare = data?['data']?['childcare'];
    if (childcare is! List) return const [];

    return childcare
        .whereType<Map>()
        .map((item) => PatientService.fromService(item, item['hospitalId']))
        .toList();
  }

  factory PatientService.fromService(dynamic service, dynamic hospital) {
    final serviceMap = service is Map ? service : const {};
    final hospitalMap = hospital is Map ? hospital : const {};
    final location = hospitalMap['location'];

    String address = '';
    if (location is Map) {
      address =
          location['address']?.toString() ??
          location['city']?.toString() ??
          location.values.map((value) => value.toString()).join(', ');
    } else if (location != null) {
      address = location.toString();
    }

    final description = serviceMap['description'];
    final parsedDescription = description is List
        ? description.map((item) => item.toString()).toList()
        : description == null || description.toString().isEmpty
        ? <String>[]
        : <String>[description.toString()];

    return PatientService(
      id: serviceMap['_id']?.toString() ?? serviceMap['id']?.toString() ?? '',
      name: serviceMap['name']?.toString() ?? 'خدمة طبية',
      type: serviceMap['type']?.toString() ?? '',
      capacity: (serviceMap['capacity'] as num?)?.toInt() ?? 0,
      description: parsedDescription,
      hospitalName: hospitalMap['name']?.toString() ?? 'مستشفى',
      hospitalAddress: address,
      hospitalPhone: hospitalMap['phone']?.toString() ?? '',
    );
  }
}
