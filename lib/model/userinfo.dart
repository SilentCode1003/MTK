class UserInfoModel {
  final String employeeid;
  final String fullname;
  final String accesstype;
  final String image;
  final int departmentid;
  final String departmentname;
  final String position;
  final String jobstatus;

  UserInfoModel(this.image, this.employeeid, this.fullname, this.accesstype,
      this.departmentid, this.departmentname, this.position, this.jobstatus);

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      json['employeeid'],
      json['fullname'],
      json['accesstype'],
      json['image'],
      json['departmentid'],
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
  final String geofencenameIn;
  final String geofencenameOut;
  final String clockin;
  final String clockout;
  final String geofencename;
  final String devicein;
  final String deviceout;
  final String totalhours;

  AttendanceModel(
    this.employeeid,
    this.attendancedateIn,
    this.attendancedateOut,
    this.geofencenameIn,
    this.geofencenameOut,
    this.clockin,
    this.clockout,
    this.geofencename,
    this.devicein,
    this.deviceout,
    this.totalhours,
  );

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      json['employeeid'],
      json['attendancedateIn'],
      json['attendancedateOut'],
      json['geofencenameIn'],
      json['geofencenameOut'] ?? '',
      json['clockin'],
      json['clockout'] ?? '',
      json['geofencename'] ?? '',
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

  NotificationModel(
    this.cashadvanceid,
    this.employeeid,
    this.requestdate,
    this.amount,
    this.purpose,
    this.status,
    this.approvaldate,
  );

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

  TodayModel(
    this.employeeid,
    this.attendanceid,
    this.logtimein,
    this.logtimeout,
    this.logdatein,
    this.logdateout,
  );

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
  final String departmentid;
  final String position;
  final String departmenthead;
  final String jobstatus;
  final String hiredate;
  final String tenure;

  ProfileWorkinfo(
    this.employeeid,
    this.departmentid,
    this.position,
    this.departmenthead,
    this.jobstatus,
    this.hiredate,
    this.tenure,
  );

  factory ProfileWorkinfo.fromJson(Map<String, dynamic> json) {
    return ProfileWorkinfo(
      json['employeeid'],
      json['departmentid'],
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

class ProfileTraininginfo {
  final String employeeid;
  final String trainingid;
  final String name;
  final String startdate;
  final String enddate;
  final String location;

  ProfileTraininginfo(
    this.employeeid,
    this.trainingid,
    this.name,
    this.startdate,
    this.enddate,
    this.location,
  );

factory ProfileTraininginfo.fromJson(Map<String, dynamic> json) {
  return ProfileTraininginfo(
    json['employeeid'],
    json['trainingid'],
    json['name'],
    json['startdate'],
    json['enddate'],
    json['location'],
  );
}
}

class Profileshiftinfo{
  final String employeeid;
  final String shiftid;
  final String department;
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;

  Profileshiftinfo(
    this.employeeid,
    this.shiftid,
    this.department,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  );

factory Profileshiftinfo.fromJson(Map<String, dynamic> json) {
  return Profileshiftinfo(
    json['employeeid'],
    json['shiftid'],
    json['department'],
    json['monday'],
    json['tuesday'],
    json['wednesday'],
    json['thursday'],
    json['friday'],
    json['saturday'],
    json['sunday'],
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
  final String tittle;
  final String content;
  final String date;
  final String image;
  final String type;
  

  AllModel(
    this.tittle,
    this.content,
    this.date,
    this.image,
    this.type,
  );

  factory AllModel.fromJson(Map<String, dynamic> json) {
    return AllModel(
      json['tittle'],
      json['content'],
      json['date'],
      json['image'],
      json['type'],
    );
  }
}

class VersionModel {
  final String appid;
  final String appname;
  final String appversion;
  final String appdate;
  final String createdby;
  

  VersionModel(
    this.appid,
    this.appname,
    this.appversion,
    this.appdate,
    this.createdby,
  );

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      json['appid'],
      json['appname'],
      json['appversions'],
      json['appdate'],
      json['createdby'],
    );
  }
}

class OvertimeModel {
  final String approveot_id;
  final String employeeid;
  final String attendancedate;
  final String clockin;
  final String clockout;
  final String totalhours;
  final String payrolldate;
  final String overtimestatus;
  

  OvertimeModel(
    this.approveot_id,
    this.employeeid,
    this.attendancedate,
    this.clockin,
    this.clockout,
    this.totalhours,
    this.payrolldate,
    this.overtimestatus,
  );

  factory OvertimeModel.fromJson(Map<String, dynamic> json) {
    return OvertimeModel(
      json['approveot_id'],
      json['employeeid'],
      json['attendancedate'],
      json['clockin'],
      json['clockout'],
      json['totalhours'],
      json['payrolldate'],
      json['overtimestatus'],
    );
  }
}

class PayrolldateModel {
  final String gp_payrolldate;
  final String gp_cutoff;

  PayrolldateModel(
    this.gp_payrolldate,
    this.gp_cutoff,
  );
  
  factory PayrolldateModel.fromJson(Map<String, dynamic> json){
    return PayrolldateModel(
      json['gp_payrolldate'],
      json['gp_cutoff'],
    );
  }
}

class PayslipModel {
  final dynamic EmployeeFullName;
  final dynamic PositionName;
  final dynamic Department;
  final dynamic EmployeeId;
  final dynamic Salary;
  final dynamic Allowances;
  final dynamic PayrollDate;
  final dynamic StartDate;
  final dynamic Enddate;
  final dynamic Total_Hours;
  final dynamic Total_Minutes;
  final dynamic NightDiff;
  final dynamic NormalOt;
  final dynamic EarlyOt;
  final dynamic Late_Minutes;
  final dynamic Late_Hours;
  final dynamic HolidayOvertime;
  final dynamic Regular_Hours;
  final dynamic Per_Day;
  final dynamic Work_Days;
  final dynamic Rest_Day;
  final dynamic Total_gp_status;
  final dynamic Absent;
  final dynamic NDpay;
  final dynamic OTpay;
  final dynamic EarlyOtpay;
  final dynamic Compensation;
  final dynamic ApprovedOt;
  final dynamic Regular_Holiday_Compensation;
  final dynamic Special_Holiday_Compensation;
  final dynamic RegularHolidayOT;
  final dynamic SpecialHolidayOT;
  final dynamic Absent_Deductions;
  final dynamic Overall_Net_Pay;
  final dynamic Late_Deductions;
  final dynamic SSS;
  final dynamic PagIbig;
  final dynamic PhilHealth;
  final dynamic TIN;
  final dynamic Health_Card;
  final dynamic Total_AllDeductions;
  final dynamic Total_Netpay;

  PayslipModel(
    this.EmployeeFullName,
    this.PositionName,
    this.Department,
    this.EmployeeId,
    this.Salary,
    this.Allowances,
    this.PayrollDate,
    this.StartDate,
    this.Enddate,
    this.Total_Hours,
    this.Total_Minutes,
    this.NightDiff,
    this.NormalOt,
    this.EarlyOt,
    this.Late_Minutes,
    this.Late_Hours,
    this.HolidayOvertime,
    this.Regular_Hours,
    this.Per_Day,
    this.Work_Days,
    this.Rest_Day,
    this.Total_gp_status,
    this.Absent,
    this.NDpay,
    this.OTpay,
    this.EarlyOtpay,
    this.Compensation,
    this.ApprovedOt,
    this.Regular_Holiday_Compensation,
    this.Special_Holiday_Compensation,
    this.RegularHolidayOT,
    this.SpecialHolidayOT,
    this.Absent_Deductions,
    this.Overall_Net_Pay,
    this.Late_Deductions,
    this.SSS,
    this.PagIbig,
    this.PhilHealth,
    this.TIN,
    this.Health_Card,
    this.Total_AllDeductions,
    this.Total_Netpay,
  );
  
  factory PayslipModel.fromJson(Map<String, dynamic> json){
    return PayslipModel(
      json['EmployeeFullName'],
      json['PositionName'],
      json['Department'],
      json['EmployeeId'],
      json['Salary'],
      json['Allowances'],
      json['PayrollDate'],
      json['StartDate'],
      json['Enddate'],
      json['Total_Hours'],
      json['Total_Minutes'],
      json['NightDiff'],
      json['NormalOt'],
      json['EarlyOt'],
      json['Late_Minutes'],
      json['Late_Hours'],
      json['HolidayOvertime'],
      json['Regular_Hours'],
      json['Per_Day'],
      json['Work_Days'],
      json['Rest_Day'],
      json['Total_gp_status'],
      json['Absent'],
      json['NDpay'],
      json['OTpay'],
      json['EarlyOtpay'],
      json['Compensation'],
      json['ApprovedOt'],
      json['Regular_Holiday_Compensation'],
      json['Special_Holiday_Compensation'],
      json['RegularHolidayOT'],
      json['SpecialHolidayOT'],
      json['Absent_Deductions'],
      json['Overall_Net_Pay'],
      json['Late_Deductions'],
      json['SSS'],
      json['PagIbig'],
      json['PhilHealth'],
      json['TIN'],
      json['Health_Card'],
      json['Total_AllDeductions'],
      json['Total_Netpay'],
      
    );
  }
}

