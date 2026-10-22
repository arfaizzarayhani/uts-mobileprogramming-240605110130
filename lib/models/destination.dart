import 'package:flutter/material.dart';

class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.region,
    required this.category,
    required this.duration,
    required this.description,
    required this.bestTime,
    required this.travelNote,
    required this.imageUrl,
    required this.color,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String region;
  final String category;
  final String duration;
  final String description;
  final String bestTime;
  final String travelNote;
  final String imageUrl;
  final Color color;
  final double latitude;
  final double longitude;
}
