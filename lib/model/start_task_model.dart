// To parse this JSON data, do
//
//     final startTaskModel = startTaskModelFromJson(jsonString);

import 'dart:convert';

StartTaskModel startTaskModelFromJson(String str) => StartTaskModel.fromJson(json.decode(str));

String startTaskModelToJson(StartTaskModel data) => json.encode(data.toJson());

class StartTaskModel {
  String? serverMessages;

  StartTaskModel({
    this.serverMessages,
  });

  factory StartTaskModel.fromJson(Map<String, dynamic> json) => StartTaskModel(
    serverMessages: json["_server_messages"],
  );

  Map<String, dynamic> toJson() => {
    "_server_messages": serverMessages,
  };
}
