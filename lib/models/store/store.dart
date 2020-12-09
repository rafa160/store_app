import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storeapp/models/address/address_pattern.dart';
import 'package:storeapp/helpers/extensions.dart';

enum StoreStatus { closed, open, closing }

class Store {
  String name;
  String image;
  String phone;
  PatternAddress patternAddress;
  Map<String, Map<String, TimeOfDay>> opening;
  StoreStatus status;

  Store.fromDocument(DocumentSnapshot documentSnapshot) {
    name = documentSnapshot.data['name'] as String;
    image = documentSnapshot.data['image'] as String;
    phone = documentSnapshot.data['phone'] as String;

    patternAddress = PatternAddress.fromMap(
        documentSnapshot.data['address'] as Map<String, dynamic>);

    opening = (documentSnapshot.data['opening'] as Map<String, dynamic>)
        .map((key, value) {
      final timeString = value as String;
      if (timeString != null && timeString.isNotEmpty) {
        final splitted = timeString.split(RegExp(r"[:-]"));
        return MapEntry(key, {
          "from": TimeOfDay(
            hour: int.parse(splitted[0]),
            minute: int.parse(splitted[1]),
          ),
          "to": TimeOfDay(
            hour: int.parse(splitted[2]),
            minute: int.parse(splitted[3]),
          ),
        });
      } else {
        return MapEntry(key, null);
      }
    });

    updateStatus();
  }

  String get addressText =>
      '${patternAddress.street}, ${patternAddress.number}${patternAddress.complement.isNotEmpty ? ' - ${patternAddress.complement}' : ''} - '
      '${patternAddress.district}, ${patternAddress.city}/${patternAddress.state}';

  String get openingText {
    return 'Seg-Sex: ${formattedPeriod(opening['week'])}\n'
        'Sab: ${formattedPeriod(opening['saturday'])}\n'
        'Dom: ${formattedPeriod(opening['sunday'])}';
  }

  String formattedPeriod(Map<String, TimeOfDay> period) {
    if (period == null) return 'fechado';
    return '${period['from'].formatted()} - ${period['to'].formatted()}';
  }

  void updateStatus() {
    final weekDay = DateTime.now().weekday;

    Map<String, TimeOfDay> period;
    if (weekDay >= 1 && weekDay <= 5) {
      period = opening['week'];
    } else if (weekDay == 6) {
      period = opening['saturday'];
    } else {
      period = opening['sunday'];
    }

    final now = TimeOfDay.now();

    print('$period' + '$now');

    if (period == null) {
      status = StoreStatus.closed;
    } else if (period['from'].toMinutes() < now.toMinutes() &&
        period['to'].toMinutes() - 10 > now.toMinutes()) {
      status = StoreStatus.open;
    } else if (period['from'].toMinutes() < now.toMinutes() &&
        period['to'].toMinutes() > now.toMinutes()) {
      status = StoreStatus.closing;
    } else {
      status = StoreStatus.closed;
    }

    print(status);
  }

  String get storeStatusText {
    switch (status) {
      case StoreStatus.closed:
        return 'fechado';
      case StoreStatus.open:
        return 'aberto';
      case StoreStatus.closing:
        return 'fechando';
      default:
        return '';
    }
  }

  String get cleanPhone => phone.replaceAll(RegExp(r"[^\d]"),"");
}
