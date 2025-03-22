import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentInvoice {
  final String id;
  final String externalId;
  final String status;
  final String invoiceUrl;
  final int amount;

  PaymentInvoice({
    required this.id,
    required this.externalId,
    required this.status,
    required this.invoiceUrl,
    required this.amount,
  });

  // Convert Firestore document to PaymentInvoice object
  factory PaymentInvoice.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentInvoice.fromMap(data);
  }

  // Convert JSON/Map response to PaymentInvoice object
  factory PaymentInvoice.fromMap(Map<String, dynamic> json) {
    return PaymentInvoice(
      id: json['id'] ?? '',
      externalId: json['external_id'] ?? '',
      status: json['status'] ?? '',
      invoiceUrl: json['invoice_url'] ?? '',
      amount: json['amount'] ?? 0,
    );
  }

  // Convert PaymentInvoice object to Map (for Firestore storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'external_id': externalId,
      'status': status,
      'invoice_url': invoiceUrl,
      'amount': amount,
    };
  }

  // Convert PaymentInvoice object to Firestore format
  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance
        .collection('invoices')
        .doc(id)
        .set(toMap());
  }
}
