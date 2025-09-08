import 'package:equatable/equatable.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrderTracking extends TrackingEvent {
  final String orderId;

  const LoadOrderTracking({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class StartTracking extends TrackingEvent {
  final String orderId;

  const StartTracking({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class StopTracking extends TrackingEvent {
  final String orderId;

  const StopTracking({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class RefreshTracking extends TrackingEvent {
  final String orderId;

  const RefreshTracking({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
