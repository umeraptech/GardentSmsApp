class MonthlySpars {
  final int id;
  final String faculty;
  //final String month;
  final String batch;
  final String semester;
  final String studentid;
  final String name;
  final String held;
  final String attended;
  final String late;
  final String leave;
  final String internal;
  final String progress;
  final String assignment;
  final String studentno;
  final String parentno;

  MonthlySpars(
      {required this.id,
      required this.faculty,
      //required this.month,
      required this.batch,
      required this.semester,
      required this.progress,
      required this.studentid,
      required this.name,
      required this.held,
      required this.attended,
      required this.late,
      required this.leave,
      required this.internal,
      required this.assignment,
      required this.studentno,
      required this.parentno});

  factory MonthlySpars.fromJson(Map<String, dynamic> json) {
    return MonthlySpars(
      id: json['id'] as int,
      faculty: json['faculty'] as String,
      //month: json['month'] as String,
      batch: json['batch'] as String,
      semester: json['semester'] as String,
      progress: json['progress'] as String,
      studentid: json['studentid'] as String,
      name: json['name'] as String,
      held: json['held'] as String,
      attended: json['attended'] as String,
      late: json['late'] as String,
      leave: json['leave'] as String,
      internal: json['internal'] as String,
      assignment: json['assignment'] as String,
      studentno: json['studentno'] as String,
      parentno: json['parentno'] as String,
    );
  }
  // int getID() {
  //   return m_id;
  // }

  int getId() => id;
  String getFaculty() => faculty;
  //final String month;
  String getBatch() => batch;
  String getSemester() => semester;
  String getStudentId() => studentid;
  String getName() => name;
  String getHeld() => held;
  String getAttended() => attended;
  String getLate() => late;
  String getLeave() => leave;
  String getInternal() => internal;
  String getProgress() => progress;
  String getAssignment() => assignment;
  String getStudentNo() => studentno;
  String getParentNo() => parentno;
  @override
  String toString() {
    return 'Sno: $id, StudentID: $studentid, Name: $name, Batch: $batch, Progress: $progress Student Nos: $studentno Parent Nos: $parentno';
  }
}
