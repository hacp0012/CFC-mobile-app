import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class AppPastoralCalendarScreen extends StatefulWidget {
  static const String routeName = 'pastoral.calendar';
  static const String routePath = 'calendar/app';

  const AppPastoralCalendarScreen({super.key});

  @override
  State<AppPastoralCalendarScreen> createState() => _AppPastoralCalendarScreenState();
}

class _AppPastoralCalendarScreenState extends State<AppPastoralCalendarScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------

  // INITIALIZER -------------------------------------------------------------------------------------------------------------

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendrier pastoral')),

      // BODY :
      // body: const Placeholder(),
      body: Calendar(
        startOnMonday: true,
        weekDays: const ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
        eventsList: eventList(),
        isExpandable: true,
        eventDoneColor: Colors.green,
        selectedColor: CConstants.PRIMARY_COLOR,
        selectedTodayColor: Theme.of(context).colorScheme.primaryContainer,
        todayColor: Colors.blue,
        defaultDayColor: Theme.of(context).colorScheme.onSurface,
        eventColor: null,
        locale: 'fr_FR',
        todayButtonText: "Aujourd'huit",
        allDayEventText: 'Quaresma',
        multiDayEndText: 'Pacques',
        isExpanded: true,
        expandableDateFormat: 'EEEE, le dd MMMM, yyyy',
        datePickerType: DatePickerType.date,
        // dayOfWeekStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
      ),
    );
  }

  // METHODS -----------------------------------------------------------------------------------------------------------------
  List<NeatCleanCalendarEvent> eventList() {
    return [
      NeatCleanCalendarEvent("Événement à plusieurs jrs",
          startTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 0),
          endTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2, 12, 0),
          color: Colors.orange,
          isMultiDay: true),
      NeatCleanCalendarEvent("Événement de tout les jours",
          startTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 2, 14, 30),
          endTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2, 17, 0),
          color: Colors.pink,
          isAllDay: true),
      NeatCleanCalendarEvent("Événement normal",
          startTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 14, 30),
          endTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 17, 0),
          color: Colors.indigo),
    ];
  }
}
