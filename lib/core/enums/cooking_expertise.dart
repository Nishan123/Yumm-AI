import 'package:flutter/material.dart';

enum CookingExpertise {
  newBie,
  canCook,
  expert;

  String get text {
    switch (this) {
      case CookingExpertise.newBie:
        return "Newbie";
      case CookingExpertise.canCook:
        return "Can Cook";
      case CookingExpertise.expert:
        return "Expert";
    }
  }

  String get value {
    switch (this) {
      case CookingExpertise.newBie:
        return "newBie";
      case CookingExpertise.canCook:
        return "canCook";
      case CookingExpertise.expert:
        return "expert";
    }
  }

  Color get color {
    switch (this) {
      case CookingExpertise.newBie:
        return Colors.green;
      case CookingExpertise.canCook:
        return Colors.blue;
      case CookingExpertise.expert:
        return Colors.red;
    }
  }
}
