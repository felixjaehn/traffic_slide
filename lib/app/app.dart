import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:traffic_slide/services/game_service.dart';
import 'package:traffic_slide/services/level_service.dart';

import '../views/game_view/game_view.dart';

@StackedApp(
  routes: [
    CupertinoRoute(page: GameView, initial: true),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: GameService),
    LazySingleton(classType: LevelService),
  ],
)
class AppSetup {}
