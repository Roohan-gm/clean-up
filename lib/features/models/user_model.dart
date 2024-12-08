import 'package:clean_up/utils/formatters/formatter.dart';

class UserModel {
  // Keep those values final which you do not want to update
  final String id;
  String firstName;
  String lastName;
  final String email;
  final String username;
  String phoneNumber;
  String profilePicture;

  UserModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.username,
      required this.phoneNumber,
      required this.profilePicture});

  /// Helper function to get the full name.
  String get fullName => '$firstName $lastName';

  /// Helper function to format phone number.
  String get formattedPhoneNo => RFormatter.formatPhoneNumber(phoneNumber);

  /// Static function to split name into first and last name.
  static List<String> nameParts(fullName) => fullName.split(" ");

  /// Helper function to get the full name.
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername =
        "$firstName$lastName"; // Combine first and last name.
    String usernameWithPrefix = "cwt_$camelCaseUsername"; // Add "cwt_" prefix
    return usernameWithPrefix;
  }

  /// Static function to create a empty user model.
  static UserModel empty() => UserModel(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      username: '',
      phoneNumber: '',
      profilePicture: '');

  /// Convert model to JSON structure for data to Supabase.
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture
    };
  }

  /// Factory method to create a UserModel from a Supabase document snapshot.
  // factory UserModel.fromSnapshot(Map<String, dynamic> data) {
  //   return UserModel(
  //     id: data['id'] ?? '',
  //     firstName: data['first_name'] ?? '',
  //     lastName: data['last_name'] ?? '',
  //     email: data['email'] ?? '',
  //     username: data['username'] ?? '',
  //     phoneNumber: data['phone_number'] ?? '',
  //     profilePicture: data['profile_picture'] ?? ''
  //   );
  // }
}
