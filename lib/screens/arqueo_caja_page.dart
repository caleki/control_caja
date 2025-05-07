import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class ArqueoModel {
  Map<int, int> billetes = {
    100000: 0,
    50000: 0,
    20000: 0,
    10000: 0,
    5000: 0,
    2000: 0,
    1000: 0,
  };
  int transferencia = 0;
  int tarjeta = 0;
  int cajaInicial = 0;

  int get totalEfectivo => billetes.entries
      .map((entry) => entry.key * entry.value)
      .reduce((a, b) => a + b);

  int get totalVentas => totalEfectivo + transferencia + tarjeta - cajaInicial;
}

class ArqueoCajaPage extends StatefulWidget {
  @override
  _ArqueoCajaPageState createState() => _ArqueoCajaPageState();
}

class _ArqueoCajaPageState extends State<ArqueoCajaPage> {
  final ArqueoModel arqueo = ArqueoModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Arqueo de Caja')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ...arqueo.billetes.keys.map((denominacion) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text('$denominacion Gs')),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          setState(() {
                            arqueo.billetes[denominacion] =
                                int.tryParse(val) ?? 0;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Cant.'),
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Gs. ${denominacion * (arqueo.billetes[denominacion] ?? 0)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
            Divider(),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total de Transferencia'),
              onChanged: (val) {
                setState(() {
                  arqueo.transferencia = int.tryParse(val) ?? 0;
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total de Tarjeta'),
              onChanged: (val) {
                setState(() {
                  arqueo.tarjeta = int.tryParse(val) ?? 0;
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Caja Inicial'),
              onChanged: (val) {
                setState(() {
                  arqueo.cajaInicial = int.tryParse(val) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Total de Efectivo: ${arqueo.totalEfectivo} Gs'),
            Text('Total de Ventas del Día: ${arqueo.totalVentas} Gs'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _generarYGuardarPDF();
              },
              child: Text('Guardar como PDF'),
            ),
            ElevatedButton(
              onPressed: _compartirPorWhatsApp,
              child: Text('Compartir por WhatsApp'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _guardarComoTXT();
              },
              child: Text('Guardar como TXT'),
            ),
          ],
        ),
      ),
    );
  }

  void _compartirPorWhatsApp() async {
    final mensaje = '''
📋 *Arqueo de Caja*

🔸 Total Efectivo: ${arqueo.totalEfectivo} Gs
🔸 Transferencias: ${arqueo.transferencia} Gs
🔸 Tarjeta: ${arqueo.tarjeta} Gs
🔸 Caja Inicial: ${arqueo.cajaInicial} Gs
💰 *Total de Ventas del Día: ${arqueo.totalVentas} Gs*
''';

    final url = Uri.parse(
      "https://wa.me/595982253123=${Uri.encodeComponent(mensaje)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo abrir WhatsApp')));
    }
  }

  Future<void> _generarYGuardarPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Arqueo de Caja', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 16),
              pw.Text('Detalle de billetes:'),
              ...arqueo.billetes.entries.map((entry) {
                return pw.Text(
                  '${entry.key} Gs x ${entry.value} = ${entry.key * entry.value} Gs',
                );
              }),
              pw.Divider(),
              pw.Text('Total de Efectivo: ${arqueo.totalEfectivo} Gs'),
              pw.Text('Transferencias: ${arqueo.transferencia} Gs'),
              pw.Text('Tarjetas: ${arqueo.tarjeta} Gs'),
              pw.Text('Caja Inicial: ${arqueo.cajaInicial} Gs'),
              pw.SizedBox(height: 8),
              pw.Text(
                'Total de Ventas del Día: ${arqueo.totalVentas} Gs',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Future<void> _guardarComoTXT() async {
    final contenido = StringBuffer();
    contenido.writeln('Arqueo de Caja');
    contenido.writeln('');
    contenido.writeln('Detalle de billetes:');
    arqueo.billetes.forEach((den, cant) {
      contenido.writeln('$den Gs x $cant = ${den * cant} Gs');
    });
    contenido.writeln('');
    contenido.writeln('Total de Efectivo: ${arqueo.totalEfectivo} Gs');
    contenido.writeln('Transferencias: ${arqueo.transferencia} Gs');
    contenido.writeln('Tarjetas: ${arqueo.tarjeta} Gs');
    contenido.writeln('Caja Inicial: ${arqueo.cajaInicial} Gs');
    contenido.writeln('');
    contenido.writeln('Total de Ventas del Día: ${arqueo.totalVentas} Gs');

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/arqueo_caja.txt');
    await file.writeAsString(contenido.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Archivo TXT guardado en ${file.path}')),
    );
  }
}
