class KycCase {
  const KycCase({
    required this.id,
    this.status,
    this.currentStage,
  });

  final String id;
  final String? status;
  final String? currentStage;

  static KycCase? fromJson(dynamic json) {
    if (json is! Map) return null;
    final id = json['id']?.toString().trim();
    if (id == null || id.isEmpty) return null;
    return KycCase(
      id: id,
      status: _nonEmpty(json['status']),
      currentStage: _nonEmpty(json['currentStage']),
    );
  }

  static String? _nonEmpty(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
