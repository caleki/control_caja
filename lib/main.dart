import 'package:flutter/material.dart';
import 'screens/arqueo_caja_page.dart';

void main() => runApp(ArqueoCajaApp());

class ArqueoCajaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arqueo de Caja',
      home: ArqueoCajaPage(),
    );
  }
}
  