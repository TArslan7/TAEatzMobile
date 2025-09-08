import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class CreatePaymentIntent {
  final PaymentRepository repository;

  CreatePaymentIntent(this.repository);

  Future<Either<Failure, PaymentEntity>> call({
    required String orderId,
    required String userId,
    required double amount,
    required String currency,
    required PaymentMethod method,
  }) async {
    return await repository.createPaymentIntent(
      orderId: orderId,
      userId: userId,
      amount: amount,
      currency: currency,
      method: method,
    );
  }
}


