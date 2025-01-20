

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}


class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);
}


class ProfileStatusIncompleteState extends ProfileState {
  final dynamic profileModel;

  ProfileStatusIncompleteState(this.profileModel); 
}

class ProfileSetupComplete extends ProfileState{
  final dynamic profileModel;

  ProfileSetupComplete(this.profileModel); 
}

class ProfileUpdateSucess extends ProfileState{}