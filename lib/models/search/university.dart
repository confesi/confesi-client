class University {
  final String universityName;
  final String universityCode;

  University(this.universityName, this.universityCode);

  University.fromJson(Map<String, dynamic> json)
      : universityName = json["name"],
        universityCode = json["school_code"];
}
