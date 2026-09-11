import 'package:flutter/material.dart';

import '../models/time_slot.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_bubble.dart';
import '../widgets/star_rating.dart';

/// Session Booking Calendar.
///
/// A day is picked from the mentor's week, and the time slots for that day are
/// shown as a grid. Open slots are green and taken slots are salmon: the two
/// colours replaced the identical grey slots of the first prototype, after
/// user testing showed that testers could not tell the two states apart. The
/// member chooses an open slot and a session format, then confirms, and a
/// short message reports that the booking was made.
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final List<DaySchedule> _week = DaySchedule.sampleWeek();

  int _selectedDay = 1;
  TimeSlot? _selectedSlot;
  SessionFormat _format = SessionFormat.online;

  DaySchedule get _day => _week[_selectedDay];

  void _selectDay(int index) {
    setState(() {
      _selectedDay = index;
      _selectedSlot = null;
    });
  }

  void _selectSlot(TimeSlot slot) {
    if (slot.isBooked) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${slot.label} is already booked. Pick a green slot.'),
          ),
        );
      return;
    }
    setState(() => _selectedSlot = slot);
  }

  void _confirmBooking() {
    final slot = _selectedSlot;
    if (slot == null) return;

    setState(() {
      slot.isBooked = true;
      _selectedSlot = null;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Session booked with Amelia Chen on ${_day.weekday} '
            '${_day.dayOfMonth} at ${slot.label} (${_format.label}).',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book a Session')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                children: [
                  const _MentorHeader(),
                  const SizedBox(height: 22),
                  const SectionTitle('Choose a day'),
                  _DayStrip(
                    week: _week,
                    selectedIndex: _selectedDay,
                    onSelected: _selectDay,
                  ),
                  const SizedBox(height: 22),
                  SectionTitle(
                    'Choose a time - ${_day.weekday} ${_day.dayOfMonth} April',
                  ),
                  _SlotGrid(
                    slots: _day.slots,
                    selected: _selectedSlot,
                    onSelected: _selectSlot,
                  ),
                  const SizedBox(height: 14),
                  const _Legend(),
                  const SizedBox(height: 24),
                  const SectionTitle('Session format'),
                  _FormatSelector(
                    value: _format,
                    onChanged: (value) => setState(() => _format = value),
                  ),
                ],
              ),
            ),
            _ConfirmBar(
              slot: _selectedSlot,
              day: _day,
              format: _format,
              onConfirm: _confirmBooking,
            ),
          ],
        ),
      ),
    );
  }
}

/// Summary of the mentor whose calendar is being viewed.
class _MentorHeader extends StatelessWidget {
  const _MentorHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const AvatarBubble(initial: 'A', size: 56),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Amelia Chen',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Teaches Guitar - wants to learn Spanish',
                  style: TextStyle(fontSize: 13, color: AppColors.muted),
                ),
                const SizedBox(height: 4),
                const StarRating(rating: 5, reviewCount: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal strip of the seven days the mentor has published.
class _DayStrip extends StatelessWidget {
  const _DayStrip({
    required this.week,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<DaySchedule> week;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: week.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final day = week[index];
          final selected = index == selectedIndex;
          return InkWell(
            onTap: () => onSelected(index),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 62,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.weekday,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${day.dayOfMonth}',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : AppColors.heading,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${day.openSlotCount} open',
                    style: TextStyle(
                      fontSize: 11,
                      color: selected ? Colors.white70 : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Two-column grid of the selected day's time slots.
class _SlotGrid extends StatelessWidget {
  const _SlotGrid({
    required this.slots,
    required this.selected,
    required this.onSelected,
  });

  final List<TimeSlot> slots;
  final TimeSlot? selected;
  final ValueChanged<TimeSlot> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 46,
      ),
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = identical(slot, selected);

        final Color fill;
        final Color borderColor;
        final Color textColor;
        if (isSelected) {
          fill = AppColors.primary;
          borderColor = AppColors.primary;
          textColor = Colors.white;
        } else if (slot.isBooked) {
          fill = AppColors.slotTakenFill;
          borderColor = AppColors.slotTakenBorder;
          textColor = AppColors.slotTakenText;
        } else {
          fill = AppColors.slotOpenFill;
          borderColor = AppColors.slotOpenBorder;
          textColor = AppColors.slotOpenText;
        }

        return InkWell(
          onTap: () => onSelected(slot),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor, width: 1.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (slot.isBooked && !isSelected)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.lock_outline,
                      size: 15,
                      color: AppColors.slotTakenText,
                    ),
                  ),
                if (isSelected)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.check, size: 16, color: Colors.white),
                  ),
                Text(
                  slot.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Key explaining what the slot colours mean.
class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _LegendDot(
          fill: AppColors.slotOpenFill,
          border: AppColors.slotOpenBorder,
          label: 'Available',
        ),
        SizedBox(width: 18),
        _LegendDot(
          fill: AppColors.slotTakenFill,
          border: AppColors.slotTakenBorder,
          label: 'Already booked',
        ),
        SizedBox(width: 18),
        _LegendDot(
          fill: AppColors.primary,
          border: AppColors.primary,
          label: 'Selected',
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.fill,
    required this.border,
    required this.label,
  });

  final Color fill;
  final Color border;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.body),
        ),
      ],
    );
  }
}

/// Online or in-person choice for the session being booked.
class _FormatSelector extends StatelessWidget {
  const _FormatSelector({required this.value, required this.onChanged});

  final SessionFormat value;
  final ValueChanged<SessionFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final format in SessionFormat.values) ...[
          Expanded(
            child: InkWell(
              onTap: () => onChanged(format),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: format == value
                      ? AppColors.primary.withValues(alpha: 0.10)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: format == value
                        ? AppColors.primary
                        : AppColors.border,
                    width: format == value ? 1.6 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      format == SessionFormat.online
                          ? Icons.videocam_outlined
                          : Icons.place_outlined,
                      size: 18,
                      color: format == value
                          ? AppColors.primary
                          : AppColors.muted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      format.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: format == value
                            ? AppColors.primary
                            : AppColors.body,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (format != SessionFormat.values.last) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

/// Fixed bar at the bottom holding the summary line and the confirm button.
class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({
    required this.slot,
    required this.day,
    required this.format,
    required this.onConfirm,
  });

  final TimeSlot? slot;
  final DaySchedule day;
  final SessionFormat format;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final summary = slot == null
        ? 'Select an available time slot to continue'
        : '${day.weekday} ${day.dayOfMonth} April, ${slot!.label} - '
            '${format.label}';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            summary,
            style: TextStyle(
              fontSize: 14,
              color: slot == null ? AppColors.muted : AppColors.heading,
              fontWeight: slot == null ? FontWeight.w400 : FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: slot == null ? null : onConfirm,
            child: const Text('Confirm booking'),
          ),
        ],
      ),
    );
  }
}
