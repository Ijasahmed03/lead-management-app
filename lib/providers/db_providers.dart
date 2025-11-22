
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/db_service.dart';

final dbServiceProvider = Provider<DBService>((ref) {
  return DBService();
});
