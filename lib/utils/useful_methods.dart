import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer/shimmer.dart';

double calculateAngle(LatLng from, LatLng to) {
  final dx = to.longitude - from.longitude;
  final dy = to.latitude - from.latitude;
  final angle = atan2(dy, dx);
  return angle * (180 / pi); // Convert radians to degrees
}

String getStopTime(double? totalDriveTime) {
  DateTime now = DateTime.now();

  Duration duration = Duration(minutes: totalDriveTime!.toInt());
  DateTime arrivalTime = now.add(duration);

  String formattedArrivalTime = DateFormat.jm().format(arrivalTime);

  return formattedArrivalTime;
}

LatLng findClosestPointOnRoute(LatLng userLocation, List<LatLng> polyline) {
  double closestDistance = double.infinity;
  LatLng closestPoint = polyline[0];

  for (int i = 0; i < polyline.length - 1; i++) {
    LatLng start = polyline[i];
    LatLng end = polyline[i + 1];

    LatLng projectedPoint = _projectPointOnSegment(userLocation, start, end);
    double distance = _calculateDistance(userLocation, projectedPoint);

    if (distance < closestDistance) {
      closestDistance = distance;
      closestPoint = projectedPoint;
    }
  }

  return closestPoint;
}

LatLng _projectPointOnSegment(LatLng point, LatLng start, LatLng end) {
  double dx = end.longitude - start.longitude;
  double dy = end.latitude - start.latitude;

  if (dx == 0.0 && dy == 0.0) {
    return start;
  }

  double t = ((point.longitude - start.longitude) * dx +
          (point.latitude - start.latitude) * dy) /
      (dx * dx + dy * dy);

  t = t.clamp(0.0, 1.0);

  return LatLng(start.latitude + t * dy, start.longitude + t * dx);
}

double _calculateDistance(LatLng point1, LatLng point2) {
  const Distance distance = Distance();
  return distance(
    LatLng(point1.latitude, point1.longitude),
    LatLng(point2.latitude, point2.longitude),
  );
}

List<LatLng> trimPolylineFromPoint(List<LatLng> polyline, LatLng point) {
  // Initialize closestPoint with the first point in the polyline
  LatLng closestPoint = polyline[0];
  int closestSegmentIndex = -1;
  double closestDistance = double.infinity;

  for (int i = 0; i < polyline.length - 1; i++) {
    LatLng start = polyline[i];
    LatLng end = polyline[i + 1];

    // Calculate the distance from the point to the segment
    double distance = distanceToSegment(point, start, end);

    if (distance < closestDistance) {
      closestDistance = distance;
      closestSegmentIndex = i;

      // Project the user's position onto the closest segment
      closestPoint = _projectPointOnSegment(point, start, end);
    }
  }

  // If no closest segment is found, return the original polyline (this shouldn't happen)
  if (closestSegmentIndex == -1) {
    return polyline;
  }

  // Create a new polyline from the closest point onwards
  List<LatLng> trimmedPolyline = [closestPoint];
  trimmedPolyline.addAll(polyline.sublist(closestSegmentIndex + 1));

  return trimmedPolyline;
}

// Function to calculate distance from a point to a line segment
double distanceToSegment(LatLng point, LatLng start, LatLng end) {
  // Calculate the vectors
  double dx = end.longitude - start.longitude;
  double dy = end.latitude - start.latitude;

  // Calculate the projection of the point on the segment
  double t = ((point.longitude - start.longitude) * dx +
          (point.latitude - start.latitude) * dy) /
      (dx * dx + dy * dy);

  // Clamp t to the range [0, 1]
  t = t.clamp(0.0, 1.0);

  // Calculate the closest point on the segment
  double closestLon = start.longitude + t * dx;
  double closestLat = start.latitude + t * dy;

  // Calculate the distance from the point to the closest point on the segment
  return const Distance().as(
    LengthUnit.Meter,
    LatLng(closestLat, closestLon),
    point,
  );
}

class ReusableMethods {
  List<List<double>> decompressGeometry(String str) {
    int xDiffPrev = 0;
    int yDiffPrev = 0;
    List<List<double>> points = [];
    int x, y;
    List<String> strings;
    int coefficient;

    // Split the string into an array on the + and - characters
    strings = RegExp(r'((\+|\-)[^\+\-]+)')
        .allMatches(str)
        .map((m) => m.group(0)!)
        .toList();

    // The first value is the coefficient in base 32
    coefficient = int.parse(strings[0], radix: 32);

    for (int j = 1; j < strings.length; j += 2) {
      // j is the offset for the x value
      // Convert the value from base 32 and add the previous x value
      x = int.parse(strings[j], radix: 32) + xDiffPrev;
      xDiffPrev = x;

      // j+1 is the offset for the y value
      // Convert the value from base 32 and add the previous y value
      y = int.parse(strings[j + 1], radix: 32) + yDiffPrev;
      yDiffPrev = y;

      points.add([x / coefficient, y / coefficient]);
    }

    return points;
  }
}

List<LatLng> decodePolyline(String polyline) {
  List<LatLng> points = [];
  int index = 0, len = polyline.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = polyline.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = polyline.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    points.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
  }

  return points;
}

Widget buildSkeletonLoader() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            height: 7,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 20,
          width: 150,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              height: 50,
              width: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(width: 8),
            Container(
              height: 50,
              width: 100,
              color: Colors.grey[300],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 200,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              height: 50,
              width: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(width: 8),
            Container(
              height: 50,
              width: 100,
              color: Colors.grey[300],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 20,
          width: 150,
          color: Colors.grey[300],
        ),
      ],
    ),
  );
}
