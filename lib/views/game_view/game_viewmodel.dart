import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:traffic_slide/app/app.locator.dart';
import 'package:traffic_slide/models/flame_game/game.dart';
import 'package:traffic_slide/services/game_service.dart';

import '../../app/app.locator.dart';

class GameViewModel extends ReactiveViewModel {
  final GameService _gameService = locator<GameService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_gameService];

  double _carPos = 400;

  double get boardPosX => _gameService.xPosBoard;
  double get boardPosY => _gameService.yPosBoard;
  double get carPos => _carPos;
  double get carWidth => _gameService.baseCarWidth;
  double get policeCarPos => _gameService.policeCarPos;
  bool get shouldPlayAnimation => _gameService.shouldPlayAnimation;
  bool get showGameOver => _gameService.showGameOver;
  int get score => _gameService.score;
  bool get inMainMenu => _gameService.inMainMenu;
  String get animText => _gameService.animText;
  Animation<double> get inOpacity => _gameService.inOpacity;
  Animation<double> get inScale => _gameService.inScale;
  Animation<double> get outOpacity => _gameService.outOpacity;

  bool gamePaused = false;
  bool gameStarted = false;
  bool showHelp = false;

  BoxConstraints lastConstraints = const BoxConstraints();

  //late AnimationController animController;
  late Animation animation;
  late Timer timer;
  late Map<LogicalKeySet, Intent> shortcutMap;
  late Map<Type, Action<Intent>> actionMap;

  final FocusNode keyFocus = FocusNode();

  MovingBackgroundGame game = MovingBackgroundGame();

  bool gameLoaded = false;

  void start(TickerProvider vsync) {
    _gameService.setUpController(vsync);
    animation = Tween<double>(begin: 0, end: 1).animate(_gameService.animController);
    timer = Timer.periodic(const Duration(milliseconds: 40), (t) {
      if (game.finish && !gameLoaded) {
        gameLoaded = true;
        timer.cancel();
        notifyListeners();
      }
    });
    keyFocus.requestFocus();
    shortcutMap = {
      LogicalKeySet(LogicalKeyboardKey.space): const _KeyboardIntent.button(),
    };
    actionMap = <Type, Action<Intent>>{
      _KeyboardIntent: CallbackAction<_KeyboardIntent>(
        onInvoke: _actionHandler,
      ),
    };
  }

  void pause() {
    gamePaused = true;
    _gameService.manualPause();
  }

  void handlePauseButton() {
    if (showHelp) {
      showHelp = false;
      notifyListeners();
      return;
    }
    if (inMainMenu) {
      showHelp = true;
      notifyListeners();
      keyFocus.requestFocus();
    } else {
      pause();
    }
  }

  void restartGame() {
    _gameService.restartGame();
    gamePaused = false;
    notifyListeners();
  }

  void mainMenu() {
    _gameService.mainMenu();
    gamePaused = false;
    gameStarted = false;
    notifyListeners();
  }

  void setCarPosition(double pos, bool isMobile) async {
    if (gameStarted) {
      _gameService.updateCarPos(pos);
    }
    _carPos = pos;
    if (isMobile) {
      _gameService.setCarSize(40);
    }
    //Delay needed to not rebuilt during the build phase
    await Future.delayed(const Duration(milliseconds: 100));
    notifyListeners();
  }

  void resume() {
    gamePaused = false;
    notifyListeners();
    _gameService.manualRestart();
    keyFocus.requestFocus();
  }

  void startGame() {
    _gameService.animController.forward();
    game.startGame();
    gameStarted = true;
    keyFocus.requestFocus();
  }

  void level() {
    game.update(120);
  }

  void _actionHandler(_KeyboardIntent intent) {
    switch (intent.type) {
      case _Actions.button:
        handlePauseButton();
        break;
    }
  }

  @override
  void dispose() {
    _gameService.dispose();
    super.dispose();
  }
}

class _KeyboardIntent extends Intent {
  const _KeyboardIntent({required this.type});

  const _KeyboardIntent.button() : type = _Actions.button;

  final _Actions type;
}

enum _Actions {
  button,
}
