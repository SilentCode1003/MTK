class UserInfoModel {
  final String employeeid;
  final String fullname;
  final String accesstype;
  final String image;

  UserInfoModel(this.image, this.employeeid, this.fullname, this.accesstype);

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      json['employeeid'],
      json['fullname'],
      json['accesstype'],
      json['image'],
    );
  }
}

class LeaveModel {
  final int leaveid;
  final String employeeid;
  final String leavestartdate;
  final String leaveenddate;
  final String leavetype;
  final String reason;
  final String status;
  final String applieddate;


  LeaveModel(this.leaveid, this.employeeid, this.leavestartdate, this.leaveenddate, this.leavetype, this.reason, this.status, this.applieddate,);

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

class CashModel {
  final int cashadvanceid;
  final String employeeid;
  final String requestdate;
  final String amount;
  final String purpose;
  final String status;
  final String approvaldate;


  CashModel(this.cashadvanceid, this.employeeid, this.requestdate, this.amount, this.purpose, this.status, this.approvaldate,);

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




