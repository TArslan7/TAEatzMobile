import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class ConfirmPayment {
  final PaymentRepository repository;

  ConfirmPayment(this.repository);

  Future<Either<Failure, PaymentEntity>> call({
    required String paymentIntentId,
    required String clientSecret,
  }) async {
    return await repository.confirmPayment(
      paymentIntentId: paymentIntentId,
      clientSecret: clientSecret,
    );
  }
}


