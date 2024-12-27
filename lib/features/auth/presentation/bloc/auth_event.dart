
abstract class AuthEvent {}

class CreateUserEvent extends AuthEvent {}

class LoginUserEvent extends AuthEvent {
  final String userId;

  LoginUserEvent({required this.userId});
}


class LogoutUserEvent extends AuthEvent{

}
class GetUserIdFromLocal extends AuthEvent{
  
}



