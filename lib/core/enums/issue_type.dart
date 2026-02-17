import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

enum IssueType {
  aiChef,
  scanner,
  aiImageGenerator,
  passwords,
  cooking,
  cookbook,
  search,
  shoppingList,
  others;

  String get text {
    switch (this) {
      case IssueType.aiChef:
        return "AI Chef";
      case IssueType.scanner:
        return "Scanner";
      case IssueType.aiImageGenerator:
        return "AI Image Gen";
      case IssueType.passwords:
        return "Passwords";
      case IssueType.cooking:
        return "Cooking";
      case IssueType.cookbook:
        return "Cookbook";
      case IssueType.search:
        return "Search";
      case IssueType.shoppingList:
        return "Shopping List";
      case IssueType.others:
        return "Others";
    }
  }

  String get value {
    switch (this) {
      case IssueType.aiChef:
        return "ai_chef";
      case IssueType.scanner:
        return "scanner";
      case IssueType.aiImageGenerator:
        return "ai_image_generator";
      case IssueType.passwords:
        return "passwords";
      case IssueType.cooking:
        return "cooking";
      case IssueType.cookbook:
        return "cookbook";
      case IssueType.search:
        return "search";
      case IssueType.shoppingList:
        return "shopping_list";
      case IssueType.others:
        return "others";
    }
  }

  IconData get icon {
    switch (this) {
      case IssueType.aiChef:
        return LucideIcons.chef_hat;
      case IssueType.scanner:
        return LucideIcons.scan_line;
      case IssueType.aiImageGenerator:
        return LucideIcons.image;
      case IssueType.passwords:
        return LucideIcons.lock;
      case IssueType.cooking:
        return LucideIcons.utensils;
      case IssueType.cookbook:
        return LucideIcons.book_open;
      case IssueType.search:
        return LucideIcons.search;
      case IssueType.shoppingList:
        return LucideIcons.shopping_cart;
      case IssueType.others:
        return LucideIcons.bug;
    }
  }
}
