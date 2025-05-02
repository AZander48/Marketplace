class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final int productId;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? senderName;
  final String? receiverName;
  final String? productTitle;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.productId,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.senderName,
    this.receiverName,
    this.productTitle,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int? ?? 0,
      senderId: json['sender_id'] as int? ?? 0,
      receiverId: json['receiver_id'] as int? ?? 0,
      productId: json['product_id'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
      senderName: json['sender_name'] as String?,
      receiverName: json['receiver_name'] as String?,
      productTitle: json['product_title'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'product_id': productId,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
} 