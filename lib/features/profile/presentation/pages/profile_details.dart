import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sellphy/features/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:sellphy/features/profile/domain/entities/profile.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sellphy/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_event.dart';
import 'profile_form.dart';

class ProfileDetailsPage extends StatefulWidget {
  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final productBloc = BlocProvider.of<ProductBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // App bar background color set to white
        title: const Text(
          'Profile Details',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        // elevation: 1,
      ),
      body: Container(
        constraints: const BoxConstraints
            .expand(), // Ensures the container takes up the full screen
        color: Colors.white, // Background color set to white
        child: FutureBuilder<ProfileModel>(
          future: profileBloc.onGetProfileForProfilePage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.red));
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load profile: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (snapshot.hasData) {
              final _profile = snapshot.data!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: _profile.imageUrl.isNotEmpty
                            ? NetworkImage(_profile.imageUrl)
                            : null,
                        backgroundColor: Colors.red.shade100,
                        child: _profile.imageUrl.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.red,
                              )
                            : null,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _profile.username.isNotEmpty
                            ? _profile.username
                            : user?.email?.split('@')[0] ?? "No Name Provided",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.email ?? "No Email Provided",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        // elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Rounded corners for the Card
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFFEAF4F3), // Set the background color
                            borderRadius: BorderRadius.circular(
                                12), // Rounded corners for the Container
                          ),
                          // color: const Color(
                          // 0xFFEAF4F3), // Set the background color here
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ProfileDetailRow(
                                  icon: Icons.phone,
                                  label: 'Phone',
                                  value: _profile.phoneNumber.isNotEmpty
                                      ? _profile.phoneNumber
                                      : 'No Phone Provided',
                                ),
                                const Divider(),
                                ProfileDetailRow(
                                  icon: Icons.location_on,
                                  label: 'Address',
                                  value: _profile.address.isNotEmpty
                                      ? _profile.address
                                      : 'No Address Provided',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => ProfileForm(isEdit: true),
                              ),
                            )
                                .then((_) {
                              setState(() {});
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            profileBloc.add(ClearProfileEvent());
                            authBloc.add(SignOutEvent());
                            productBloc.add(ClearProductListEvent());
                            Navigator.pushNamedAndRemoveUntil(context, '/', (route)=>false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'No profile data available.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.red),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
