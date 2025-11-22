class Lead {
  int? id;
  String name;
  String contact;
  String notes;
  String status; //new,contacted,converted,lost

  Lead({
    this.id,
    required this.name,
    required this.contact,
    this.notes = '',
    this.status = 'New',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'notes': notes,
      'status': status,
    };
  }

  factory Lead.fromMap(Map<String, dynamic> m) {
    return Lead(
      id: m['id'] as int?,
      name: m['name'] as String,
      contact: m['contact'] as String,
      notes: m['notes'] as String? ?? '',
      status: m['status'] as String? ?? 'New',
    );
  }
}
