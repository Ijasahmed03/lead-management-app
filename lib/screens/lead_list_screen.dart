// lib/screens/lead_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lead_list_provider.dart';
import '../widgets/lead_tile.dart';
import '../screens/add_lead_screeen.dart';
import '../screens/laed_detail_screen.dart';
import '../models/lead.dart';
import '../providers/theme_provider.dart';

class LeadListScreen extends ConsumerStatefulWidget {
  const LeadListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends ConsumerState<LeadListScreen> with SingleTickerProviderStateMixin {
  String filter = 'All';
  final filters = ['All', 'New', 'Contacted', 'Converted', 'Lost'];
  String query = '';

  // small controller for a FAB animation feel (optional)
  late final AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200), lowerBound: 0.0, upperBound: 0.06);
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leads = ref.watch(leadListProvider);

    // Apply filter + search
    var displayed = (filter == 'All') ? leads : leads.where((l) => l.status == filter).toList();
    if (query.trim().isNotEmpty) {
      displayed = displayed.where((l) => l.name.toLowerCase().contains(query.toLowerCase())).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          // Theme toggle
          IconButton(
            tooltip: 'Toggle theme',
            icon: ref.watch(isDarkModeProvider) ? const Icon(Icons.dark_mode) : const Icon(Icons.light_mode),
            onPressed: () => ref.read(isDarkModeProvider.notifier).state = !ref.read(isDarkModeProvider),
          ),

          // Filter
          PopupMenuButton<String>(
            onSelected: (v) => setState(() => filter = v),
            itemBuilder: (_) => filters.map((f) => PopupMenuItem(value: f, child: Text(f))).toList(),
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => query = ''),
                )
                    : null,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),

          // List area
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await ref.read(leadListProvider.notifier).loadLeads(),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: displayed.isEmpty
                    ? ListView(
                  key: const ValueKey('empty'),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Center(child: Text('No leads found', style: Theme.of(context).textTheme.bodyLarge)),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        filter == 'All'
                            ? 'Tap + to add a new lead.'
                            : 'Try changing filters.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),

                  ],
                )
                    : ListView.builder(
                  key: const ValueKey('list'),
                  itemCount: displayed.length,
                  itemBuilder: (context, i) {
                    final lead = displayed[i];
                    return LeadTile(
                      lead: lead,
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => LeadDetailScreen(lead: lead)));
                        await ref.read(leadListProvider.notifier).loadLeads();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTapDown: (_) => _fabController.forward(),
        onTapUp: (_) => _fabController.reverse(),
        onTapCancel: () => _fabController.reverse(),
        child: ScaleTransition(
          scale: Tween(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _fabController, curve: Curves.easeOut)),
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddLeadScreen()));
              await ref.read(leadListProvider.notifier).loadLeads();
            },
          ),
        ),
      ),
    );
  }
}
