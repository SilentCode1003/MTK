class UserInfoModel {
  final String employeeid;
  final String fullname;
  final String accesstype;
  final String image;
  final int department;
  final String departmentname;
  final String position;
  final String jobstatus;

  UserInfoModel(this.image, this.employeeid, this.fullname, this.accesstype,
      this.department, this.departmentname, this.position, this.jobstatus);

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      json['employeeid'],
      json['fullname'],
      json['accesstype'],
      json['image'],
      json['department'],
      json['deparmentname'],
      json['position'],
      json['jobstatus'],
    );
  }
}

//ATTENDANCEMODEL

class AttendanceModel {
  final String employeeid;
  final String attendancedateIn;
  final String attendancedateOut;
  final String clockin;
  final String clockout;
  final String devicein;
  final String deviceout;
  final String totalhours;

  AttendanceModel(
    this.employeeid,
    this.attendancedateIn,
    this.attendancedateOut,
    this.clockin,
    this.clockout,
    this.devicein,
    this.deviceout,
    this.totalhours,
  );

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      json['employeeid'],
      json['attendancedateIn'],
      json['attendancedateOut'],
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
  final String attendanceid;
  final String logtimein;
  final String logtimeout;
  final String logdatein;
  final String logdateout;



  TodayModel(this.employeeid, this.attendanceid, this.logtimein, this.logtimeout, this.logdatein, this.logdateout,);

  factory TodayModel.fromJson(Map<String, dynamic> json) {
    return TodayModel(

      json['employeeid'],
      json['attendanceid'],
      json['logtimein'],
      json['logtimeout'],
      json['logdatein'],
      json['logdateout'],
  
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

class Basicinfo {
  final String employeeid;
  final String firstname;
  final String lastname;
  final String middlename;
  final String gender;
  final String civilstatus;
  final String address;
  final String birthday;
  final String phone;
  final String email;
  final String ercontactname;
  final String ercontactphone;

  Basicinfo(
    this.employeeid,
    this.firstname,
    this.lastname,
    this.middlename,
    this.gender,
    this.civilstatus,
    this.address,
    this.birthday,
    this.phone,
    this.email,
    this.ercontactname,
    this.ercontactphone,
    );

    factory Basicinfo.fromJson(Map<String, dynamic> json) {
      return Basicinfo(
        json['employeeid'],
        json['firstname'],
        json['lastname'],
        json['middlename'],
        json['gender'],
        json['civilstatus'],
        json['address'],
        json['birthday'],
        json['phone'],
        json['email'],
        json['ercontactname'],
        json['ercontactphone'],
      );
    }
}
class ProfileWorkinfo {
  final String employeeid;
  final String department;
  final String position;
  final String departmenthead;
  final String jobstatus;
  final String hiredate;
  final String tenure;

  ProfileWorkinfo(
    this.employeeid,
    this.department,
    this.position,
    this.departmenthead,
    this.jobstatus,
    this.hiredate,
    this.tenure,
    );

    factory ProfileWorkinfo.fromJson(Map<String, dynamic> json) {
      return ProfileWorkinfo(
        json['employeeid'],
        json['department'],
        json['position'],
        json['departmenthead'],
        json['jobstatus'],
        json['hiredate'],
        json['tenure'],
      );
    }
}
class ProfileGovinfo {
  final String employeeid;
  final String idtype;
  final String idnumber;


  ProfileGovinfo(
    this.employeeid,
    this.idtype,
    this.idnumber,
    );

    factory ProfileGovinfo.fromJson(Map<String, dynamic> json) {
      return ProfileGovinfo(
        json['employeeid'],
        json['idtype'],
        json['idnumber'],
      );
    }
}
class OffensesModel {
  final String employeeid;
  final String disciplinaryid;
  final String offenseid;
  final String actionid;
  final String violation;
  final String date;
  final String createby;


  OffensesModel(
    this.employeeid,
    this.disciplinaryid,
    this.offenseid,
    this.actionid,
    this.violation,
    this.date,
    this.createby,
    );

    factory OffensesModel.fromJson(Map<String, dynamic> json) {
      return OffensesModel(
        json['employeeid'],
        json['disciplinaryid'],
        json['offenseid'],
        json['actionid'],
        json['violation'],
        json['date'],
        json['createby'],
      );
    }
}

class AnnouncementModel {
  final String bulletinid;
  final String tittle;
  final String image;
  final String type;
  final String description;
  final String targetdate;
  final String createby;


  AnnouncementModel(
    this.bulletinid,
    this.tittle,
    this.image,
    this.type,
    this.description,
    this.targetdate,
    this.createby,
    );

    factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
      return AnnouncementModel(
        json['bulletinid'],
        json['tittle'],
        json['image'],
        json['type'],
        json['description'],
        json['targetdate'],
        json['createby'],
      );
    }
}

class AllModel {
  final String details;
  final String disciplinary;


  AllModel(
    this.details,
    this.disciplinary,

    );

    factory AllModel.fromJson(Map<String, dynamic> json) {
      return AllModel(
        json['details'],
        json['disciplinary'],
      );
    }
}
