

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final dynamic profileModel;

  ProfileSuccessState(this.profileModel);
}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);
}

class ProfileStatusCompleteState extends ProfileState {}

class ProfileStatusIncompleteState extends ProfileState {}
