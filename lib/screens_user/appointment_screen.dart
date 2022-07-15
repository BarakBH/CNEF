import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/chat_screens/people_user.dart';
import 'package:cnef_app/screens_user/booking_calendar.dart';
import 'package:cnef_app/screens_user/profile_page_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../chat_states/home_page_user_chat.dart';
import '../model/meeting_model.dart';
import '../model/user_model.dart';
import 'AboutUs_screen.dart';
import 'ContactStudent_screen.dart';
import 'FamiliesContact_screen.dart';
import 'Requestfund_screen.dart';
import 'faire_un_don_autre.dart';
import 'home_screen.dart';
import 'home_screen_general.dart';

class Appointment extends StatefulWidget {
  const Appointment({Key? key}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  final now = DateTime.now();
  String string_user="" ;

  List<DateTimeRange> converted = [];
  List<MeetingModel> meeting_array = [];
  late BookingService mockBookingService;
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
    getDocs();
    mockBookingService = BookingService(
        serviceName: 'Mock Service',
        serviceDuration: 30,
        bookingStart: DateTime(now.year, now.month, now.day, 7, 0),
        bookingEnd: DateTime(now.year, now.month, now.day, 18, 0));
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedUser = UserModel.fromMap(value.data());
      string_user="${loggedUser.firstname} ${loggedUser.lastName}";
      setState(() {

      });
    });
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));
  }

  void getDocs() async {
    querySnapshot =
    await FirebaseFirestore.instance.collection("meeting").get();
    for (int i = 0; i < querySnapshot!.docs.length; i++) {
      var a = querySnapshot!.docs[i];
      Timestamp timestamp_start = a.get('start');
      DateTime dateTime = timestamp_start.toDate();
      Timestamp timestamp_end = a.get('end');
      DateTime dateTime2 = timestamp_end.toDate();
      converted.add(DateTimeRange(start: dateTime,
          end: dateTime.add(Duration(minutes: dateTime2.minute-1))));
    }
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    return showDialog(context: context, builder: (BuildContext buildcontext) {
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
                    onPressed: () {
                      addtoCalendar(newBooking);
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
    int count_month = 0;
    int count_day = 0;
    while (now.month + count_month == 1 || now.month + count_month == 3 ||
        now.month + count_month == 5 || now.month + count_month == 7 ||
        now.month + count_month == 8 || now.month + count_month == 10 ||
        now.month + count_month == 12 && now.day + count_day <= 31) {
      DateTime five = DateTime(
          now.year, now.month + count_month, now.day + count_day, 0);
      converted.add(
          DateTimeRange(start: five, end: five.add(Duration(hours: 8))));
      count_day++;
      if (now.day + count_day == 31) {
        DateTime five = DateTime(
            now.year, now.month + count_month, now.day + count_day, 0);
        converted.add(
            DateTimeRange(start: five, end: five.add(Duration(hours: 8))));
        return converted;
      }
    }
    while (now.month + count_month == 4 || now.month + count_month == 6 ||
        now.month + count_month == 9 ||
        now.month + count_month == 11 && now.day + count_day <= 30) {
      DateTime five = DateTime(
          now.year, now.month + count_month, now.day + count_day, 0);
      converted.add(
          DateTimeRange(start: five, end: five.add(Duration(hours: 8))));
      count_day++;
      if (now.day + count_day == 30) {
        DateTime five = DateTime(
            now.year, now.month + count_month, now.day + count_day, 0);
        converted.add(
            DateTimeRange(start: five, end: five.add(Duration(hours: 8))));
        return converted;
      }
    }
    while (now.month + count_month == 2 && now.day + count_day <= 28) {
      DateTime five = DateTime(
          now.year, now.month + count_month, now.day + count_day, 0);
      converted.add(
          DateTimeRange(start: five, end: five.add(Duration(hours: 8))));
      count_day++;
      if (now.day + count_day == 28) {
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

      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                  "${loggedUser.firstname.toString()} ${loggedUser.lastName
                      .toString()}"),
              accountEmail: Text("${loggedUser.email}"),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    "${loggedUser.file.toString()}",
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,


                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlue,

              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Menu"),

              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen())),
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle_rounded),
              title: Text("Profil"),

              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilePageUser())),
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              iconColor: Colors.red,
              textColor: Colors.red,
              title: Text("RDV conseillère"),
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Appointment()))
              },
            ),
            ListTile(
              leading: Icon(Icons.family_restroom),
              title: Text("Contacter Famille"),
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FamiliesContact()))
              },
            ),

            ListTile(
              leading: Icon(Icons.contact_phone),
              title: Text("Contacter un(e) ancien(ne) étudiant(e)"),

              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ContactStudent()))
              },
            ),
            // ListTile(
            //   leading : Icon(Icons.calendar_today),
            //   title : Text("Calendar"),
            //   onTap: ()=>{
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoadDataFromFireStore()))
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text("Demande spéciale"),

              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RequestFunds()))
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text("Faire un don/Payer événement"),
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FaireUnDon()))
              },
            ),

            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("A propos de nous"),

              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AboutUs()))
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Se déconnecter"),
              onTap: () {
                logout(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("RDV conseillère d'orientation"),
      ),
      body: loggedUser.rdv==true ?Center(

        child: BookingCalendar(
          availableSlotText: "Disponible",
          bookingButtonText: "Prendre RDV",
          bookingButtonColor: Colors.deepPurpleAccent,
          selectedSlotText: "Selectionné",
          bookedSlotText: "Indisponible",
          bookingService: mockBookingService,
          convertStreamResultToDateTimeRanges: convertStreamResultMock,
          getBookingStream: getBookingStreamMock,
          uploadBooking: uploadBookingMock,
        ),
      ): Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(

                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:<Widget>[
                        Text("Contacter un administrateur pour qu'il autorise la prise de RDV avec la conseillère d'orientation"
                          ,
                         style : TextStyle(

                            color:Colors.black,
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center,

                        ),
                        SizedBox(height: 20),
                        FloatingActionButton(
                          child : Icon(Icons.chat_sharp,),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomePageChatUser()));

                            },
                        ),


                      ]
                  )
              )

          )
      )



    );
  }
  addtoCalendar(BookingService newBooking) async {
    MeetingModel meetingModel = MeetingModel();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    meetingModel.id = user!.uid;
    meetingModel.user = string_user;
    meetingModel.start = newBooking.bookingStart;
    meetingModel.end = newBooking.bookingEnd;
    meetingModel.title = "Rendez vous conseillere";
    meetingModel.description = "...";
    if (_formKey.currentState!.validate()) {
      await firebaseFirestore
          .collection("meeting")
          .doc(user!.uid)
          .set(meetingModel.toMap());
      Fluttertoast.showToast(msg: "Vous etes bien enregistre");
      Navigator.of(context).pop();
    }
  }
}

