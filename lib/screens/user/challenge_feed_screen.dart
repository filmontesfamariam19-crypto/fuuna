import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/challenge_model.dart';
import '../../providers/challenges_provider.dart';
import '../../widgets/challenge_card.dart';
import 'challenge_detail_screen.dart';

class ChallengeFeedScreen extends ConsumerWidget {
  const ChallengeFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengesAsync = ref.watch(challengesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Discover Challenges')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search challenges...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
            ),
          ),
          Expanded(
            child: challengesAsync.when(
              data: (list) => list.isEmpty
                  ? const Center(child: Text('No challenges found'))
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, i) => ChallengeCard(
                        challenge: list[i],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChallengeDetailScreen(challenge: list[i]),
                          ),
                        ),
                      ),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
