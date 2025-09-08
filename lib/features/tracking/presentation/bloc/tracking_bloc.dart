import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/tracking_entity.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedefs.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrackingRepository repository;
  StreamSubscription<TrackingEntity>? _trackingSubscription;

  TrackingBloc({
    required this.repository,
  }) : super(const TrackingInitial()) {
    on<LoadOrderTracking>(_onLoadOrderTracking);
    on<StartTracking>(_onStartTracking);
    on<StopTracking>(_onStopTracking);
    on<RefreshTracking>(_onRefreshTracking);
  }

  Future<void> _onLoadOrderTracking(
    LoadOrderTracking event,
    Emitter<TrackingState> emit,
  ) async {
    emit(const TrackingLoading());
    
    final result = await repository.getOrderTracking(event.orderId);
    
    if (emit.isDone) return;
    
    result.fold(
      (failure) => emit(TrackingError(message: failure.message)),
      (trackingHistory) async {
        final latestResult = await repository.getLatestTracking(event.orderId);
        
        if (emit.isDone) return;
        
        latestResult.fold(
          (failure) => emit(TrackingError(message: failure.message)),
          (latestTracking) => emit(TrackingLoaded(
            trackingHistory: trackingHistory,
            latestTracking: latestTracking,
          )),
        );
      },
    );
  }

  Future<void> _onStartTracking(
    StartTracking event,
    Emitter<TrackingState> emit,
  ) async {
    final result = await repository.startTracking(event.orderId);
    
    if (emit.isDone) return;
    
    result.fold(
      (failure) => emit(TrackingError(message: failure.message)),
      (_) {
        emit(const TrackingStarted());
        _startTrackingStream(event.orderId);
      },
    );
  }

  Future<void> _onStopTracking(
    StopTracking event,
    Emitter<TrackingState> emit,
  ) async {
    await _trackingSubscription?.cancel();
    _trackingSubscription = null;
    
    final result = await repository.stopTracking(event.orderId);
    
    if (emit.isDone) return;
    
    result.fold(
      (failure) => emit(TrackingError(message: failure.message)),
      (_) => emit(const TrackingStopped()),
    );
  }

  Future<void> _onRefreshTracking(
    RefreshTracking event,
    Emitter<TrackingState> emit,
  ) async {
    add(LoadOrderTracking(orderId: event.orderId));
  }

  void _startTrackingStream(String orderId) {
    _trackingSubscription?.cancel();
    _trackingSubscription = repository.getTrackingStream(orderId).listen(
      (tracking) {
        // Emit tracking update through an event
        add(LoadOrderTracking(orderId: orderId));
      },
      onError: (error) {
        // Handle error through an event
        add(LoadOrderTracking(orderId: orderId));
      },
    );
  }

  @override
  Future<void> close() {
    _trackingSubscription?.cancel();
    return super.close();
  }
}
