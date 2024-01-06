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
