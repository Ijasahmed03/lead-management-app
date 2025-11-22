import 'package:flutter/material.dart';
import '../models/lead.dart';

class LeadTile extends StatelessWidget {
  final Lead lead;
  final VoidCallback onTap;

  const LeadTile({Key? key, required this.lead, required this.onTap}) : super(key: key);

  Color _statusColor(String status) {
    switch (status) {
      case 'Converted':
        return Colors.green;
      case 'Contacted':
        return Colors.orange;
      case 'Lost':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(lead.name),
      subtitle: Text(lead.contact),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _statusColor(lead.status).withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          lead.status,
          style: TextStyle(
            color: _statusColor(lead.status),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
