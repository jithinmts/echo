class PusherUser {
  String? id;
  String? jsonData;

  PusherUser({this.id, this.jsonData});

  PusherUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jsonData = json['jsonData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['jsonData'] = this.jsonData;
    return data;
  }
}