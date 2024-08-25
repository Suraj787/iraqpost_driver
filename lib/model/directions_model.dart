class DirectionsModel {
  List<RouteInfo>? routeInfo;
  String? totalTime;
  String? totalDistance;
  String? provider;
  String? status;

  DirectionsModel({
    this.routeInfo,
    this.totalTime,
    this.totalDistance,
    this.provider,
    this.status,
  });

  DirectionsModel.fromJson(Map<String, dynamic> json) {
    if (json['route_info'] != null) {
      routeInfo = <RouteInfo>[];
      json['route_info'].forEach((v) {
        routeInfo!.add(RouteInfo.fromJson(v));
      });
    }
    totalTime = json['total_time'];
    totalDistance = json['total_distance'];
    provider = json['provider'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (routeInfo != null) {
      data['route_info'] = routeInfo!.map((v) => v.toJson()).toList();
    }
    data['total_time'] = totalTime;
    data['total_distance'] = totalDistance;
    data['provider'] = provider;
    data['status'] = status;
    return data;
  }
}

class RouteInfo {
  String? provider;
  Destination? destination;
  double? estimatedTravelTime;
  String? formattedTravelTime;
  String? distance;
  Geometry? geometry;
  List<Steps>? steps;

  RouteInfo(
      {this.provider,
      this.destination,
      this.estimatedTravelTime,
      this.formattedTravelTime,
      this.distance,
      this.geometry,
      this.steps});

  RouteInfo.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    destination = json['destination'] != null
        ? Destination.fromJson(json['destination'])
        : null;
    estimatedTravelTime = json['estimated_travel_time'];
    formattedTravelTime = json['formatted_travel_time'];
    distance = json['distance'];
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(Steps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provider'] = provider;
    if (destination != null) {
      data['destination'] = destination!.toJson();
    }
    data['estimated_travel_time'] = estimatedTravelTime;
    data['formatted_travel_time'] = formattedTravelTime;
    data['distance'] = distance;
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    if (steps != null) {
      data['steps'] = steps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Destination {
  double? latitude;
  double? longitude;

  Destination({this.latitude, this.longitude});

  Destination.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Geometry {
  String? type;
  String? coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class Steps {
  String? distance;
  String? remainingDistance;
  String? duration;
  String? remainingTime;
  String? instruction;

  Steps(
      {this.distance,
      this.remainingDistance,
      this.duration,
      this.remainingTime,
      this.instruction});

  Steps.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    remainingDistance = json['remaining_distance'];
    duration = json['duration'];
    remainingTime = json['remaining_time'];
    instruction = json['instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['remaining_distance'] = remainingDistance;
    data['duration'] = duration;
    data['remaining_time'] = remainingTime;
    data['instruction'] = instruction;
    return data;
  }
}
