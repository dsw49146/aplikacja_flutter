import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kopalnia',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Kopalnia'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _bestScore = 0;
  bool _timerActive = false;
  int _timerSeconds = 15;
  late Timer _timer;
  List<int> _pressHistory = [];
  bool _buttonEnabled = true;
  bool _isWoodenPickaxe = true;
  String _pickaxeName = 'Drewniany kilof';
  Color _appBackgroundColor = Color.fromARGB(255, 255, 255, 255);
  Color _containerColor = Colors.blue;
  Color _appBarBackgroundColor = Color.fromARGB(255, 0, 225, 255); // Dodana nowa zmienna dla koloru tła AppBar
  String _textInContainer = 'Ile wykopiesz diamentów?';
  String _currentPickaxeImage = "assets/pickaxewood.png";
  String _backgroundImageForDiamonds = "assets/backgroundflutterapp.jpg";
  String _backgroundImageForStones = "assets/backgroundstones.jpg";
  int _woodenPickaxeClicks = 0; // Nowa zmienna dla śledzenia kliknięć drewnianego kilofa
  int _woodenPickaxeClicksAdvanced = 0; // Nowa zmienna dla śledzenia kliknięć drewnianego kilofa w zmienionym widoku
  int _diamondPickaxeClicksAdvanced = 0; // Nowa zmienna dla śledzenia kliknięć diamentowego kilofa w zmienionym widoku

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _stopTimer() async {
    _timer.cancel();
    _timerActive = false;
    List<int> pressHistoryCopy = List.from(_pressHistory);
    _resetCounters();
    _showResultDialog(pressHistoryCopy);
  }

  void _incrementCounter(int value) {
    if (!_timerActive) {
      _startTimer();
    }

    setState(() {
      if (_isWoodenPickaxe) {
        if (_appBackgroundColor == Colors.white) {
          _woodenPickaxeClicks++;
          if (_woodenPickaxeClicks == 4) {
            _counter += 1; // Drewniany kilof zdobywa 1 punkt co 4 kliknięcia w widoku domyślnym
            _woodenPickaxeClicks = 0; // Zresetuj licznik kliknięć drewnianego kilofa
          }
        } else {
          _woodenPickaxeClicksAdvanced++;
          if (_woodenPickaxeClicksAdvanced == 1) {
            _counter += 1; // Drewniany kilof zdobywa 1 punkt za każde kliknięcie w zmienionym widoku
            _woodenPickaxeClicksAdvanced = 0; // Zresetuj licznik kliknięć drewnianego kilofa w zmienionym widoku
          }
        }
      } else {
        if (_appBackgroundColor != Colors.white) {
          _diamondPickaxeClicksAdvanced++;
          if (_diamondPickaxeClicksAdvanced == 1) {
            _counter += 4; // Diamentowy kilof zdobywa 4 punkty za każde kliknięcie w zmienionym widoku
            _diamondPickaxeClicksAdvanced = 0; // Zresetuj licznik kliknięć diamentowego kilofa w zmienionym widoku
          }
        } else {
          _counter += value; // Diamentowy kilof zdobywa 4 punkty za każde kliknięcie w widoku domyślnym
        }
      }

      _pressHistory.add(_counter);

      if (_counter > _bestScore) {
        _bestScore = _counter;
      }
    });
  }

  void _startTimer() {
    _timerActive = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _resetCounters() {
    setState(() {
      _counter = 0;
      _timerSeconds = 15;
    });
  }

  void _showResultDialog(List<int> pressHistoryCopy) {
    print('_pressHistory: $pressHistoryCopy');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String resultMessage = 'No result';
        if (pressHistoryCopy.isNotEmpty) {
          resultMessage = 'Ostatni wynik: ${pressHistoryCopy.last}';
        }
        return AlertDialog(
          title: Text('Wykopaliska:'),
          content: Column(
            children: [
              Text(resultMessage),
              SizedBox(height: 10),
              Text('Najlepszy wynik: $_bestScore'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _buttonEnabled = true;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _changeAppearance() {
    setState(() {
      if (_appBackgroundColor == Colors.white) {
        _appBackgroundColor = Colors.grey;
        _containerColor = const Color.fromARGB(255, 68, 68, 68);
        _textInContainer = 'Ile wykopiesz kamienia?';
      } else {
        _appBackgroundColor = Colors.white;
        _containerColor = Colors.blue;
        _textInContainer = 'Ile wykopiesz diamentów?';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarBackgroundColor,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Aktualnie wybrany kilof:   $_pickaxeName'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _isWoodenPickaxe = !_isWoodenPickaxe;
                  _buttonEnabled = true;
                  _pickaxeName = _isWoodenPickaxe ? 'Drewniany kilof' : 'Diamentowy kilof';
                  _currentPickaxeImage = _isWoodenPickaxe
                      ? "assets/pickaxewood.png"
                      : "assets/pickaxeflutterl.png";
                });
              },
            ),
            ListTile(
              title: Text(
                'Zmień kilof',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _isWoodenPickaxe = !_isWoodenPickaxe;
                  _buttonEnabled = true;
                  _pickaxeName = _isWoodenPickaxe ? 'Drewniany kilof' : 'Diamentowy kilof';
                  _currentPickaxeImage = _isWoodenPickaxe
                      ? "assets/pickaxewood.png"
                      : "assets/pickaxeflutterl.png";
                });
              },
            ),
            ListTile(
              title: Text(
                'Zmień kopalnie',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _changeAppearance();
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              _appBackgroundColor == Colors.white
                  ? _backgroundImageForDiamonds
                  : _backgroundImageForStones,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color: _containerColor,
                width: 350,
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  _textInContainer,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                color: _containerColor,
                width: 350,
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Wynik: $_counter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                color: _containerColor,
                width: 350,
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Pozostały czas: $_timerSeconds sekund',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 60),
              InkWell(
                onTap: _buttonEnabled ? () => _incrementCounter(_isWoodenPickaxe ? 1 : 1) : null,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_currentPickaxeImage),
                      fit: BoxFit.contain,
                    ),
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}