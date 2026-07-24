import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/challenge_service.dart';

class CreateChallengeScreen extends StatefulWidget {
  const CreateChallengeScreen({super.key});

  @override
  State<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _rules = TextEditingController();
  final _prize = TextEditingController();
  final _category = TextEditingController();
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    await ChallengeService.createChallenge(
      title: _title.text,
      description: _desc.text,
      rules: _rules.text,
      prizeAmount: double.parse(_prize.text),
      category: _category.text,
      deadline: _deadline,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Challenge')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _desc, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3, validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _rules, decoration: const InputDecoration(labelText: 'Rules'), maxLines: 4, validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _category, decoration: const InputDecoration(labelText: 'Category')),
              TextFormField(controller: _prize, decoration: const InputDecoration(labelText: 'Prize Amount'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
              ListTile(
                title: const Text('Deadline'),
                subtitle: Text(DateFormat.yMd().add_jm().format(_deadline)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: _deadline,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (d != null) setState(() => _deadline = d);
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _submit, child: const Text('Publish Challenge')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
