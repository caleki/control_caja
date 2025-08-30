import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculadoraWidget extends StatefulWidget {
  const CalculadoraWidget({super.key});

  @override
  State<CalculadoraWidget> createState() => _CalculadoraWidgetState();
}

class _CalculadoraWidgetState extends State<CalculadoraWidget> {
  String _output = "0";
  String _currentOutput = "0";
  double _num1 = 0;
  double _num2 = 0;
  String _operator = "";

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _currentOutput = "0";
        _num1 = 0;
        _num2 = 0;
        _operator = "";
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "/" ||
          buttonText == "X") {
        _num1 = double.tryParse(_output) ?? 0;
        _operator = buttonText;
        _currentOutput = "0";
      } else if (buttonText == ".") {
        if (!_currentOutput.contains(".")) {
          _currentOutput += buttonText;
        }
      } else if (buttonText == "=") {
        _num2 = double.tryParse(_output) ?? 0;
        if (_operator == "+") _currentOutput = (_num1 + _num2).toString();
        if (_operator == "-") _currentOutput = (_num1 - _num2).toString();
        if (_operator == "X") _currentOutput = (_num1 * _num2).toString();
        if (_operator == "/") {
          _currentOutput =
              _num2 == 0 ? "Error" : (_num1 / _num2).toString();
        }
        _num1 = 0;
        _num2 = 0;
        _operator = "";
      } else {
        if (_currentOutput == "0") {
          _currentOutput = buttonText;
        } else {
          _currentOutput += buttonText;
        }
      }

      _output = _currentOutput;
      if (_output.endsWith(".0")) {
        _output = _output.substring(0, _output.length - 2);
      }
    });
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey.keyLabel;

      if ("0123456789".contains(key)) {
        _buttonPressed(key);
      } else if (key == "+") {
        _buttonPressed("+");
      } else if (key == "-") {
        _buttonPressed("-");
      } else if (key == "*") {
        _buttonPressed("X");
      } else if (key == "/") {
        _buttonPressed("/");
      } else if (key == "Enter" || key == "=") {
        _buttonPressed("=");
      } else if (key == ".") {
        _buttonPressed(".");
      } else if (key == "Backspace") {
        if (_currentOutput.isNotEmpty) {
          _currentOutput =
              _currentOutput.substring(0, _currentOutput.length - 1);
          if (_currentOutput.isEmpty) _currentOutput = "0";
          setState(() {
            _output = _currentOutput;
          });
        }
      } else if (key.toUpperCase() == "C") {
        _buttonPressed("C");
      }
    }
  }

  Widget _buildButton(String buttonText, Color textColor, Color buttonColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.all(24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: _handleKey,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black,
              alignment: Alignment.bottomRight,
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 68.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(color: Colors.white24),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildButton("C", const Color(0xFF26F4CE),
                          const Color(0xFF272B33)),
                      _buildButton("/", const Color(0xFF26F4CE),
                          const Color(0xFF272B33)),
                      _buildButton("X", const Color(0xFF26F4CE),
                          const Color(0xFF272B33)),
                      _buildButton("-", const Color(0xFF26F4CE),
                          const Color(0xFF272B33)),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildButton("7", Colors.white, const Color(0xFF272B33)),
                      _buildButton("8", Colors.white, const Color(0xFF272B33)),
                      _buildButton("9", Colors.white, const Color(0xFF272B33)),
                      _buildButton("+", const Color(0xFF26F4CE),
                          const Color(0xFF272B33)),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildButton("4", Colors.white, const Color(0xFF272B33)),
                      _buildButton("5", Colors.white, const Color(0xFF272B33)),
                      _buildButton("6", Colors.white, const Color(0xFF272B33)),
                      _buildButton("=", Colors.white, const Color(0xFF26F4CE)),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildButton("1", Colors.white, const Color(0xFF272B33)),
                      _buildButton("2", Colors.white, const Color(0xFF272B33)),
                      _buildButton("3", Colors.white, const Color(0xFF272B33)),
                      _buildButton(".", Colors.white, const Color(0xFF272B33)),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildButton("0", Colors.white, const Color(0xFF272B33)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
