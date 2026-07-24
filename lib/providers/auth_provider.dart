import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider((ref) => Supabase.instance.client);

final authProvider = StreamProvider<User?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange
      .map((event) => event.session?.user);
});

final userRoleProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(authProvider).value;
  if (user == null) return null;

  final data = await Supabase.instance.client
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single();

  return data['role'] as String?;
});
