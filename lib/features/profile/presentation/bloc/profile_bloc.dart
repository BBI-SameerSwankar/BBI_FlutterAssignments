


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/profile/domain/entities/profile.dart';
import 'package:sellphy/features/profile/domain/usecases/get_profile_details.dart';
import 'package:sellphy/features/profile/domain/usecases/save_profile_details.dart';
import 'package:sellphy/features/profile/domain/usecases/update_profile_details.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_event.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SaveProfileUseCase saveProfileUseCase;
  final UpdateProfileUseCase updateprofileUsecase;
  final GetProfileUseCase getProfileUsecase;

  ProfileModel _profileModel = ProfileModel(imageUrl: "", username: "", phoneNumber: "", address: "");


  ProfileBloc({
    required this.saveProfileUseCase,
    required this.updateprofileUsecase,
    required this.getProfileUsecase,
 
  }) : super(ProfileInitialState()) {
    on<SaveProfileEvent>(_onSaveProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<GetProfileEvent>(_onGetProfile);
    on<ClearProfileEvent>(_onClearProfile);
  }


  Future<void> _onSaveProfile(SaveProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final result = await saveProfileUseCase.call(event.profileModel, event.userId);
    
    result.fold(
      (failure) => emit(ProfileErrorState(failure.message)),
      (_) { 
        _profileModel = event.profileModel;
        emit(ProfileSetupComplete(event.profileModel));
        }
    );
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final result = await updateprofileUsecase.call(event.profileModel, event.userId);
    result.fold(
      (failure) => emit(ProfileErrorState(failure.message)),
      (_)  {
        _profileModel = event.profileModel;
        emit(ProfileUpdateSucess());
      },
    );
  }

  Future<void> _onGetProfile(GetProfileEvent event, Emitter<ProfileState> emit) async {
    print("here in get profile");
    emit(ProfileLoadingState());
    final firebaseAuth = FirebaseAuth.instance;
    final userId = firebaseAuth.currentUser!.uid;
    final result = await getProfileUsecase.call(userId);
    result.fold(
      (failure) => emit(ProfileStatusIncompleteState(ProfileModel(imageUrl: "", username: "", phoneNumber: "", address: ""))),
      (profileModel){
        _profileModel = profileModel;
        if(profileModel.isComplete)
        {
            emit(ProfileSetupComplete(profileModel));
        }
        else{       
          print("profile is incomplete");
         emit(ProfileStatusIncompleteState(profileModel)); 
        }     
         },
    );
  }


  Future<ProfileModel> onGetProfileForProfilePage() async {
    return _profileModel;
  }



  Future<void> _onClearProfile(ClearProfileEvent event, Emitter<ProfileState> emit) async {
    _profileModel = ProfileModel(imageUrl: "", username: "", phoneNumber: "", address: "");
    emit(ProfileInitialState());
  } 

  @override
void onTransition(Transition<ProfileEvent, ProfileState> transition) {
  super.onTransition(transition);
  print('State Transition: ${transition.currentState} -> ${transition.nextState}');
}

}