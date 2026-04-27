import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(const ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
  }

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    try {
      final profile = await repository.fetchProfile();
      emit(ProfileLoaded(profile));
    } catch (_) {
      emit(const ProfileError('Gagal memuat profile dari API'));
    }
  }
}
