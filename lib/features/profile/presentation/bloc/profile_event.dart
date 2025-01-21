abstract class ProfileEvent {}

class SaveProfileEvent extends ProfileEvent {
  final dynamic profileModel;
  final String userId;
  final bool isEdit;

  SaveProfileEvent({required this.profileModel, required this.userId, this.isEdit = false});
}

class UpdateProfileEvent extends ProfileEvent {
  final dynamic profileModel;
  final String userId;

  UpdateProfileEvent({required this.profileModel, required this.userId});
}

class GetProfileEvent extends ProfileEvent {

}


class ClearProfileEvent extends ProfileEvent{}