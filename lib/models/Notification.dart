class NotificationList {
  NotificationList({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory NotificationList.fromJson(Map<String, dynamic> json) =>
      NotificationList(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );
}

class Datum {
  Datum({
    this.id,
    this.type,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String type;
  String notifiableType;
  String notifiableId;
  Data data;
  String readAt;
  String createdAt;
  String updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        type: json["type"],
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        data: Data.fromJson(json["data"]),
        readAt: json["read_at"] == null ? null : json["read_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}

class Data {
  Data({
    this.title,
    this.description,
  });

  String title;
  String description;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        title: json["title"],
        description: json["description"],
      );
}
