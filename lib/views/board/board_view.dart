import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:traffic_slide/models/moving_car.dart';

import 'board_viewmodel.dart';

class BoardView extends StatefulWidget {
  const BoardView({Key? key, required this.isVertical, required this.tileSize, this.isMobile = false}) : super(key: key);

  final bool isVertical;
  final double tileSize;
  final bool isMobile;

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> with TickerProviderStateMixin {
  @override
  Widget build(context) {
    return ViewModelBuilder<BoardViewModel>.reactive(
      onModelReady: (model) => model.setUp(this),
      builder: (context, model, child) {
        if (model.controller.length != model.cars.length) {
          model.setUpController(this);
        }
        double tileSize = widget.tileSize;
        List<int> index = List.generate(model.cars.length, (i) => i);
        return Transform.rotate(
          angle: widget.isVertical ? -pi / 2 : 0,
          child: SizedBox.square(
            dimension: (6 * tileSize) + 4,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 6 * tileSize + 4,
                  height: 6 * tileSize + 4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    height: 6 * tileSize,
                    width: 6 * tileSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: GridView.count(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        crossAxisCount: 6,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          6 * 6,
                          (index) => Container(
                            height: tileSize,
                            width: tileSize,
                            //Creates a checkboard pattern
                            color: (index + (index ~/ 6)) % 2 == 0 ? Colors.blue[200] : Colors.blue[100],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox.square(
                  dimension: 6 * tileSize,
                  child: Stack(
                    children: index.map(
                      (i) {
                        return CarWidget(
                          tileSize: tileSize,
                          isVertical: widget.isVertical,
                          car: model.cars[i],
                          onDragUpdate: (car, details, height, width) => model.moveCar(car, details, height, width, i, widget.isMobile && kIsWeb),
                          onDragEnd: (details, car) => model.onDragEnd(details, car, i),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => BoardViewModel(),
    );
  }
}

class CarWidget extends StatelessWidget {
  const CarWidget({
    Key? key,
    required this.car,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.isVertical,
    required this.tileSize,
  }) : super(key: key);

  final MovingCar car;
  final bool isVertical;
  final double tileSize;
  final Function(MovingCar car, DragUpdateDetails details, double renderBoxHeight, double renderBoxWidth) onDragUpdate;
  final Function(DragEndDetails details, MovingCar car) onDragEnd;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: car.top * tileSize,
      left: car.left * tileSize,
      child: GestureDetector(
        onPanUpdate: (details) => onDragUpdate(car, details, context.size?.height ?? 1000, context.size?.width ?? 1000),
        onPanEnd: (details) => onDragEnd(details, car),
        child: car.direction == Axis.horizontal
            ? Container(
                height: tileSize,
                width: car.length * tileSize,
                decoration: BoxDecoration(image: _getImage(car.assetIndex, car.direction, car.length)),
              )
            : Container(
                width: tileSize,
                height: car.length * tileSize,
                decoration: BoxDecoration(image: _getImage(car.assetIndex, car.direction, car.length)),
              ),
      ),
    );
  }

  DecorationImage? _getImage(int random, Axis axis, int length) {
    if (length == 3 && axis == Axis.vertical) {
      return const DecorationImage(image: AssetImage("assets/lkw_vert.webp"), fit: BoxFit.contain);
    } else if (length == 3 && axis == Axis.horizontal) {
      return const DecorationImage(image: AssetImage("assets/lkw_hor.webp"), fit: BoxFit.contain);
    } else if (length == 2 && axis == Axis.vertical) {
      int i = random % 3; //With 4 being the number of options
      switch (i) {
        case 0:
          return const DecorationImage(image: AssetImage("assets/black_car_vert.webp"), fit: BoxFit.contain);
        case 1:
          return const DecorationImage(image: AssetImage("assets/red_car_vert.webp"), fit: BoxFit.contain);
        case 2:
          return const DecorationImage(image: AssetImage("assets/yellow_car_vert.webp"), fit: BoxFit.contain);
      }
    } else if (length == 2 && axis == Axis.horizontal) {
      int i = random % 3; //With 4 being the number of options
      switch (i) {
        case 0:
          return const DecorationImage(image: AssetImage("assets/black_car_hor.webp"), fit: BoxFit.contain);
        case 1:
          return const DecorationImage(image: AssetImage("assets/red_car_hor.webp"), fit: BoxFit.contain);
        case 2:
          return const DecorationImage(image: AssetImage("assets/yellow_car_hor.webp"), fit: BoxFit.contain);
      }
    }
    return null;
  }
}
