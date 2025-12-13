import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

enum Meal {
  anything,
  breakfast,
  dinner,
  mainCourse,
  snacks,
  dessert,
  hardDrink,
  softDrink;

  String get text {
    switch (this) {
      case Meal.anything:
        return "Anything";
      case Meal.breakfast:
        return "Breakfast";
      case Meal.dinner:
        return "Dinner";
      case Meal.mainCourse:
        return "Main Course";
      case Meal.snacks:
        return "Snacks";
      case Meal.dessert:
        return "Dessert";
      case Meal.hardDrink:
        return "Hard Drinks";
      case Meal.softDrink:
        return "Soft Drinks";
    }
  }

  String get value {
    switch (this) {
      case Meal.anything:
        return "anything";
      case Meal.breakfast:
        return "breakfast";
      case Meal.dinner:
        return "dinner";
      case Meal.mainCourse:
        return "main Course";
      case Meal.snacks:
        return "snacks";
      case Meal.dessert:
        return "dessert";
      case Meal.hardDrink:
        return "hard Drinks";
      case Meal.softDrink:
        return "soft Drinks";
    }
  }

  IconData get icon {
    switch (this) {
      case Meal.anything:
        return LucideIcons.soup;
      case Meal.breakfast:
        return LucideIcons.egg_fried;
      case Meal.dinner:
        return LucideIcons.ham;
      case Meal.mainCourse:
        return LucideIcons.beef;
      case Meal.snacks:
        return LucideIcons.hamburger;
      case Meal.dessert:
        return LucideIcons.cake;
      case Meal.hardDrink:
        return LucideIcons.bottle_wine;
      case Meal.softDrink:
        return LucideIcons.martini;
    }
  }
}