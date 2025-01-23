
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellphy/core/utils/constants.dart';
import 'package:sellphy/features/profile/domain/entities/profile.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:sellphy/features/profile/presentation/bloc/profile_event.dart';

class ProfileForm extends StatefulWidget {
  final bool isEdit;
  ProfileForm({this.isEdit = false});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _profileImageUrl;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _initializeFields() async {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    final profileModel = await profileBloc.onGetProfileForProfilePage();
    setState(() {
      _fullNameController.text = profileModel.username.isEmpty
          ? user!.email!.split('@')[0]
          : profileModel.username;
      _addressController.text = profileModel.address ?? '';
      _phoneNumberController.text = profileModel.phoneNumber ?? '';
      _profileImageUrl = profileModel.imageUrl;
    });
  }

  Future<void> _pickImage() async {
    final selectedUrl = await _selectImageFromUrls();
    if (selectedUrl != null) {
      setState(() {
        _profileImageUrl = selectedUrl;
      });
    }
  }

  Future<String?> _selectImageFromUrls() async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select an Image'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: ProfileConstants.imgUrls.length,
              itemBuilder: (BuildContext context, int index) {
                final url = ProfileConstants.imgUrls[index];
                return GestureDetector(
                  onTap: () => Navigator.pop(context, url),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          widget.isEdit
              ? Container()
              : TextButton(
                  onPressed: () async {
                    final profileBloc = BlocProvider.of<ProfileBloc>(context);
                    final fetchedProfile =
                        await profileBloc.onGetProfileForProfilePage();

                    profileBloc.add(
                      SaveProfileEvent(
                        profileModel: ProfileModel(
                          imageUrl: _profileImageUrl ?? "",
                          username: fetchedProfile.username.isEmpty
                              ? user!.email!.split('@')[0]
                              : fetchedProfile.username,
                          phoneNumber: fetchedProfile.phoneNumber,
                          address: fetchedProfile.address,
                        ),
                        userId: user!.uid,
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
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
                      Icon(Icons.arrow_forward_rounded, color: Colors.red)
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
                        backgroundImage: _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : null,
                        child: _profileImageUrl == null
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
                          if (widget.isEdit) {
                            // Save edited details
                            BlocProvider.of<ProfileBloc>(context)
                                .add(SaveProfileEvent(
                              profileModel: ProfileModel(
                                address: _addressController.text.trim(),
                                imageUrl: _profileImageUrl ?? '',
                                phoneNumber: _phoneNumberController.text.trim(),
                                username: _fullNameController.text.isEmpty
                                    ? user!.email!.split('@')[0]
                                    : _fullNameController.text.trim(),
                              ),
                              userId: user!.uid,
                              isEdit: true
                            ));
                            Navigator.pop(context);

                         
                          } else {
                            // Save or Skip logic for new users
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<ProfileBloc>(context)
                                  .add(SaveProfileEvent(
                                profileModel: ProfileModel(
                                  address: _addressController.text.trim(),
                                  imageUrl: _profileImageUrl ?? '',
                                  phoneNumber: _phoneNumberController.text,
                                  username: _fullNameController.text.isEmpty
                                      ? user!.email!.split('@')[0]
                                      : _fullNameController.text.trim(),
                                ),
                                userId: user!.uid,
                               isEdit: false
                              ));
                            }
                            // Navigator.of(context).pushAndRemoveUntil(
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           AuthWrapper(initialTabIndex: 0)),
                            //   (route) => false,
                            // );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        child: Text(
                            widget.isEdit ? 'Update Profile' : 'Save Profile'),
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
