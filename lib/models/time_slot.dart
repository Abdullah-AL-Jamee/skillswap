/// A bookable session time on the booking calendar.
class TimeSlot {
  TimeSlot({required this.label, this.isBooked = false});

  final String label;
  bool isBooked;
}

/// One day of the mentor's week, with the slots that day offers.
class DaySchedule {
  DaySchedule({
    required this.weekday,
    required this.dayOfMonth,
    required this.slots,
  });

  final String weekday;
  final int dayOfMonth;
  final List<TimeSlot> slots;

  int get openSlotCount => slots.where((slot) => !slot.isBooked).length;

  /// The mentor's availability for the coming week. Taken times are pre-set so
  /// that the difference between open and booked slots is visible on screen.
  static List<DaySchedule> sampleWeek() {
    List<TimeSlot> slots(List<String> booked) => [
          for (final time in const [
            '9:00 AM',
            '10:00 AM',
            '11:00 AM',
            '1:00 PM',
            '2:00 PM',
            '3:00 PM',
            '4:00 PM',
            '5:00 PM',
          ])
            TimeSlot(label: time, isBooked: booked.contains(time)),
        ];

    return [
      DaySchedule(
          weekday: 'Mon', dayOfMonth: 15, slots: slots(['9:00 AM', '2:00 PM'])),
      DaySchedule(
          weekday: 'Tue',
          dayOfMonth: 16,
          slots: slots(['10:00 AM', '1:00 PM', '4:00 PM'])),
      DaySchedule(
          weekday: 'Wed', dayOfMonth: 17, slots: slots(['11:00 AM'])),
      DaySchedule(
          weekday: 'Thu',
          dayOfMonth: 18,
          slots: slots(['9:00 AM', '10:00 AM', '5:00 PM'])),
      DaySchedule(
          weekday: 'Fri', dayOfMonth: 19, slots: slots(['3:00 PM'])),
      DaySchedule(
          weekday: 'Sat',
          dayOfMonth: 20,
          slots: slots(['1:00 PM', '2:00 PM', '3:00 PM'])),
      DaySchedule(
          weekday: 'Sun',
          dayOfMonth: 21,
          slots: slots(['9:00 AM', '11:00 AM', '4:00 PM', '5:00 PM'])),
    ];
  }
}

/// How a booked session will be held.
enum SessionFormat {
  online('Online'),
  inPerson('In person');

  const SessionFormat(this.label);
  final String label;
}
