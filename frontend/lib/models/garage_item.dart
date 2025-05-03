import 'package:flutter/material.dart';

class GarageItem {
  final int id;
  final int userId;
  final String name;
  final String description;
  final String? imageUrl;
  final int? vehicleTypeId;
  final int? vehicleYear;
  final int? vehicleMakeId;
  final int? vehicleModelId;
  final int? vehicleSubmodelId;
  final bool isPrimary;
  final DateTime createdAt;

  GarageItem({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    this.imageUrl,
    this.vehicleTypeId,
    this.vehicleYear,
    this.vehicleMakeId,
    this.vehicleModelId,
    this.vehicleSubmodelId,
    this.isPrimary = false,
    required this.createdAt,
  });

  factory GarageItem.fromJson(Map<String, dynamic> json) {
    return GarageItem(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      vehicleTypeId: json['vehicle_type_id'],
      vehicleYear: json['vehicle_year'],
      vehicleMakeId: json['vehicle_make_id'],
      vehicleModelId: json['vehicle_model_id'],
      vehicleSubmodelId: json['vehicle_submodel_id'],
      isPrimary: json['is_primary'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'vehicle_type_id': vehicleTypeId,
      'vehicle_year': vehicleYear,
      'vehicle_make_id': vehicleMakeId,
      'vehicle_model_id': vehicleModelId,
      'vehicle_submodel_id': vehicleSubmodelId,
      'is_primary': isPrimary,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get vehicleDetails {
    final parts = <String>[];
    if (vehicleYear != null) parts.add(vehicleYear.toString());
    if (vehicleMakeId != null) parts.add('Make ID: $vehicleMakeId');
    if (vehicleModelId != null) parts.add('Model ID: $vehicleModelId');
    if (vehicleSubmodelId != null) parts.add('Submodel ID: $vehicleSubmodelId');
    return parts.join(' ');
  }
} 