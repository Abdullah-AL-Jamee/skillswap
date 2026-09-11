import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_bubble.dart';
import '../widgets/skill_tag_editor.dart';

/// Profile Creation and Skill Listing.
///
/// The member enters their contact details and a short biography, then builds
/// two separate lists of skill tags: the skills they can teach and the skills
/// they would like to learn in return. The screen opens in read-only mode and
/// switches to editing when "Edit profile" is tapped, so a profile can be kept
/// up to date as interests change.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.store});

  final ProfileStore store;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;

  bool _editing = false;

  UserProfile get _profile => widget.store.profile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _profile.name);
    _emailController = TextEditingController(text: _profile.email);
    _phoneController = TextEditingController(text: _profile.phone);
    _bioController = TextEditingController(text: _profile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      _profile.name = _nameController.text.trim();
      _profile.email = _emailController.text.trim();
      _profile.phone = _phoneController.text.trim();
      _profile.bio = _bioController.text.trim();
      _editing = false;
    });
    widget.store.save();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Profile saved')));
  }

  @override
  Widget build(BuildContext context) {
    final summary =
        '${_profile.skillsOffered.length} skills offered  -  '
        '${_profile.skillsWanted.length} skills wanted';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (!_editing)
            TextButton(
              onPressed: () => setState(() => _editing = true),
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Center(
              child: Column(
                children: [
                  AvatarBubble(initial: _profile.initial),
                  const SizedBox(height: 12),
                  Text(
                    _profile.name.isEmpty ? 'Your name' : _profile.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _editing ? 'Editing profile' : summary,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const SectionTitle('Your details'),
            _Field(
              label: 'Full name',
              controller: _nameController,
              enabled: _editing,
              hint: 'e.g. Amelia Chen',
            ),
            _Field(
              label: 'Email address',
              controller: _emailController,
              enabled: _editing,
              hint: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            _Field(
              label: 'Phone number',
              controller: _phoneController,
              enabled: _editing,
              hint: '0400 000 000',
              keyboardType: TextInputType.phone,
            ),
            _Field(
              label: 'About you',
              controller: _bioController,
              enabled: _editing,
              hint: 'A short introduction for other members',
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            const SectionTitle('Skills I can teach'),
            SkillTagEditor(
              skills: _profile.skillsOffered,
              hintText: 'Add a skill you can teach',
              editable: _editing,
              onAdd: (skill) => setState(
                () => _profile.addSkill(offered: true, skill: skill),
              ),
              onRemove: (skill) => setState(
                () => _profile.removeSkill(offered: true, skill: skill),
              ),
            ),
            const SizedBox(height: 24),
            const SectionTitle('Skills I want to learn'),
            SkillTagEditor(
              skills: _profile.skillsWanted,
              hintText: 'Add a skill you want to learn',
              editable: _editing,
              onAdd: (skill) => setState(
                () => _profile.addSkill(offered: false, skill: skill),
              ),
              onRemove: (skill) => setState(
                () => _profile.removeSkill(offered: false, skill: skill),
              ),
            ),
            const SizedBox(height: 32),
            if (_editing)
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save profile'),
              )
            else
              ElevatedButton(
                onPressed: () => setState(() => _editing = true),
                child: const Text('Edit profile'),
              ),
          ],
        ),
      ),
    );
  }
}

/// Labelled text field used for each detail on the profile form.
class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.enabled,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.body,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            enabled: enabled,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 15, color: AppColors.heading),
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}
