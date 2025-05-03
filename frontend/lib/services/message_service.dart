import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';
import 'api_service.dart';

class MessageService {
  final ApiService _apiService;
  static const Duration timeout = Duration(seconds: 30);
  final String _baseUrl = 'http://10.0.2.2:3000/api';

  MessageService(this._apiService);

  Future<List<Message>> getMessages(int productId) async {
    try {
      final headers = await _apiService.getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/messages/product/$productId'),
        headers: headers,
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> messagesList = json.decode(response.body);
        return messagesList.map((json) => Message.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading messages: $e');
    }
  }

  Future<Message> sendMessage(int productId, int receiverId, String message) async {
    try {
      final headers = await _apiService.getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/messages'),
        headers: headers,
        body: json.encode({
          'product_id': productId,
          'receiver_id': receiverId,
          'message': message,
        }),
      ).timeout(timeout);

      if (response.statusCode == 201) {
        return Message.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception('Failed to send message: ${error['error'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  Future<void> markAsRead(int messageId) async {
    try {
      final headers = await _apiService.getHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl/messages/$messageId/read'),
        headers: headers,
      ).timeout(timeout);

      if (response.statusCode != 200) {
        throw Exception('Failed to mark message as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error marking message as read: $e');
    }
  }
} 