class ArqueoModel {
  final Map<int, int> billetes = {
    100: 0,
    50: 0,
    20: 0,
    10: 0,
    5: 0,
    2: 0,
    1: 0, // monedas
  };

  int transferencia = 0;
  int tarjeta = 0;
  int cajaInicial = 0;

  void actualizarBillete(int valor, String cantidad) {
    billetes[valor] = int.tryParse(cantidad) ?? 0;
  }

  int get totalEfectivo =>
      billetes.entries.map((e) => e.key * e.value).fold(0, (a, b) => a + b);

  int get totalVentas => totalEfectivo + transferencia + tarjeta - cajaInicial;
}
