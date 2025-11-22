import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lead.dart';
import '../services/db_service.dart';
import '../providers/db_providers.dart';

class LeadListNotifier extends StateNotifier<List<Lead>> {
  final DBService _db;
  LeadListNotifier(this._db) : super([]) {
    // load initial data
    loadLeads();
  }

  Future<void> loadLeads() async {
    final data = await _db.getLeads();
    state = data;
  }

  Future<void> addLead(Lead lead) async {
    await _db.addLead(lead);
    await loadLeads();
  }

  Future<void> updateLead(Lead lead) async {
    await _db.updateLead(lead);
    await loadLeads();
  }

  Future<void> deleteLead(int id) async {
    await _db.deleteLead(id);
    await loadLeads();
  }
}

final leadListProvider = StateNotifierProvider<LeadListNotifier, List<Lead>>((ref) {
  final db = ref.read(dbServiceProvider);
  return LeadListNotifier(db);
});
