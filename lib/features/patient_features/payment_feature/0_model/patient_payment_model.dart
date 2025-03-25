class AppointmentInvoice {
  final String appointmentId;
  final String doctorName;
  final String patientName;
  final String consultationType; // e.g., "F2F Initial", "Online Follow-up"
  final double price;
  final DateTime appointmentDate;
  final String status; // unpaid, paid, settled, etc.
  final String? invoiceUrl; // from Xendit response for payment link
  final String? invoiceNumber; // new field for invoice number
  final DateTime? invoiceDate; // new field for invoice date

  AppointmentInvoice({
    required this.appointmentId,
    required this.doctorName,
    required this.patientName,
    required this.consultationType,
    required this.price,
    required this.appointmentDate,
    required this.status,
    this.invoiceUrl,
    this.invoiceNumber,
    this.invoiceDate,
  });

  // For saving to Firestore or other services
  Map<String, dynamic> toMap() => {
        'appointmentId': appointmentId,
        'doctorName': doctorName,
        'patientName': patientName,
        'consultationType': consultationType,
        'price': price,
        'appointmentDate': appointmentDate.toIso8601String(),
        'status': status,
        'invoiceUrl': invoiceUrl,
        'invoiceNumber': invoiceNumber,
        'invoiceDate': invoiceDate?.toIso8601String(),
      };

  factory AppointmentInvoice.fromMap(Map<String, dynamic> map) {
    return AppointmentInvoice(
      appointmentId: map['appointmentId'],
      doctorName: map['doctorName'],
      patientName: map['patientName'],
      consultationType: map['consultationType'],
      price: map['price'],
      appointmentDate: DateTime.parse(map['appointmentDate']),
      status: map['status'],
      invoiceUrl: map['invoiceUrl'],
      invoiceNumber: map['invoiceNumber'],
      invoiceDate: map['invoiceDate'] != null
          ? DateTime.parse(map['invoiceDate'])
          : null,
    );
  }
}
