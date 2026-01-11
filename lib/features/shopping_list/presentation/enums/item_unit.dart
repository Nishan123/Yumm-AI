enum ItemUnit {
  piece,
  pack,
  kg,
  grams,
  pounds,
  ounces,
  ltr,
  ml,
  gallon,
  cup,
  tsp;

  String get text {
    switch (this) {
      case ItemUnit.piece:
        return "Piece";
      case ItemUnit.pack:
        return "Pack";
      case ItemUnit.kg:
        return "Kilogram";
      case ItemUnit.grams:
        return "Grams";
      case ItemUnit.pounds:
        return "Pounds";
      case ItemUnit.ounces:
        return "Ounces";
      case ItemUnit.ltr:
        return "Liter";
      case ItemUnit.ml:
        return "Milliliter";
      case ItemUnit.gallon:
        return "Gallon";
      case ItemUnit.cup:
        return "Cup";
      case ItemUnit.tsp:
        return "Teaspoon";
    }
  }
}
