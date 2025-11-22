import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lead_list_provider.dart';
import '../widgets/lead_tile.dart';
import '../screens/add_lead_screeen.dart';
import '../screens/laed_detail_screen.dart';
import '../models/lead.dart';

class LeadListScreen extends ConsumerStatefulWidget {
  const LeadListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends ConsumerState<LeadListScreen> {
  String filter = 'All';
  final filters = ['All', 'New', 'Contacted', 'Converted', 'Lost'];

  @override
  Widget build(BuildContext context) {
    final leads = ref.watch(leadListProvider);

    // Apply filter
    final displayed =
        (filter == 'All')
            ? leads
            : leads.where((l) => l.status == filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Leads'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => setState(() => filter = v),
            itemBuilder:
                (_) =>
                    filters
                        .map((f) => PopupMenuItem(value: f, child: Text(f)))
                        .toList(),
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh:
            () async => await ref.read(leadListProvider.notifier).loadLeads(),
        child:
            displayed.isEmpty
                ? ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 120),
                    Center(child: Text('No leads yet. Tap + to add one.')),
                  ],
                )
                : ListView.builder(
                  itemCount: displayed.length,
                  itemBuilder: (context, i) {
                    final lead = displayed[i];
                    return LeadTile(
                      lead: lead,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LeadDetailScreen(lead: lead),
                            ),
                          ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddLeadScreen()),
          );
          // After returning, refresh list
          await ref.read(leadListProvider.notifier).loadLeads();
        },
      ),
    );
  }
}
