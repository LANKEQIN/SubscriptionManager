import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_manager/features/subscription_feature/domain/repositories/subscription_repository.dart';
import 'package:subscription_manager/features/subscription_feature/presentation/blocs/subscription_event.dart';
import 'package:subscription_manager/features/subscription_feature/presentation/blocs/subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _repository;

  SubscriptionBloc({required SubscriptionRepository repository})
      : _repository = repository,
        super(const SubscriptionState.initial()) {
    on<LoadSubscriptions>((event, emit) async {
      await _loadSubscriptions(emit);
    });
    on<AddSubscription>((event, emit) async {
      await _addSubscription(event, emit);
    });
    on<UpdateSubscription>((event, emit) async {
      await _updateSubscription(event, emit);
    });
    on<DeleteSubscription>((event, emit) async {
      await _deleteSubscription(event, emit);
    });
  }

  Future<void> _loadSubscriptions(Emitter<SubscriptionState> emit) async {
    emit(const SubscriptionState.loading());
    try {
      final subscriptions = await _repository.getAllSubscriptions();
      emit(SubscriptionState.loaded(subscriptions));
    } catch (e) {
      emit(SubscriptionState.error(e.toString()));
    }
  }
  
  Future<void> _addSubscription(AddSubscription event, Emitter<SubscriptionState> emit) async {
    emit(const SubscriptionState.loading());
    try {
      await _repository.addSubscription(event.subscription);
      final subscriptions = await _repository.getAllSubscriptions();
      emit(SubscriptionState.loaded(subscriptions));
    } catch (e) {
      emit(SubscriptionState.error(e.toString()));
    }
  }
  
  Future<void> _updateSubscription(UpdateSubscription event, Emitter<SubscriptionState> emit) async {
    emit(const SubscriptionState.loading());
    try {
      await _repository.updateSubscription(event.subscription);
      final subscriptions = await _repository.getAllSubscriptions();
      emit(SubscriptionState.loaded(subscriptions));
    } catch (e) {
      emit(SubscriptionState.error(e.toString()));
    }
  }
  
  Future<void> _deleteSubscription(DeleteSubscription event, Emitter<SubscriptionState> emit) async {
    emit(const SubscriptionState.loading());
    try {
      await _repository.deleteSubscription(event.id);
      final subscriptions = await _repository.getAllSubscriptions();
      emit(SubscriptionState.loaded(subscriptions));
    } catch (e) {
      emit(SubscriptionState.error(e.toString()));
    }
  }
}