import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';
import 'package:traffic_slide/views/board/board_view.dart';
import 'package:traffic_slide/widgets/dynamic_button.dart';

import 'game_viewmodel.dart';

class GameView extends StatefulWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final TextStyle baseText = GoogleFonts.josefinSans(
        textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ));
    return ViewModelBuilder<GameViewModel>.reactive(
      onModelReady: (model) => model.start(this),
      builder: (context, model, child) {
        if (!model.keyFocus.hasFocus) {
          model.keyFocus.requestFocus();
        }
        return Scaffold(
          body: LayoutBuilder(builder: (context, constraints) {
            final bool isVertical = constraints.maxWidth < constraints.maxHeight || !kIsWeb;
            final bool isMobile = constraints.maxWidth * 1.6 < constraints.maxHeight || !kIsWeb;
            final bool isLarge = constraints.maxWidth > 1000 && constraints.maxHeight > 700;
            if (model.lastConstraints != constraints && !model.gamePaused) {
              if (model.lastConstraints == const BoxConstraints()) {
                model.setCarPosition(isVertical ? constraints.maxHeight * 0.35 : constraints.maxWidth * 0.24, isMobile);
                model.lastConstraints = constraints;
              } else {
                if (model.gameStarted) {
                  model.pause();
                }
                model.setCarPosition(isVertical ? constraints.maxHeight * 0.35 : constraints.maxWidth * 0.24, isMobile);
                model.lastConstraints = constraints;
              }
            }
            double tileSize = !isMobile ? 60 : 40;
            double boardSize = (6 * tileSize) + 4;
            double carPos = isVertical ? constraints.maxHeight * 0.35 : constraints.maxWidth * 0.24;
            double carHeight = isVertical ? tileSize * 2 : tileSize;
            double carWidth = isVertical ? tileSize : tileSize * 2;
            double carCenterHorizontal = (MediaQuery.of(context).size.height / 2) - tileSize - 2;
            double carCenterVertical = (MediaQuery.of(context).size.width / 2) - tileSize - 2;
            return Stack(
              alignment: Alignment.center,
              children: [
                GameWidget(
                  game: model.game,
                  loadingBuilder: (context) => Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    decoration: const BoxDecoration(color: Color.fromARGB(255, 13, 47, 87)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Loading...", style: baseText.copyWith(fontSize: 30, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: constraints.maxWidth * 0.6,
                          child: const LinearProgressIndicator(backgroundColor: Colors.white, color: Colors.orangeAccent),
                        ),
                      ],
                    ),
                  ),
                ),
                if (model.gameStarted && !model.inMainMenu)
                  Positioned(
                    left: isVertical ? null : model.boardPosX,
                    //This will align our possibly different sized board with the upper edge of the box hitbox
                    top: isVertical ? model.boardPosY + 166 - boardSize : null,
                    child: BoardView(
                      tileSize: tileSize,
                      isVertical: isVertical,
                      isMobile: isMobile,
                    ),
                  ),

                if (model.gameStarted)
                  Positioned(
                    left: isVertical ? null : model.boardPosX + boardSize * 1.1,
                    right: isVertical ? (constraints.maxWidth - boardSize) * 0.4 : null,
                    //This will align our possibly different sized board with the upper edge of the box hitbox
                    top: isVertical ? model.boardPosY - boardSize * 1.1 : null,
                    bottom: isVertical ? null : constraints.maxHeight * 0.54,
                    child: FadeTransition(
                      opacity: model.outOpacity,
                      child: FadeTransition(
                        opacity: model.inOpacity,
                        child: ScaleTransition(
                          scale: model.inScale,
                          child: Text(
                            model.animText,
                            style: baseText.copyWith(
                              fontSize: isLarge ? 80 : 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                if (model.gameLoaded)
                  Positioned(
                    left: isVertical ? carCenterVertical : carPos,
                    top: isVertical ? null : carCenterHorizontal,
                    bottom: isVertical ? carPos - carHeight : null,
                    height: carHeight,
                    width: carWidth,
                    child: Container(
                      height: isVertical ? model.carWidth : model.carWidth * 2,
                      width: isVertical ? model.carWidth * 2 : model.carWidth,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(isVertical ? "assets/narrow_vert.webp" : "assets/narrow.webp"),
                        ),
                      ),
                    ),
                  ),
                //An speech bubble animation
                if (model.shouldPlayAnimation)
                  Positioned(
                    left: isVertical ? carCenterVertical + carWidth / 2 + 20 : carPos - 10,
                    bottom: isVertical ? carPos - carHeight / 2 : carCenterHorizontal + carHeight,
                    child: SizedBox.square(
                      dimension: !isMobile ? 200 : 100,
                      child: const RiveAnimation.asset(
                        "assets/angry.riv",
                      ),
                    ),
                  ),
                if (model.gameStarted)
                  Positioned(
                    left: isVertical ? carCenterVertical - carWidth / 2 : model.policeCarPos - carWidth / 4,
                    top: isVertical ? model.policeCarPos + carHeight / 4 : carCenterHorizontal,
                    height: tileSize,
                    width: 2 * tileSize,
                    child: Transform.rotate(
                      angle: isVertical ? 3 * pi / 2 : 0,
                      child: SizedBox(
                        height: tileSize,
                        width: 2 * tileSize,
                        child: const RiveAnimation.asset("assets/police.riv", alignment: Alignment.center, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                if (model.gameLoaded)
                  AnimatedBuilder(
                      animation: model.animation,
                      builder: (context, child) {
                        return MenuOverlay(
                          carPos: model.carPos,
                          constraints: constraints,
                          anim: model.animation,
                          startGame: () {
                            model.startGame();
                            model.setCarPosition(isVertical ? constraints.maxHeight * 0.35 : constraints.maxWidth * 0.24, isMobile);
                          },
                          level: model.level,
                        );
                      }),
                Positioned(
                  bottom: isMobile ? 12 : 40,
                  right: isMobile ? 12 : 40,
                  child: FocusableActionDetector(
                    focusNode: model.keyFocus,
                    actions: model.actionMap,
                    shortcuts: model.shortcutMap,
                    child: DynamicButton(
                      onPressed: model.handlePauseButton,
                      shouldDarken: false,
                      child: Column(
                        children: [
                          Container(
                            height: isMobile ? 40 : 80,
                            width: isMobile ? 40 : 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black87,
                            ),
                            child: Icon(model.gameStarted ? Icons.pause : Icons.question_mark, color: Colors.white, size: isMobile ? 24 : 50),
                          ),
                          if (!isMobile)
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Container(
                                  width: 70,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        "SPACE",
                                        style: baseText.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ))
                        ],
                      ),
                    ),
                  ),
                ),
                if (model.animation.value == 1)
                  Builder(builder: (context) {
                    double chaseDistance = isVertical ? ((model.policeCarPos - carPos - carHeight) * 0.14) : ((carPos - model.policeCarPos) * 0.4);
                    return Positioned(
                      bottom: isVertical ? null : 80,
                      top: isVertical ? 20 : null,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: isVertical ? 50 : 70,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(right: isVertical ? 130 * 0.6 : 130, left: isVertical ? 65 * 0.6 : 65),
                                child: Container(
                                  height: isVertical ? 10 : 14,
                                  width:
                                      chaseDistance.clamp(isVertical ? 20 : 40, isVertical ? constraints.maxWidth * 0.7 : constraints.maxWidth * 0.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    border: Border.all(color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Positioned(
                                        left: isVertical ? -45 * 0.6 : -45,
                                        child: SizedBox(
                                          height: isVertical ? 55 * 0.6 : 55,
                                          width: isVertical ? 90 * 0.6 : 90,
                                          child: const RiveAnimation.asset("assets/police.riv", alignment: Alignment.center, fit: BoxFit.cover),
                                        ),
                                      ),
                                      Positioned(
                                        right: isVertical ? -110 * 0.6 : -110,
                                        child: Container(
                                          height: isVertical ? 50 * 0.6 : 50,
                                          width: isVertical ? 100 * 0.6 : 100,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(image: AssetImage("assets/narrow.webp"), fit: BoxFit.contain)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: isVertical ? 8 : 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Score:",
                                    style: GoogleFonts.josefinSans(
                                      textStyle: baseText,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(model.score.toString(), style: baseText.copyWith(fontSize: 30, fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                if (model.gamePaused)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                      ),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 36, 127, 202),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          width: isVertical ? constraints.maxWidth * 0.9 : constraints.maxWidth * 0.8,
                          height: constraints.maxHeight * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PauseIcon(constraints: constraints),
                              SizedBox(height: constraints.maxHeight * 0.05),
                              Text(
                                "PAUSED",
                                style: GoogleFonts.josefinSans(
                                  textStyle: TextStyle(color: Colors.white, fontSize: isLarge ? 50 : 36, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.09),
                              Transform.scale(
                                scale: isLarge ? 1 : 0.6,
                                child: StartButton(
                                  onPressed: () {
                                    model.lastConstraints = constraints;
                                    model.setCarPosition(isVertical ? constraints.maxHeight * 0.35 : constraints.maxWidth * 0.24, isMobile);
                                    model.resume();
                                  },
                                  title: "RESUME",
                                  shadowColor: Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (model.showHelp)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        model.showHelp = false;
                        model.notifyListeners();
                      },
                      child: DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.black87),
                        child: Center(
                          child: Container(
                            height: constraints.maxHeight * 0.8,
                            width: isVertical ? constraints.maxWidth * 0.9 : constraints.maxWidth * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(
                                  "How to play?",
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: isMobile ? 24 : 36,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                SizedBox(
                                  width: isVertical ? constraints.maxWidth * 0.8 : constraints.maxWidth * 0.4,
                                  child: Text(
                                    "Help the car escape from the police. During the chase, blocked roads will appear again and again, which you have to clear as quickly as possible by moving the cars. Make sure you keep the road in front of your car clear at all times. \n Best of luck!",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: isMobile ? 18 : 26,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 60),
                                Text(
                                  "Tap anywhere to close",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (model.showGameOver)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        model.showHelp = false;
                        model.notifyListeners();
                      },
                      child: DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.black87),
                        child: Center(
                          child: Container(
                            height: constraints.maxHeight * 0.8,
                            width: isVertical ? constraints.maxWidth * 0.9 : constraints.maxWidth * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Game over!",
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Text(
                                  "Score",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  model.score.toString(),
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                                DynamicButton(
                                  onPressed: () {
                                    model.restartGame();
                                  },
                                  pressedScale: 0.98,
                                  child: Container(
                                    height: 60,
                                    width: isVertical ? constraints.maxWidth * 0.9 * 0.6 : constraints.maxWidth * 0.5 * 0.6,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text("Play again", style: baseText.copyWith(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                DynamicButton(
                                  onPressed: () {
                                    model.mainMenu();
                                  },
                                  pressedScale: 0.98,
                                  child: Container(
                                    height: 60,
                                    width: isVertical ? constraints.maxWidth * 0.9 * 0.6 : constraints.maxWidth * 0.5 * 0.6,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text("Main menu", style: baseText.copyWith(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        );
      },
      viewModelBuilder: () => GameViewModel(),
    );
  }
}

class PauseIcon extends StatelessWidget {
  const PauseIcon({
    Key? key,
    required this.constraints,
  }) : super(key: key);

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final double maxWidth = min(constraints.maxWidth, 1600);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //To counter the skewed Containers
        SizedBox(width: maxWidth * 0.035 * 0.5),
        Transform(
          transform: Matrix4.skewX(-0.25),
          alignment: FractionalOffset.center,
          child: Container(
            height: maxWidth * 0.035 * 2,
            width: maxWidth * 0.035,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1)),
          ),
        ),
        SizedBox(width: maxWidth * 0.01),
        Transform(
          transform: Matrix4.skewX(-0.25),
          alignment: FractionalOffset.center,
          child: Container(
            height: maxWidth * 0.035 * 2,
            width: maxWidth * 0.035,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1)),
          ),
        ),
      ],
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.shadowColor,
    this.scaleFactor = 1.0,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String title;
  final Color shadowColor;

  ///Width will be 340 * [scaleFactor] and height 106 * [scaleFactor]
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    return DynamicButton(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(
        200 * scaleFactor,
      ),
      child: Container(
        height: 106 * scaleFactor,
        width: 340 * scaleFactor,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            200 * scaleFactor,
          ),
          boxShadow: [BoxShadow(offset: const Offset(2, 4), color: shadowColor)],
          color: const Color(0xff2094FF),
        ),
        child: Center(
          child: Container(
            height: 88 * scaleFactor,
            width: 316 * scaleFactor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                200 * scaleFactor,
              ),
              color: const Color(0xff0065C2),
            ),
            child: Center(
              child: Container(
                height: 66 * scaleFactor,
                width: 298 * scaleFactor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    200 * scaleFactor,
                  ),
                  color: const Color(0xff025098),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      title,
                      style: GoogleFonts.josefinSans(
                        textStyle: TextStyle(fontSize: 40 * scaleFactor, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HolePainter extends CustomPainter {
  const HolePainter({
    required this.animValue,
    required this.radius,
    required this.circlePos,
  });

  final double animValue;
  final double radius;
  final Offset circlePos;

  @override
  void paint(Canvas canvas, Size size) {
    //final double circlePos = size.width * 0.32;
    final double calcRadius = radius + animValue * 8 * radius;

    final paint = Paint();
    paint.color = const Color(0xffAC49DB).withOpacity(0.92);
    final Path path = Path();
    path.fillType = PathFillType.evenOdd;
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addOval(Rect.fromCircle(center: circlePos, radius: calcRadius));
    canvas.drawPath(path, paint);

    if (animValue == 0) {
      final secondPaint = Paint();
      final Path secondPath = Path();
      secondPaint.strokeWidth = 4;
      secondPaint.color = Colors.white;
      secondPaint.style = PaintingStyle.stroke;
      secondPath.addOval(Rect.fromCircle(center: circlePos, radius: radius));
      canvas.drawPath(secondPath, secondPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MenuOverlay extends StatelessWidget {
  const MenuOverlay({
    Key? key,
    required this.anim,
    required this.startGame,
    required this.level,
    required this.constraints,
    required this.carPos,
  }) : super(key: key);

  final Animation anim;
  final VoidCallback startGame;
  final VoidCallback level;
  final BoxConstraints constraints;
  final double carPos;

  @override
  Widget build(BuildContext context) {
    final bool isVertical = constraints.maxWidth < constraints.maxHeight;
    final bool isMobile = constraints.maxWidth * 1.6 < constraints.maxHeight || !kIsWeb;
    final double animValue = anim.value;
    final TextStyle header = GoogleFonts.josefinSans(textStyle: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold));
    final TextStyle subheader =
        GoogleFonts.josefinSans(textStyle: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 30, fontWeight: FontWeight.w500));
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double circleRadius = isVertical ? constraints.maxWidth * 0.45 : constraints.maxHeight * 0.3;
    if (circleRadius > 0.75 * carPos) {
      circleRadius = 0.75 * carPos;
    }
    final Offset circlePos = isVertical
        ? Offset(screenWidth * 0.36, screenHeight - 0.94 * carPos)
        : screenWidth > 1000
            ? Offset(carPos + screenWidth * 0.1, screenHeight * 0.5)
            : Offset(carPos, screenHeight * 0.5);
    return Stack(
      alignment: Alignment.center,
      children: [
        //The starting menu overlay
        if (animValue != 1)
          Positioned(
            child: AnimatedBuilder(
                animation: anim,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                    painter: HolePainter(
                      animValue: animValue,
                      circlePos: circlePos,
                      radius: circleRadius,
                    ),
                  );
                }),
          ),

        //The start button and level button widget should only be shown while the game has not yet started
        if (animValue == 0)
          Positioned(
            left: isVertical ? circlePos.dx - circleRadius * 0.5 : circlePos.dx - circleRadius * 0.5,
            bottom: isVertical ? screenHeight - (circlePos.dy + circleRadius * 1.1) : screenHeight / 2 - circleRadius * 1.1,
            child: Row(
              children: [
                StartButton(
                  shadowColor: Colors.black.withOpacity(0.8),
                  title: "PLAY",
                  onPressed: startGame,
                  scaleFactor: isVertical ? 0.6 : 1,
                ),
                SizedBox(width: isVertical ? 12 : 20),
                // Level button is removed due to the fact that I did not see the need of another gameMode
                // LevelButton(
                //   onPressed: level,
                //   scaleFactor: isVertical ? 0.6 : 1,
                // ),
              ],
            ),
          ),

        //The description text in the main menu
        if (animValue == 0 && !isVertical && screenWidth > circlePos.dx + circleRadius + 100 * (screenWidth / 1600) + 540)
          Positioned(
            left: circlePos.dx + circleRadius + 100 * (screenWidth / 1600),
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Best", style: subheader),
                  const SizedBox(height: 16),
                  Text("125", style: header),
                  const SizedBox(height: 48),
                  Text("Objective", style: subheader),
                  const SizedBox(height: 16),
                  Text("Dodge the traffic and escape the police!", style: header),
                ],
              ),
            ),
          ),
        if (animValue == 0 && (isVertical || screenWidth < circlePos.dx + circleRadius + 100 * (screenWidth / 1600) + 400))
          Positioned(
            right: 30,
            top: 60,
            child: SizedBox(
              width: screenWidth * 0.7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Best", style: subheader),
                  const SizedBox(height: 6),
                  Text("125", style: header),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
