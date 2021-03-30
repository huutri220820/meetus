class UserModel {
  // final uid;
  // final background;
  // final eventsHost;
  // final eventsJoin;
  // final eventsSkip;
  // final birthDate;
  // final job;
  // final range;
  // final gender;
  // final bio;
  final displayName;
  // final email;
  final photoURL;

  UserModel(
    // this.uid,
    // this.background,
    // this.bio,
    // this.birthDate,
    // this.gender,
    // this.job,
    // this.range,
    this.displayName,
    // this.email,
    this.photoURL,
  );
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // json["uid"],
      // json['background'],
      // json['bio'],
      // json['birthDate'],
      // json["gender"],
      // json['job'],
      // json['range'],
      json['displayName'],
      // json['email'],
      json['photoURL'],
    );
  }
}
