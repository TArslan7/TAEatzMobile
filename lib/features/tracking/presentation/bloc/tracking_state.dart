import 'package:equatable/equatable.dart';
import '../../domain/entities/tracking_entity.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {
  const TrackingInitial();
}

class TrackingLoading extends TrackingState {
  const TrackingLoading();
}

class TrackingLoaded extends TrackingState {
  final List<TrackingEntity> trackingHistory;
  final TrackingEntity? latestTracking;

  const TrackingLoaded({
    required this.trackingHistory,
    this.latestTracking,
  });

  @override
  List<Object?> get props => [trackingHistory, latestTracking];
}

class TrackingError extends TrackingState {
  final String message;

  const TrackingError({required this.message});

  @override
  List<Object?> get props => [message];
}

class TrackingStarted extends TrackingState {
  const TrackingStarted();
}

class TrackingStopped extends TrackingState {
  const TrackingStopped();
}

class TrackingUpdated extends TrackingState {
  final TrackingEntity tracking;

  const TrackingUpdated({required this.tracking});

  @override
  List<Object?> get props => [tracking];
}
