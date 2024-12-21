import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/models/moment.dart';
import 'package:myapp/repositories/contracts/abs_api_user_data_repository.dart';

import '../../../models/user.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final AbsApiUserDataRepository _apiUserDataRepository;
   List<Moment> _moments = [];
   List<User> _followers = [];
   List<User> _following = [];
  UserDataBloc(this._apiUserDataRepository) : super(UserDataInitial()) {
    on<UserDataGetEvent>(userDataGetEvent);
    on<UserDataGetMomentEvent>(userDataGetMomentEvent);
    on<UserDataGetFollowerEvent>(userDataGetFollowerEvent);
    on<UserDataGetFollowingEvent>(userDataGetFollowingEvent);
    on<UserDataFollowEvent>(userDataFollowEvent);
    on<UserDataUnfollowEvent>(userDataUnfollowEvent);
  }

  List<Moment> get moments => _moments;
  List<User> get followers => _followers;
  List<User> get following => _following;

  Future<void> userDataGetEvent(
      UserDataGetEvent event, Emitter<UserDataState> emit) async {
    emit(const UserDataLoadingState());
    try {
      _moments = await _apiUserDataRepository.getMoments();
      _followers = await _apiUserDataRepository.getFollowers();
      _following = await _apiUserDataRepository.getFollowing();
      emit(UserDataGetSuccessState(_moments, _followers, _following));
    } catch (e) {
      log(e.toString(), name: "UserDataBloc:userDataGetEvent");
      emit(const UserDataFailedActionState('Failed to get user data.'));
    }
  }

  Future<void> userDataGetMomentEvent(
      UserDataGetMomentEvent event, Emitter<UserDataState> emit) async {
    emit(UserDataGetMomentLoadingState());
    try {
      final moments = await _apiUserDataRepository.getMoments();
      emit(UserDataGetMomentSuccessState(moments));
    } catch (e) {
      log(e.toString(), name: "UserDataBloc:userDataGetMomentEvent");
      emit(const UserDataGetMomentFailedActionState('Failed to get moments.'));
    }
  }

  Future<void> userDataGetFollowerEvent(
      UserDataGetFollowerEvent event, Emitter<UserDataState> emit) async {
    emit(UserDataGetFollowerLoadingState());
    try {
      final followers = await _apiUserDataRepository.getFollowers();
      emit(UserDataGetFollowerSuccessState(followers));
    } catch (e) {
      log(e.toString(), name: "UserDataBloc:userDataGetFollowerEvent");
      emit(const UserDataGetFollowerFailedActionState(
          'Failed to get followers.'));
    }
  }

  Future<void> userDataGetFollowingEvent(
      UserDataGetFollowingEvent event, Emitter<UserDataState> emit) async {
    emit(UserDataGetFollowingLoadingState());
    try {
      final following = await _apiUserDataRepository.getFollowing();
      emit(UserDataGetFollowingSuccessState(following));
    } catch (e) {
      log(e.toString(), name: "UserDataBloc:userDataGetFollowingEvent");
      emit(const UserDataGetFollowingFailedActionState(
          'Failed to get following.'));
    }
  }

  Future<void> userDataFollowEvent(
      UserDataFollowEvent event, Emitter<UserDataState> emit) async {
    emit(UserDataFollowLoadingState(event.userId));
    try {
      final result = await _apiUserDataRepository.follow(event.userId);
      if (result) {
        emit(UserDataFollowSuccessActionState(event.userId));
      } else {
        emit(const UserDataFollowFailedActionState('Failed to follow user.'));
      }
    } catch (e) {
      log(e.toString(), name: "UserDataBloc:userDataFollowEvent");
      emit(const UserDataFollowFailedActionState('Failed to follow user.'));
    }
  }

  Future<void> userDataUnfollowEvent(
      UserDataUnfollowEvent event, Emitter<UserDataState> emit) async {
    emit(UserDataUnfollowLoadingState(event.userId));
    try {
      final result = await _apiUserDataRepository.unfollow(event.userId);
      if (result) {
        emit(UserDataUnfollowSuccessActionState(event.userId));
      } else {
        emit(const UserDataUnfollowFailedActionState(
            'Failed to unfollow user.'));
      }
    } catch (e) {
      log(e.toString(), name: "UserDataBloc:userDataUnfollowEvent");
      emit(const UserDataUnfollowFailedActionState('Failed to unfollow user.'));
    }
  }
}
