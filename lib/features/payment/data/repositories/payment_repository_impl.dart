import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/stripe_payment_datasource.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final StripePaymentDataSource dataSource;

  PaymentRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, PaymentEntity>> createPaymentIntent({
    required String orderId,
    required String userId,
    required double amount,
    required String currency,
    required PaymentMethod method,
  }) async {
    try {
      final payment = await dataSource.createPaymentIntent(
        orderId: orderId,
        userId: userId,
        amount: amount,
        currency: currency,
        method: method,
      );
      return Right(payment.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on PaymentException catch (e) {
      return Left(PaymentFailure(message: e.message));
    } catch (e) {
      return Left(UnimplementedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> confirmPayment({
    required String paymentIntentId,
    required String clientSecret,
  }) async {
    try {
      final payment = await dataSource.confirmPayment(
        paymentIntentId: paymentIntentId,
        clientSecret: clientSecret,
      );
      return Right(payment.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on PaymentException catch (e) {
      return Left(PaymentFailure(message: e.message));
    } catch (e) {
      return Left(UnimplementedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> cancelPayment(String paymentIntentId) async {
    try {
      final payment = await dataSource.cancelPayment(paymentIntentId);
      return Right(payment.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on PaymentException catch (e) {
      return Left(PaymentFailure(message: e.message));
    } catch (e) {
      return Left(UnimplementedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> refundPayment({
    required String paymentIntentId,
    double? amount,
  }) async {
    try {
      final payment = await dataSource.refundPayment(
        paymentIntentId: paymentIntentId,
        amount: amount,
      );
      return Right(payment.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on PaymentException catch (e) {
      return Left(PaymentFailure(message: e.message));
    } catch (e) {
      return Left(UnimplementedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPayment(String paymentId) async {
    try {
      final payment = await dataSource.getPayment(paymentId);
      return Right(payment.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on PaymentException catch (e) {
      return Left(PaymentFailure(message: e.message));
    } catch (e) {
      return Left(UnimplementedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getUserPayments(String userId) async {
    try {
      final payments = await dataSource.getUserPayments(userId);
      return Right(payments.map((payment) => payment.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on PaymentException catch (e) {
      return Left(PaymentFailure(message: e.message));
    } catch (e) {
      return Left(UnimplementedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentMethodEntity>> savePaymentMethod({
    required String userId,
    required PaymentMethod type,
    required String paymentMethodId,
  }) async {
    // TODO: Implement payment method saving
    return Left(const UnimplementedFailure(message: 'Payment method saving not implemented'));
  }

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> getUserPaymentMethods(String userId) async {
    // TODO: Implement getting user payment methods
    return Left(const UnimplementedFailure(message: 'Getting user payment methods not implemented'));
  }

  @override
  Future<Either<Failure, void>> deletePaymentMethod(String paymentMethodId) async {
    // TODO: Implement payment method deletion
    return Left(const UnimplementedFailure(message: 'Payment method deletion not implemented'));
  }

  @override
  Future<Either<Failure, PaymentMethodEntity>> setDefaultPaymentMethod(String paymentMethodId) async {
    // TODO: Implement setting default payment method
    return Left(const UnimplementedFailure(message: 'Setting default payment method not implemented'));
  }
}


