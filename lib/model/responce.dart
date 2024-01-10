class ResponceModel {
  final String message;
  final int status;
  final List<dynamic> result;

  ResponceModel(this.message, this.status, this.result);

  factory ResponceModel.fromJson(Map<String, dynamic> json) {
    return ResponceModel(json['message'], json['status'], json['result']);
  }
}