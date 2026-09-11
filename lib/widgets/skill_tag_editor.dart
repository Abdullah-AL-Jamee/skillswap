import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// An editable list of skill tags: existing tags can be removed with the small
/// close icon, and a new tag is added from the text field below them.
class SkillTagEditor extends StatefulWidget {
  const SkillTagEditor({
    super.key,
    required this.skills,
    required this.hintText,
    required this.editable,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> skills;
  final String hintText;
  final bool editable;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  @override
  State<SkillTagEditor> createState() => _SkillTagEditorState();
}

class _SkillTagEditorState extends State<SkillTagEditor> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    widget.onAdd(value);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.skills.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              'No skills added yet.',
              style: TextStyle(color: AppColors.muted, fontSize: 14),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final skill in widget.skills)
                _SkillTag(
                  label: skill,
                  onRemove:
                      widget.editable ? () => widget.onRemove(skill) : null,
                ),
            ],
          ),
        if (widget.editable) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(hintText: widget.hintText),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(64, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SkillTag extends StatelessWidget {
  const _SkillTag({required this.label, this.onRemove});

  final String label;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: onRemove == null ? 14 : 6),
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.chipFill,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.heading,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (onRemove != null)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close, size: 16),
              color: AppColors.muted,
              splashRadius: 16,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              tooltip: 'Remove $label',
            ),
        ],
      ),
    );
  }
}
