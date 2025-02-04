class Thesis {
  final String id;
  final String title;
  final String status;
  final String studentId;
  final String student;
  final String date;
  final String credits;
  final String description;
  final String pdfUrl;

  Thesis(
      {required this.id,
      required this.title,
      required this.studentId,
      required this.student,
        required this.date,
        required this.status,
        required this.credits,
      required this.description,
      String? pdfUrl})
      // : pdfUrl = pdfUrl ?? '${student.replaceAll(' ', '')}.pdf';
      : pdfUrl = pdfUrl ?? '$studentId.pdf';

  factory Thesis.fromJson(Map<String, dynamic> json) {
    return Thesis(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      studentId: json['studentId'],
      student: json['student'],
      date: json['date'],
      credits: json['credits'],
      description: json['location'],
      pdfUrl: json['pdfUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'studentId': studentId,
      'student': student,
      'date': date,
      'status': status,
      'credits': credits,
      'description': description,
      'pdfUrl': pdfUrl,
    };
  }
}
