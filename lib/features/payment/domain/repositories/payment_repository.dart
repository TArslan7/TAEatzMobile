import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<Either<Failure, PaymentEntity>> createPaymentIntent({
    required String orderId,
    required String userId,
    required double amount,
    required String currency,
    required PaymentMethod method,
  });
  
  Future<Either<Failure, PaymentEntity>> confirmPayment({
    required String paymentIntentId,
    required String clientSecret,
  });
  
  Future<Either<Failure, PaymentEntity>> cancelPayment(String paymentIntentId);
  
  Future<Either<Failure, PaymentEntity>> refundPayment({
    required String paymentIntentId,
    double? amount,
  });
  
  Future<Either<Failure, PaymentEntity>> getPayment(String paymentId);
  
  Future<Either<Failure, List<PaymentEntity>>> getUserPayments(String userId);
  
  Future<Either<Failure, PaymentMethodEntity>> savePaymentMethod({
    required String userId,
    required PaymentMethod type,
    required String paymentMethodId,
  });
  
  Future<Either<Failure, List<PaymentMethodEntity>>> getUserPaymentMethods(String userId);
  
  Future<Either<Failure, void>> deletePaymentMethod(String paymentMethodId);
  
  Future<Either<Failure, PaymentMethodEntity>> setDefaultPaymentMethod(String paymentMethodId);
}




