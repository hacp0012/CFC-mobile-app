import 'package:flutter/material.dart';

class CMiscClass {
  /// Return [T] when brightness of [context] is [light] or when is [dark]
  /// otherwise return [null].
  static T? whenBrightnessOf<T>(BuildContext context, {T? light, T? dark}) {
    return Theme.of(context).brightness == Brightness.light ? light : dark;
  }

  static T? match<R, T>(R value, Map<R, T> matchs) {
    return matchs[value];
  }

  static PrintableDateHandler date(DateTime dateTime) => PrintableDateHandler(dateTime);

  static String numberAbrev(double number) {
    String symbole = '';

    if (number < 1e3) {
      symbole = '';
    } else if (number < 1e6) {
      symbole = 'K';
      number /= 1e3;
    } else if (number < 1e9) {
      symbole = 'M';
      number /= 1e6;
    } else {
      symbole = 'B';
      number /= 1e9;
    }

    String numberStr = number.toString();
    List<String> splited = numberStr.split(RegExp(r'[\.]'));

    if (splited.length == 2) {
      String first = splited[1][0];

      if (first != '0') {
        numberStr = [splited[0], first].join('.');
      } else {
        numberStr = splited[0];
      }
    }

    return "$numberStr$symbole";
  }
}

class PrintableDateHandler {
  final DateTime dateTime;

  PrintableDateHandler(this.dateTime);

  /// 11 Avr 2024
  String sementic() {
    Map<int, String> months = {
      1: 'Jan',
      2: 'Fév',
      3: 'Mar',
      4: 'Avr',
      5: 'Mai',
      6: 'Juin',
      7: 'Jul',
      8: 'Aout',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Déc',
    };

    return '${dateTime.day} ${months[dateTime.month]} ${dateTime.year}';
  }

  /// 11/04/2024
  String numeric({String seperator = '/'}) => '${dateTime.day}$seperator${dateTime.month}$seperator${dateTime.year}';

  /// il y a 15 jours|maintenent
  String ago({bool clean = false}) {
    DateTime now = DateTime.now();

    Duration diference = now.difference(dateTime);

    String date = '';

    if (diference.inMinutes < 2) {
      date = 'maintenant';
    } else if (diference.inMinutes < 60) {
      date = "${clean ? '' : 'il y a '}${diference.inMinutes} min";
    } else if (diference.inHours < 10) {
      date = "${clean ? '' : 'il y a '}${diference.inHours} heure${diference.inHours == 1 ? 's' : ''}";
    } else if (diference.inHours < 24) {
      date = "${clean ? '' : 'à '}${dateTime.hour} heure";
    } else if (diference.inDays < 30) {
      date = diference.inDays == 1 ? 'hier' : "${clean ? '' : 'il y a '}${diference.inDays} jours";
    } else if (diference.inDays < 60) {
      date = "${clean ? '' : 'il y a '}2 mois";
    } else {
      date = sementic();
    }

    return date;
  }
}
