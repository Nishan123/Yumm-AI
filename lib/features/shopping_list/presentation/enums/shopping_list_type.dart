enum ShoppingListType {
  any,
  vegetable,
  fruit,
  protein,
  oil,
  drink,
  grain,
  dairy,
  spice,
  snack,
  bakery,
  none;

  String get text {
    switch (this) {
      case ShoppingListType.any:
        return "Any";
      case ShoppingListType.vegetable:
        return 'Vegetable';
      case ShoppingListType.fruit:
        return 'Fruit';
      case ShoppingListType.protein:
        return 'Protein';
      case ShoppingListType.oil:
        return 'Oil';
      case ShoppingListType.drink:
        return 'Drink';
      case ShoppingListType.grain:
        return 'Grain';
      case ShoppingListType.dairy:
        return 'Dairy';
      case ShoppingListType.spice:
        return 'Spice';
      case ShoppingListType.snack:
        return 'Snack';
      case ShoppingListType.bakery:
        return 'Bakery';
      case ShoppingListType.none:
        return 'None';
    }
  }

  String get value {
    switch (this) {
      case ShoppingListType.any:
        return 'any';
      case ShoppingListType.vegetable:
        return 'vegetable';
      case ShoppingListType.fruit:
        return 'fruit';
      case ShoppingListType.protein:
        return 'protein';
      case ShoppingListType.oil:
        return 'oil';
      case ShoppingListType.drink:
        return 'drink';
      case ShoppingListType.grain:
        return 'grain';
      case ShoppingListType.dairy:
        return 'dairy';
      case ShoppingListType.spice:
        return 'spice';
      case ShoppingListType.snack:
        return 'snack';
      case ShoppingListType.bakery:
        return 'bakery';
      case ShoppingListType.none:
        return 'n/a';
    }
  }
}
