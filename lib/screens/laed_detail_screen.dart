import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lead.dart';
import '../providers/lead_list_provider.dart';

class LeadDetailScreen extends ConsumerStatefulWidget {
  final Lead lead;
  const LeadDetailScreen({Key? key, required this.lead}) : super(key: key);

  @override
  ConsumerState<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends ConsumerState<LeadDetailScreen> {
  late TextEditingController _name;
  late TextEditingController _contact;
  late TextEditingController _notes;
  late String _status;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.lead.name);
    _contact = TextEditingController(text: widget.lead.contact);
    _notes = TextEditingController(text: widget.lead.notes);
    _status = widget.lead.status;
  }

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(leadListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lead Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Delete lead?'),
                  content: Text('This action cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
                  ],
                ),
              );
              if (confirmed == true) {
                await notifier.deleteLead(widget.lead.id!);
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _name, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: _contact, decoration: InputDecoration(labelText: 'Contact')),
            TextField(controller: _notes, decoration: InputDecoration(labelText: 'Notes'), maxLines: 3),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _status,
              items: ['New', 'Contacted', 'Converted', 'Lost']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _status = v ?? 'New'),
              decoration: InputDecoration(labelText: 'Status'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Update'),
              onPressed: () async {
                final updated = Lead(
                  id: widget.lead.id,
                  name: _name.text.trim(),
                  contact: _contact.text.trim(),
                  notes: _notes.text.trim(),
                  status: _status,
                );
                await notifier.updateLead(updated);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
