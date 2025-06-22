

import '../models/menu_item.dart';

final List<MenuItem> mockMenuItems = [
  MenuItem(
    id: '1',
    name: 'ブレンドコーヒー',
    description: '厳選された豆をブレンドした、深みとコクのある一杯。',
    price: 380,
    imageUrl: 'assets/menus/blended_coffee.png',
    category: 'コーヒー',
  ),
  MenuItem(
    id: '2',
    name: 'カフェラテ',
    description: 'エスプレッソとミルクの絶妙なハーモニー。',
    price: 450,
    imageUrl: 'assets/menus/cafe_latte.png',
    category: 'コーヒー',
  ),
  MenuItem(
    id: '3',
    name: 'カプチーノ',
    description: 'ふわふわの泡立ちが特徴の、優しい味わい。',
    price: 450,
    imageUrl: 'assets/menus/cappuccino.png',
    category: 'コーヒー',
  ),
  MenuItem(
    id: '4',
    name: 'アメリカンコーヒー',
    description: 'すっきりとした味わいで、どんなシーンにも合う。',
    price: 380,
    imageUrl: 'assets/menus/american_coffee.png',
    category: 'コーヒー',
  ),
  MenuItem(
    id: '5',
    name: 'エスプレッソ',
    description: 'コーヒーの旨味が凝縮された、濃厚な一杯。',
    price: 300,
    imageUrl: 'assets/menus/espresso.png',
    category: 'コーヒー',
  ),
  MenuItem(
    id: '6',
    name: '抹茶ラテ',
    description: '抹茶の風味豊かな、和風ラテ。',
    price: 500,
    imageUrl: 'assets/menus/matcha_latte.png',
    category: 'コーヒー', // This is categorized as coffee in the issue. It could also be tea. For now, I'll stick to the issue's categorization.
  ),
  MenuItem(
    id: '7',
    name: 'クリームパスタ',
    description: '濃厚クリームソースのパスタ。',
    price: 700,
    imageUrl: 'assets/menus/cream_pasta.png',
    category: 'パスタ',
  ),
  MenuItem(
    id: '8',
    name: 'タマゴサンド',
    description: 'ふわふわタマゴのサンドイッチ。',
    price: 550,
    imageUrl: 'assets/menus/egg_sandwich.png',
    category: 'サンドイッチ',
  ),
  MenuItem(
    id: '9',
    name: '紅茶',
    description: '香り高いアールグレイティー。',
    price: 350,
    imageUrl: 'assets/menus/black_tea.png',
    category: 'お茶',
  ),
];

