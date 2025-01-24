// data/datasources/profile_remote_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellphy/features/profile/domain/entities/profile.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfileFromRemote(String userId);
  Future<void> updateProfileOnRemote(ProfileModel profileModel, String userId);
  Future<void> saveProfileOnRemote(ProfileModel profileModel, String userId);
  Future<bool> checkProfileStatus(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {

  final FirebaseFirestore _firebaseFirestore;

  ProfileRemoteDataSourceImpl(
  
    this._firebaseFirestore,
  );

  @override
  Future<ProfileModel> getProfileFromRemote(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firebaseFirestore.collection('profiles').doc(userId).get();

      if (!snapshot.exists) {
        throw Exception('Profile not found');
      }

      var profileData = snapshot.data() as Map<String, dynamic>;

      ProfileModel profile = ProfileModel(
        username: profileData['username'] ?? '',
        phoneNumber: profileData['phoneNumber'] ?? '',
        address: profileData['address'] ?? '',
        imageUrl: profileData['imageUrl'] ?? '',
      );

      return profile;
    } catch (e) {
      throw Exception('Error fetching profile: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProfileOnRemote(ProfileModel profileModel, String userId) async {
    try {
      // String imageUrl = await _uploadImageToFirebaseStorage(imagePath, userId);

      await _firebaseFirestore.collection('profiles').doc(userId).update({
        'username': profileModel.username,
        'phoneNumber': profileModel.phoneNumber,
        'address': profileModel.address,
        'imageUrl': profileModel.imageUrl,
      });
    } catch (e) {
      throw Exception('Error updating profile: ${e.toString()}');
    }
  }

  @override
  Future<void> saveProfileOnRemote(ProfileModel profileModel, String userId) async {
    try {
     

     

      await _firebaseFirestore.collection('profiles').doc(userId).set({
        'username': profileModel.username,
        'phoneNumber': profileModel.phoneNumber,
        'address': profileModel.address,
        'imageUrl': profileModel.imageUrl,
      });
    } catch (e) {
      throw Exception('Error saving profile: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkProfileStatus(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firebaseFirestore.collection('profiles').doc(userId).get();

      if (!snapshot.exists) {
        return false;
      }

      var profileData = snapshot.data() as Map<String, dynamic>;
      print("get profile data");
      print(profileData);
      if (profileData['username'] == "" || profileData['phoneNumber'] == "" || profileData['address'] == "") {
        return false;
      }

      return true; 
    } catch (e) {
      throw Exception('Error checking profile status: ${e.toString()}');
    }
  }

}
