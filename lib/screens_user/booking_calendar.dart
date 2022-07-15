


import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/model/meeting_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../model/user_model.dart';
QuerySnapshot ?querySnapshot;

class BookingCalendarCnef extends StatefulWidget {
  const BookingCalendarCnef({Key? key}) : super(key: key);

  @override
  _BookingCalendarCnefState createState() => _BookingCalendarCnefState();
}

class _BookingCalendarCnefState extends State<BookingCalendarCnef> {
  final now =DateTime.now().toLocal();
  List<DateTimeRange> converted = [];
  List<MeetingModel> meeting_array=[];
  late BookingService mockBookingService;
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    getDocs();

    mockBookingService = BookingService(
        serviceName: 'Mock Service',
        serviceDuration: 30,
        bookingStart: DateTime(now.year,now.month,now.day, 7, 0),
        bookingEnd: DateTime( now.year,now.month,now.day,18, 0));
  }
  void getDocs() async{
    querySnapshot = await FirebaseFirestore.instance.collection("meeting").get();
    for (int i = 0; i < querySnapshot!.docs.length; i++) {
      var a = querySnapshot!.docs[i];
      Timestamp timestamp_start = a.get('start');
      DateTime dateTime= timestamp_start.toDate();
      Timestamp timestamp_end = a.get('end');
      DateTime dateTime2= timestamp_end.toDate();
      converted.add(DateTimeRange(start: dateTime,end :dateTime.add(Duration(minutes: dateTime2.minute))));
    }
  }
  Stream<dynamic>? getBookingStreamMock({required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock({required BookingService newBooking}) async {
    return showDialog(context: context, builder: (BuildContext buildcontext)
    {
      return AlertDialog(
        title: Text("Etes vous surs de prendre rdv a cette heure ci ?"),
        content: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),

                  color: Colors.greenAccent,
                  child: MaterialButton(
                    onPressed: () async {
                      converted.add(DateTimeRange(
                          start: newBooking.bookingStart,
                          end: newBooking.bookingEnd));
                      Navigator.of(context).pop();
    MeetingModel meetingModel = MeetingModel();
    meetingModel.id =user!.uid;
    meetingModel.user="${loggedUser.firstname} ${loggedUser.lastName}";
    meetingModel.start=newBooking.bookingStart;
    meetingModel.end=newBooking.bookingEnd;
    meetingModel.title="Rendez vous conseillere";
    meetingModel.description="...";
    FirebaseFirestore.instance
        .collection("meeting")
        .doc(user!.uid)
        .set(meetingModel.toMap());
    Fluttertoast.showToast(msg: "your request has been sent :)");

                    },
                    child: Text("Oui", textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),

                  color: Colors.redAccent,
                  child: MaterialButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text("Non", textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

  }



  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    int count_month =0;int count_day=0;
        while(now.month+count_month==1 ||now.month+ count_month==3||now.month+ count_month==5||now.month+ count_month==7||now.month+ count_month==8||now.month+ count_month==10||now.month+ count_month==12&& now.day + count_day<=31) {
          DateTime five = DateTime(
              now.year, now.month + count_month, now.day + count_day, 0);
          converted.add(
              DateTimeRange(start: five, end: five.add(Duration(hours: 8))));
          count_day++;
          if(now.day+count_day==31){
            DateTime five = DateTime(
                now.year, now.month + count_month, now.day + count_day, 0);
            converted.add(
                DateTimeRange(start: five, end: five.add(Duration(hours: 8))));
            return converted;
          }
        }
      while(now.month+count_month==4 ||now.month+ count_month==6||now.month+ count_month==9||now.month+ count_month==11 &&now.day + count_day<=30) {
          DateTime five = DateTime(
            now.year, now.month + count_month, now.day + count_day, 0);
        converted.add(
            DateTimeRange(start: five, end: five.add(Duration(hours: 8))));
        count_day++;
        if(now.day+count_day==30){
          DateTime five = DateTime(
              now.year, now.month + count_month, now.day + count_day, 0);
          converted.add(
              DateTimeRange(start: five, end: five.add(Duration(hours: 8))));
          return converted;

        }
      }
      while(now.month+ count_month==2&&now.day + count_day<=28) {
        DateTime five = DateTime(
            now.year, now.month + count_month, now.day + count_day, 0);
        converted.add(
            DateTimeRange(start: five, end: five.add(Duration(hours: 8))));
        count_day++;
        if(now.day+count_day==28){
          DateTime five = DateTime(
              now.year, now.month + count_month, now.day + count_day, 0);
          converted.add(
              DateTimeRange(start: five, end: five.add(Duration(hours: 8))));
          return converted;
        }





      }
    return converted;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: Center(

        child: BookingCalendar(
          availableSlotText: "Disponible",
          bookingButtonText: "Prendre RDV",

          bookingButtonColor: Colors.deepPurpleAccent,
          selectedSlotText: "Selectionne",
          bookedSlotText: "Indisponible",
          bookingService: mockBookingService,
          convertStreamResultToDateTimeRanges: convertStreamResultMock,
          getBookingStream: getBookingStreamMock,
          uploadBooking: uploadBookingMock,
        ),
      ),

    );
  }

}
