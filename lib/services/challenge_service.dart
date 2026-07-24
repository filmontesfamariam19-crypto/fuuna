import 'package:supabase_flutter/supabase_flutter.dart';

class ChallengeService {
  static final _client = Supabase.instance.client;

  static Future<void> createChallenge({
    required String title,
    required String description,
    required String rules,
    required double prizeAmount,
    required String category,
    required DateTime deadline,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final sponsor = await _client
        .from('sponsors')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    if (sponsor == null) throw Exception('User is not a registered sponsor');

    await _client.from('challenges').insert({
      'sponsor_id': user.id,
      'title': title,
      'description': description,
      'rules': rules,
      'prize_amount': prizeAmount,
      'category': category,
      'deadline': deadline.toIso8601String(),
      'start_date': DateTime.now().toIso8601String(),
      'status': 'pending_approval',
      'is_global': true,
    });
  }

  static Future<void> applyToChallenge(String challengeId) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _client.from('participations').insert({
      'challenge_id': challengeId,
      'user_id': user.id,
      'status': 'applied',
    });
  }

  static Future<void> approveParticipant(String participationId) async {
    await _client
        .from('participations')
        .update({'status': 'approved'})
        .eq('id', participationId);
  }

  static Future<void> markWinner(String participationId, double prize) async {
    await _client
        .from('participations')
        .update({'status': 'won', 'prize_earned': prize})
        .eq('id', participationId);

    await _client.from('payouts').insert({
      'participation_id': participationId,
      'amount': prize,
      'status': 'pending',
    });
  }
}
