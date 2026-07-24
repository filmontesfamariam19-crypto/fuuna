import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/challenge_model.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final challengesProvider = FutureProvider<List<Challenge>>((ref) async {
  final query = ref.watch(searchQueryProvider).toLowerCase();

  final res = await Supabase.instance.client
      .from('challenges')
      .select()
      .eq('status', 'open')
      .order('created_at', ascending: false);

  final all = (res as List).map((e) => Challenge.fromMap(e)).toList();

  if (query.isEmpty) return all;
  return all.where((c) =>
      c.title.toLowerCase().contains(query) ||
      c.category.toLowerCase().contains(query)).toList();
});
