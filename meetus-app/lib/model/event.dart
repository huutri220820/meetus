class EventModel {
  final id;
  final place;
  final userId;
  final displayName;
  final imageMain;

  EventModel(
    this.id,
    this.place,
    this.userId,
    this.imageMain,
    this.displayName,
  );
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      json["_id"],
      json['place'],
      json['imageMain'],
      json['userId'],
      json['displayName'],
    );
  }
}
