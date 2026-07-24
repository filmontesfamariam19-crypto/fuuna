class Challenge {
  final String id;
  final String sponsorId;
  final String title;
  final String description;
  final String rules;
  final String? bannerUrl;
  final String category;
  final double prizeAmount;
  final String currency;
  final bool isGlobal;
  final double? latitude;
  final double? longitude;
  final int? radiusKm;
  final DateTime startDate;
  final DateTime deadline;
  final int? maxParticipants;
  final String status;

  Challenge({
    required this.id,
    required this.sponsorId,
    required this.title,
    required this.description,
    required this.rules,
    this.bannerUrl,
    required this.category,
    required this.prizeAmount,
    required this.currency,
    required this.isGlobal,
    this.latitude,
    this.longitude,
    this.radiusKm,
    required this.startDate,
    required this.deadline,
    this.maxParticipants,
    required this.status,
  });

  factory Challenge.fromMap(Map<String, dynamic> map) => Challenge(
        id: map['id'],
        sponsorId: map['sponsor_id'],
        title: map['title'],
        description: map['description'],
        rules: map['rules'],
        bannerUrl: map['banner_url'],
        category: map['category'],
        prizeAmount: (map['prize_amount'] as num).toDouble(),
        currency: map['currency'],
        isGlobal: map['is_global'],
        latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
        longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
        radiusKm: map['radius_km'],
        startDate: DateTime.parse(map['start_date']),
        deadline: DateTime.parse(map['deadline']),
        maxParticipants: map['max_participants'],
        status: map['status'],
      );
}
