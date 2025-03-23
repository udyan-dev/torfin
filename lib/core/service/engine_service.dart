import '../../src/data/model/engine/engine.dart';

class EngineService {
  final Engine engine;

  EngineService({required this.engine});

  Future<void> start() async {
    try {
      await engine.init();
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await engine.dispose();
    } catch (_) {}
  }
}
