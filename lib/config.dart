class Config {
  //static const String apiUrl = 'https://payroll.5lsolutions.com/';
  static const String apiUrl = 'http://192.168.40.23:3005/';

  static const String loginAPI = 'login/login';
  static const String payslipAPI = 'eportalpayslip/viewpayslip';
  static const String leaveAPI = 'eportalrequestleave/getleave';
  static const String requestleaveAPI = 'eportalrequestleave/submit';
  static const String updateleaveAPI = 'eportalrequestleave/cancelLeave';
  static const String requestashAPI = 'eportalcashadvance/submitforapp';
  static const String updatecashAPI = 'eportalcashadvance/cancelcashadvanced';
  static const String cashAPI = 'eportalcashadvance/getload';
  static const String geofenceAPI = 'geofencesettings/selectgeofence';
  static const String notificationAPI = 'announcement/getannouncement';
  static const String attendanceAPi = 'attendance/getloadforapp';
  static const String filterattendanceAPI = 'attendance/filterforapp';
  static const String clockinAPI = 'eportalindex/clockin';
  static const String clockoutAPI = 'eportalindex/clockout';
  static const String getlateslogAPI = 'eportalindex/latestlog';
  static const String allAPI = 'announcement/getnotif';
  static const String todaystatusAPI = 'attendance/gethomestatus2';
  static const String basicinfoAPI = 'employee/getemployee';
  static const String workinfoAPI = 'employee/getemployeeprofileforappbasicinformation';
  static const String govinfoAPI = 'employee/getgovid';
  static const String trainingAPI = 'employee/gettrainingforapp';
  static const String offensesAPI = 'eportaldisciplinaryaction/loadforapp';
  static const String announcementAPI = 'announcement/loadforapp';
  static const String postannouncementAPI = 'announcement/save';
  static const String changepassAPI = 'eportalsettings/updatepassword';
  static const String shiftAPI = 'shift/loadshiftforapp';
  static const String appversionAPI = 'appsdetails/loadforapp';
  static const String otAPI = 'otapproval/forapp';
  static const String payrolldateAPI = 'generatepayroll/getpayrolldate';
  static const String payslipdetailsAPI = 'generatepayroll/LoadPayslipSummaryForApp';
}

