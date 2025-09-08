import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/payment_model.dart';
import '../../domain/entities/payment_entity.dart' as payment_entity;

abstract class StripePaymentDataSource {
  Future<PaymentModel> createPaymentIntent({
    required String orderId,
    required String userId,
    required double amount,
    required String currency,
    required payment_entity.PaymentMethod method,
  });
  
  Future<PaymentModel> confirmPayment({
    required String paymentIntentId,
    required String clientSecret,
  });
  
  Future<PaymentModel> cancelPayment(String paymentIntentId);
  
  Future<PaymentModel> refundPayment({
    required String paymentIntentId,
    double? amount,
  });
  
  Future<PaymentModel> getPayment(String paymentId);
  
  Future<List<PaymentModel>> getUserPayments(String userId);
}

class StripePaymentDataSourceImpl implements StripePaymentDataSource {
  final Dio dio;
  final String baseUrl;

  StripePaymentDataSourceImpl({
    required this.dio,
    required this.baseUrl,
  });

  @override
  Future<PaymentModel> createPaymentIntent({
    required String orderId,
    required String userId,
    required double amount,
    required String currency,
    required payment_entity.PaymentMethod method,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/payments/create-intent',
        data: {
          'orderId': orderId,
          'userId': userId,
          'amount': (amount * 100).round(), // Convert to cents
          'currency': currency,
          'method': method.name,
        },
      );

      if (response.statusCode == 200) {
        return PaymentModel.fromJson(response.data);
      } else {
        throw const ServerException(message: 'Failed to create payment intent');
      }
    } on DioException catch (e) {
      throw ServerException(message: 'Network error: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<PaymentModel> confirmPayment({
    required String paymentIntentId,
    required String clientSecret,
  }) async {
    try {
      // Confirm payment with Stripe
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(),
          ),
        ),
      );

      // Get updated payment status from server
      final response = await dio.get('$baseUrl/payments/$paymentIntentId');
      
      if (response.statusCode == 200) {
        return PaymentModel.fromJson(response.data);
      } else {
        throw const ServerException(message: 'Failed to confirm payment');
      }
    } on StripeException catch (e) {
      throw PaymentException(message: 'Stripe error: ${e.error.message}');
    } on DioException catch (e) {
      throw ServerException(message: 'Network error: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<PaymentModel> cancelPayment(String paymentIntentId) async {
    try {
      final response = await dio.post(
        '$baseUrl/payments/$paymentIntentId/cancel',
      );

      if (response.statusCode == 200) {
        return PaymentModel.fromJson(response.data);
      } else {
        throw const ServerException(message: 'Failed to cancel payment');
      }
    } on DioException catch (e) {
      throw ServerException(message: 'Network error: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<PaymentModel> refundPayment({
    required String paymentIntentId,
    double? amount,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/payments/$paymentIntentId/refund',
        data: {
          'amount': amount != null ? (amount * 100).round() : null,
        },
      );

      if (response.statusCode == 200) {
        return PaymentModel.fromJson(response.data);
      } else {
        throw const ServerException(message: 'Failed to refund payment');
      }
    } on DioException catch (e) {
      throw ServerException(message: 'Network error: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<PaymentModel> getPayment(String paymentId) async {
    try {
      final response = await dio.get('$baseUrl/payments/$paymentId');

      if (response.statusCode == 200) {
        return PaymentModel.fromJson(response.data);
      } else {
        throw const ServerException(message: 'Failed to get payment');
      }
    } on DioException catch (e) {
      throw ServerException(message: 'Network error: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<PaymentModel>> getUserPayments(String userId) async {
    try {
      final response = await dio.get('$baseUrl/payments/user/$userId');

      if (response.statusCode == 200) {
        final List<dynamic> paymentsJson = response.data;
        return paymentsJson.map((json) => PaymentModel.fromJson(json)).toList();
      } else {
        throw const ServerException(message: 'Failed to get user payments');
      }
    } on DioException catch (e) {
      throw ServerException(message: 'Network error: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}
