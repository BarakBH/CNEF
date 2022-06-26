import 'package:cnef_app/model/meeting_model.dart';
import 'package:flutter/cupertino.dart';

class EventProvider extends ChangeNotifier{
  final List<MeetingModel> _events =[];

  List<MeetingModel> get events=> _events;
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;
  void setDate(DateTime date )=> _selectedDate = date;

  List<MeetingModel> get eventOfSelectedDate=> _events;

  void addEventCalendar(MeetingModel eventCalendar){
    _events.add(eventCalendar);
    notifyListeners();
  }
}