import 'package:flutter/material.dart';

Map<String, String> iconMap = const {
  'food': '\u0041',
  'gas': '\u0042',
  'amazon': '\u0043',
  'apple': '\u0044',
  'google': '\u0045',
  'netflix': '\u0046',
  'youtube': '\u0047',
  'books': '\u0048',
  'camera': '\u0049',
  'eyecare': '\u004a',
  'healthcare': '\u004b',
  'medicine': '\u004c',
  'hulu': '\u004d',
  'microsoft': '\u004e',
  'playstation': '\u004f',
  'school': '\u0050',
  'spotify': '\u0051',
  'xbox': '\u0052',
  'music': '\u0053',
  'restaurant': '\u0054',
  'music_equipment': '\u0055',
  'sport_equipment': '\u0056',
  'apartment': '\u0057',
  'electricity': '\u0058',
  'haircut': '\u0059',
  'furniture': '\u005a',
  'heater': '\u0061',
  'movies': '\u0062',
  'cloud': '\u0063',
  'groceries_bag': '\u0064',
  'shopping_cart': '\u0065',
  'gift': '\u0066',
  'credit_card': '\u0067',
  'cloth': '\u0068',
  'handbag': '\u0069',
  'water': '\u006a',
  'house': '\u006b',
  'documents': '\u006c',
  'carengine': '\u006d',
  'travel': '\u006e',
  'train': '\u006f',
  'plane': '\u0070',
  'motorbike': '\u0071',
  'toll': '\u0072',
  'car': '\u0073',
  'bus': '\u0074',
  'phone': '\u0075',
  'internet': '\u0076',
  'games': '\u0077',
  'computer': '\u0078'
};

Text getIcon(String icon, {double size = 10, Color color = Colors.white}) {
  return Text(iconMap[icon] ?? 'Icon not found',
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Icons'));
}