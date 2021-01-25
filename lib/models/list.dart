class TimeCount {
  String time;
  bool booked;
  TimeCount({this.time, this.booked});
}

class TimeCountList {
  List<TimeCount> times = [
    TimeCount(
      time: '9.00 am',
      booked: false,
    ),
    TimeCount(
      time: '9.30 am',
      booked: false,
    ),
    TimeCount(
      time: '10.00 am',
      booked: false,
    ),
    TimeCount(
      time: '10.30 am',
      booked: false,
    ),
    TimeCount(
      time: '11.00 am',
      booked: false,
    ),
    TimeCount(
      time: '11.30 am',
      booked: false,
    ),
    TimeCount(
      time: '12.00 noon',
      booked: false,
    ),
    TimeCount(
      time: '12.30 pm',
      booked: false,
    ),
    TimeCount(
      time: '1.00 pm',
      booked: false,
    ),
    TimeCount(
      time: '1.30 pm',
      booked: false,
    ),
    TimeCount(
      time: '2.00 pm',
      booked: false,
    ),
    TimeCount(
      time: '2.30 pm',
      booked: false,
    ),
    TimeCount(
      time: '3.00 pm',
      booked: false,
    ),
    TimeCount(
      time: '3.30 pm',
      booked: false,
    ),
    TimeCount(
      time: '4.00 pm',
      booked: false,
    ),
    TimeCount(
      time: '4.30 pm',
      booked: false,
    ),
    TimeCount(
      time: '5.00 pm',
      booked: false,
    ),
  ];
}
