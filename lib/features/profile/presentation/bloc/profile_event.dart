

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

}


class ClearProfileEvent extends ProfileEvent{}