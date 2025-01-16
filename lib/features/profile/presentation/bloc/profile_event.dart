

abstract class ProfileEvent {}

class SaveProfileEvent extends ProfileEvent {
  final dynamic profileModel;
  final String userId;

  SaveProfileEvent({required this.profileModel, required this.userId});
}

class UpdateProfileEvent extends ProfileEvent {
  final dynamic profileModel;
  final String userId;

  UpdateProfileEvent({required this.profileModel, required this.userId});
}

class GetProfileEvent extends ProfileEvent {
  final String userId;

  GetProfileEvent({required this.userId});
}

class CheckProfileStatusEvent extends ProfileEvent {

}
