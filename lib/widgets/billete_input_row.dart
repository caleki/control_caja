import 'package:flutter/material.dart';

class BilleteInputRow extends StatelessWidget {
  final int valor;
  final int cantidad;
  final Function(String) onChanged;

  const BilleteInputRow({
    required this.valor,
    required this.onChanged,
    required this.cantidad,
  });

  @override
  Widget build(BuildContext context) {
    final int subtotal = valor * cantidad;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$valor Gs'),
        SizedBox(
          width: 60,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Cant.'),
            onChanged: onChanged,
          ),
        ),
        Text('$subtotal Gs'),
      ],
    );
  }
}
