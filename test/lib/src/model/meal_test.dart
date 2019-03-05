import 'package:test/test.dart';
import 'package:bsc/src/model/meal.dart';

void main() {
  final mockUID = "e48bd850a0134e96b25de6432114a134";
  final menuList = ['pizza', 'tuna', 'cheese'];
  final mockMealData = new Map<String, dynamic>.from({
    'start_time': "2019-02-27T12:05:46.173",
    'end_time': "2019-02-27T12:05:58.478",
    'menu': menuList,
  });
  group('Meal -', () {
    test('fromFirebase factory produces accurate model file', () {
      Meal testMeal = new Meal.fromFirebase(mockMealData, id: "testID");

      expect(testMeal.startTime.toIso8601String(), mockMealData['start_time']);
      expect(testMeal.endTime.toIso8601String(), mockMealData['end_time']);
      expect(testMeal.menu.toList(), menuList);
    });

    test('toFirebase function produces a properly formatted map of data', () {
      Meal testMeal = new Meal.fromFirebase(mockMealData, id: "testID");
      Map<String, dynamic> output = testMeal.toFirestore();
      expect(mockMealData, output);
    });
  });
}
