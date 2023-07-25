import 'dart:math';

class MockDataRepository {
  Future<String> getMessage() async {
    Random random = Random();
    int randomNumber = random.nextInt(11);
    await Future.delayed(const Duration(seconds: 3));
    return Future(() => randomNumber > 5
        ? 'Весьма вероятно'
        : 'Весьма сомнительно'
    );
  }
}