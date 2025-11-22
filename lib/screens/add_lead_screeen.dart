import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lead.dart';
import '../providers/lead_list_provider.dart';

class AddLeadScreen extends ConsumerStatefulWidget {
  const AddLeadScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends ConsumerState<AddLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _notes = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Lead')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Name required' : null,
              ),
              TextFormField(
                controller: _contact,
                decoration: InputDecoration(labelText: 'Contact (phone or email)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Contact required' : null,
              ),
              TextFormField(
                controller: _notes,
                decoration: InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final newLead = Lead(
                      name: _name.text.trim(),
                      contact: _contact.text.trim(),
                      notes: _notes.text.trim(),
                    );
                    await ref.read(leadListProvider.notifier).addLead(newLead);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
