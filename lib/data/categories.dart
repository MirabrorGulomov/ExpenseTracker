import 'package:flutter/material.dart';
import '../models/category.dart';

final categories = {
  Categories.transport: const Category(
    icon: Icons.directions_car,
    title: "Transport",
    image: AssetImage(
      "assets/images/taxi2.png",
    ),
  ),
  Categories.food: const Category(
    icon: Icons.local_dining,
    title: "Food",
    image: AssetImage(
      "assets/images/food3-removebg-preview.png",
    ),
  ),
  Categories.shopping: const Category(
    icon: Icons.shopping_cart,
    title: "Shopping",
    image: AssetImage(
      "assets/images/shopping-removebg-preview.png",
    ),
  ),
  Categories.health: const Category(
    icon: Icons.favorite,
    title: "Health",
    image: AssetImage(
      "assets/images/health.png",
    ),
  ),
  Categories.lending: const Category(
    icon: Icons.attach_money,
    title: "Lending",
    image: AssetImage(
      "assets/images/lending.png",
    ),
  ),
  Categories.borrowing: const Category(
    icon: Icons.money_off,
    title: "Borrowing",
    image: AssetImage(
      "assets/images/borrowing-removebg-preview.png",
    ),
  ),
  Categories.personal: const Category(
    icon: Icons.person,
    title: "Personal",
    image: AssetImage(
      "assets/images/person.png",
    ),
  ),
  Categories.family: const Category(
    icon: Icons.family_restroom,
    title: "Family",
    image: AssetImage(
      "assets/images/familyy.png",
    ),
  ),
};
