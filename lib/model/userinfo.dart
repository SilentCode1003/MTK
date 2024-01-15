class UserInfoModel {
  final String employeeid;
  final String fullname;
  final String accesstype;
  final String image;
  final int department;

  UserInfoModel(this.image, this.employeeid, this.fullname, this.accesstype,
      this.department);

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      json['employeeid'],
      json['fullname'],
      json['accesstype'],
      json['image'],
      json['department'],
    );
  }
}

//ATTENDANCEMODEL

class AttendanceModel {
  final String employeeid;
  final String attendancedate;
  final String clockin;
  final String clockout;
  final String devicein;
  final String deviceout;
  final String totalhours;

  AttendanceModel(
    this.employeeid,
    this.attendancedate,
    this.clockin,
    this.clockout,
    this.devicein,
    this.deviceout,
    this.totalhours,
  );

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      json['employeeid'],
      json['attendancedate'],
      json['clockin'],
      json['clockout'] ?? '',
      json['devicein'],
      json['deviceout'] ?? '',
      json['totalhours'] ?? '',
    );
  }
}

//LEVEMODEL

class LeaveModel {
  final int leaveid;
  final String employeeid;
  final String leavestartdate;
  final String leaveenddate;
  final String leavetype;
  final String reason;
  final String status;
  final String applieddate;

  LeaveModel(
    this.leaveid,
    this.employeeid,
    this.leavestartdate,
    this.leaveenddate,
    this.leavetype,
    this.reason,
    this.status,
    this.applieddate,
  );

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      json['leaveid'],
      json['employeeid'],
      json['leavestartdate'],
      json['leaveenddate'],
      json['leavetype'],
      json['reason'],
      json['status'],
      json['applieddate'],
    );
  }
}

//CASHMODEL

class CashModel {
  final int cashadvanceid;
  final String employeeid;
  final String requestdate;
  final String amount;
  final String purpose;
  final String status;
  final String approvaldate;

  CashModel(
    this.cashadvanceid,
    this.employeeid,
    this.requestdate,
    this.amount,
    this.purpose,
    this.status,
    this.approvaldate,
  );

  factory CashModel.fromJson(Map<String, dynamic> json) {
    return CashModel(
      json['cashadvanceid'],
      json['employeeid'],
      json['requestdate'],
      json['amount'],
      json['purpose'],
      json['status'],
      json['approvaldate'],
    );
  }
}

//NOTIFICATIONMODEL

class NotificationModel {
  final int cashadvanceid;
  final String employeeid;
  final String requestdate;
  final String amount;
  final String purpose;
  final String status;
  final String approvaldate;


  NotificationModel(this.cashadvanceid, this.employeeid, this.requestdate, this.amount, this.purpose, this.status, this.approvaldate,);

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(

      json['cashadvanceid'],
      json['employeeid'],
      json['requestdate'],
      json['amount'],
      json['purpose'],
      json['status'],
      json['approvaldate'],
    );
  }
}

class TodayModel {
  final String employeeid;
  final String ma_clockin;
  final String ma_clockout;



  TodayModel(this.employeeid, this.ma_clockin, this.ma_clockout,);

  factory TodayModel.fromJson(Map<String, dynamic> json) {
    return TodayModel(

      json['employeeid'],
      json['logtimein'],
      json['logtimeout'],
    );
  }
}

class GeofenceModel {
  final int geofenceid;
  final String geofencename;
  final int departmentid;
  final double latitude;
  final double longitude;
  final double radius;
  final String location;
  final String status;

  GeofenceModel(
    this.geofenceid,
    this.geofencename,
    this.departmentid,
    this.latitude,
    this.longitude,
    this.radius,
    this.location,
    this.status,
  );

  factory GeofenceModel.fromJson(Map<String, dynamic> json) {
    return GeofenceModel(
      json['geofenceid'],
      json['geofencename'],
      json['departmentid'],
      json['latitude'],
      json['longitude'],
      json['radius'],
      json['location'],
      json['status'],
    );
  }
}

class AttendanceLog {
  final int logid;
  final int attendanceid;
  final String employeeid;
  final String longdatetime;
  final String logtype;
  final double latitude;
  final double longitude;
  final String device;

  AttendanceLog(
    this.logid,
    this.attendanceid,
    this.employeeid,
    this.longdatetime,
    this.logtype,
    this.latitude,
    this.longitude,
    this.device,
  );

  factory AttendanceLog.fromJson(Map<String, dynamic> json) {
    return AttendanceLog(
      json['logid'],
      json['attendanceid'],
      json['employeeid'],
      json['longdatetime'],
      json['logtype'],
      json['latitude'],
      json['longitude'],
      json['device'],
    );
  }
}
