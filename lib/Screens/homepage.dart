import "package:flutter/material.dart";
import 'package:indexa/Screens/screensPerfil/perfil.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../widgets/homeScreenWidget.dart';
import '../widgets/navBar.dart';
import 'carrito/carrito.dart';
import 'favorites/favoritesScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final screens = [
    const HomeWidget(),
    const FavoriteScreen(),
    const Carrito(),
    const Perfil(),
  ];

  int _currentindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEF2FF),
        drawer: drawer(context),
        body: screens[_currentindex],
        bottomNavigationBar: SalomonBottomBar(
          unselectedItemColor: const Color(0xFF233142),
          currentIndex: _currentindex,
          onTap: (i) {
            setState(() {
              _currentindex = i;
            });
          },
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: Colors.purple,
            ),

            /// favoritos
            SalomonBottomBarItem(
              icon: const Icon(Icons.favorite_border),
              title: const Text("Favorites"),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.shopping_bag_sharp),
              title: const Text("My cart"),
              selectedColor: Colors.pink,
            ),

            /// perfil
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
              selectedColor: Colors.teal,
            ),
          ],
        ));
  }
}
