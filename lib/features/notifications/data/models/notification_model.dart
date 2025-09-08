import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final String type;
  final String? orderId;
  final String? restaurantId;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.type,
    this.orderId,
    this.restaurantId,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      imageUrl: entity.imageUrl,
      type: entity.type.name,
      orderId: entity.orderId,
      restaurantId: entity.restaurantId,
      data: entity.data,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      imageUrl: imageUrl,
      type: NotificationType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => NotificationType.general,
      ),
      orderId: orderId,
      restaurantId: restaurantId,
      data: data,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}
