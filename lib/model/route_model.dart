class RouteModel {
  final List<RouteInfo> routeInfo;
  final String totalTime;
  final String totalDistance;
  final String provider;
  final String status;

  RouteModel({
    required this.routeInfo,
    required this.totalTime,
    required this.totalDistance,
    required this.provider,
    required this.status,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    var list = json['route_info'] as List;
    List<RouteInfo> routeInfoList = list.map((i) => RouteInfo.fromJson(i)).toList();

    return RouteModel(
      routeInfo: routeInfoList,
      totalTime: json['total_time'],
      totalDistance: json['total_distance'],
      provider: json['provider'],
      status: json['status'],
    );
  }
}

class RouteInfo {
  final String provider;
  final Destination destination;
  final double estimatedTravelTime;
  final String formattedTravelTime;
  final String distance;
  final Geometry geometry;

  RouteInfo({
    required this.provider,
    required this.destination,
    required this.estimatedTravelTime,
    required this.formattedTravelTime,
    required this.distance,
    required this.geometry,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    return RouteInfo(
      provider: json['provider'],
      destination: Destination.fromJson(json['destination']),
      estimatedTravelTime: json['estimated_travel_time'],
      formattedTravelTime: json['formatted_travel_time'],
      distance: json['distance'],
      geometry: Geometry.fromJson(json['geometry']),
    );
  }
}

class Destination {
  final double latitude;
  final double longitude;

  Destination({
    required this.latitude,
    required this.longitude,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class Geometry {
  final String type;
  final String coordinates;

  Geometry({
    required this.type,
    required this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'],
      coordinates: json['coordinates'],
    );
  }
}
