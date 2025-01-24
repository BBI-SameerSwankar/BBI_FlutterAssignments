
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/bottom_navigation.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_state.dart';
import 'package:sellphy/features/auth/presentation/pages/login_screen.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_event.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_state.dart';
import 'package:sellphy/features/profile/presentation/pages/profile_form.dart';


class AuthWrapper extends StatelessWidget {
  final int initialTabIndex;

  AuthWrapper({this.initialTabIndex = 0}); 

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        
        if(state is AuthError)
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (state is AuthSignedIn) {

            
          BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
          return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {

       
              if (profileState is ProfileStatusIncompleteState) { return ProfileForm(isEdit: false);} 
              else if (profileState is ProfileSetupComplete)
              {                
                if(profileState.isEdit)
                {
                  return BottomNavigationPage(initialIndex: 3);
                }
                return BottomNavigationPage(initialIndex: 0);
              }            
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
                  
            },
          );
        }
    
        else {
          return LoginPage();
        }
      },
    );
  }
}
