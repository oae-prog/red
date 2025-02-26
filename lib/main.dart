import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: SquareAnimation(),
        ),
      ),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}

class SquareAnimationState extends State<SquareAnimation> {

  /// Время работы анимации в случае использования кнопок
  var duration = Duration(seconds: 1);

  /// Размер квадрата
  static const squareSize = 50.0;

  /// Блокировка левой кнопки
  var _leftButtonDisabled = false;

  /// Блокировка правой кнопки
  var _rightButtonDisabled = false;

  /// Блокировка кнопок
  var _buttonsDisabled = false;

  /// Переменная указывающая на нажатие кнопки перемещения квадрата вправо
  var _isRightClick = false;


  /// Переменная позиции красного квадрата
  double? _position;

  /// Переменная для работы с обновляемой шириной экрана
  double? _widthDisplay;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {


        ///Переменные и условия для отслеживания квадрата справа
        double newWit = constraints.maxWidth;

        if(_widthDisplay != null && newWit != _widthDisplay)
        {
          if(_isRightClick){
            _position = newWit - squareSize;
          } else if (_position! > newWit - squareSize) {
            _position = newWit - squareSize;
          }
        }

        _widthDisplay = newWit;

        /// Начальная позиция красного квадрата
        _position ??= (_widthDisplay! - squareSize) / 2;

        return Column(
          children: [
            SizedBox(
              height: 100,
              child: Stack(
                children: [
                /// Виджет анимации который я использую с условием [_buttonsDisabled] на время анимации в зависимости от кнопок
                /// Это нужно для прижатия квадрата к правой стороне
                 AnimatedPositioned(
                    duration: _buttonsDisabled ? duration : Duration.zero,
                    left: _position,
                    child: _square()
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _buttonsDisabled || _rightButtonDisabled? null : _onRightClick,
                  child: const Text("Right"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _buttonsDisabled || _leftButtonDisabled? null : _onLeftClick,
                  child: const Text("Left"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  /// Виджет красный квадрат
  Widget _square()
  {
    return Container(
      width: squareSize,
      height: squareSize,
      decoration: BoxDecoration(
        color: Colors.red,
        border: Border.all(),
      ),
    );
  }

  /// Функция перемещения квадрата влево
  void _onLeftClick() => setState(() {
    _isRightClick = false;
    _buttonsDisabled = true;
    _position = 0;
    Future.delayed(duration, _update);
  });

  /// Функция перемещения квадрата вправо
  void _onRightClick() => setState(() {
    _isRightClick = true;
    _buttonsDisabled = true;
    _position = _widthDisplay! - squareSize;
    Future.delayed(duration, _update);
  });

  /// Функция обновления Disabled кнопок
  void _update() => setState(() {
    _leftButtonDisabled = _position == 0;
    _rightButtonDisabled = _position == _widthDisplay! - squareSize;
    _buttonsDisabled = false;
  });
}
