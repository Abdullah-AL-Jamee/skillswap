import 'package:flutter/foundation.dart';

/// The details a member enters on the profile screen. Everything is held in
/// memory for this assessment: no backend or database is connected yet.
class UserProfile {
  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required List<String> skillsOffered,
    required List<String> skillsWanted,
  })  : skillsOffered = List<String>.of(skillsOffered),
        skillsWanted = List<String>.of(skillsWanted);

  String name;
  String email;
  String phone;
  String bio;
  final List<String> skillsOffered;
  final List<String> skillsWanted;

  /// Sample content so the screen matches the prototype when it first opens.
  factory UserProfile.sample() => UserProfile(
        name: 'Amelia Chen',
        email: 'amelia.chen@student.koi.edu.au',
        phone: '0412 345 678',
        bio: 'Guitar teacher with five years of experience. Beginner '
            'friendly, flexible evening sessions.',
        skillsOffered: const ['Guitar', 'Music theory'],
        skillsWanted: const ['Spanish', 'Cooking'],
      );

  /// First letter of the name, shown in the avatar bubble.
  String get initial =>
      name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

  void addSkill({required bool offered, required String skill}) {
    final list = offered ? skillsOffered : skillsWanted;
    final value = skill.trim();
    if (value.isEmpty) return;
    if (list.any((s) => s.toLowerCase() == value.toLowerCase())) return;
    list.add(value);
  }

  void removeSkill({required bool offered, required String skill}) {
    (offered ? skillsOffered : skillsWanted).remove(skill);
  }
}

/// Simple in-memory store shared between the two implemented screens.
class ProfileStore extends ChangeNotifier {
  ProfileStore() : profile = UserProfile.sample();

  final UserProfile profile;

  void save() => notifyListeners();
}
