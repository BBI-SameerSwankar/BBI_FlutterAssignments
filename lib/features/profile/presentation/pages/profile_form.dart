import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc package
import 'package:sellphy/features/profile/domain/entities/profile.dart';

import 'package:sellphy/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_event.dart'; // Import ProfileEvent

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  XFile? _profileImage;

  final ImagePicker _picker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(ImageSource.camera);
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(ImageSource.gallery);
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );

    if (pickedSource != null) {
      final pickedFile = await _picker.pickImage(source: pickedSource);

      if (pickedFile != null) {
        setState(() {
          _profileImage = pickedFile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              // Trigger SaveProfileEvent with empty strings when Skip is clicked
              BlocProvider.of<ProfileBloc>(context).add(
                SaveProfileEvent(profileModel: ProfileModel( imageUrl: "", username: "", phoneNumber: "", address: "") ,userId: user!.uid    ), // Passing empty strings
              );
              // Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Row(
              children: [
                Text(
                  'Skip ',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: Colors.red,)
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Complete Your ',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: 'Profile',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _profileImage != null
                            ? FileImage(File(_profileImage!.path))
                            : null,
                        child: _profileImage == null
                            ? const Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                                size: 40,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 60),
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on),
                        hintText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final fullName = _fullNameController.text;
                            final address = _addressController.text;
                            final phoneNumber = _phoneNumberController.text;

                            // Trigger SaveProfileEvent with form data
                            BlocProvider.of<ProfileBloc>(context).add(
                              SaveProfileEvent(
                                
                                profileModel: ProfileModel(address: address, imageUrl: "", phoneNumber: phoneNumber, username: fullName),
                                userId: user!.uid, // Pass empty string or a valid user ID if needed
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Save Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
