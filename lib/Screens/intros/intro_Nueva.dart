import 'package:flutter/material.dart';
import 'package:indexa/Screens/homepage.dart';
import 'package:indexa/bounciPageRoute.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';

import '../../constants.dart';

class IntroSlides extends StatefulWidget {
  const IntroSlides({Key? key}) : super(key: key);

  @override
  State<IntroSlides> createState() => _IntroSlidesState();
}

class _IntroSlidesState extends State<IntroSlides> {
  final List<Introduction> list = [
    Introduction(
      title: 'Explora y cotiza',
      subTitle: 'Busca tus productos favoritos y cotiza rapido y sencillo',
      imageUrl: 'assets/registerpic2.png',
    ),
    Introduction(
      title: 'Mantente al tanto.',
      subTitle: 'Recibe notificaciones de actualizaciones.',
      imageUrl: 'assets/registerpic3.png',
    ),
    Introduction(
      title: 'Estado de cotiza\nen tiempo real!',
      subTitle: 'Sin necesidad de llamadas o correos',
      imageUrl: 'assets/sprinting.gif',
    ),
    Introduction(
      title: 'Disfruta la experiencia de\nINDEXA',
      subTitle: 'Echa un vistazo a nuestros productos',
      imageUrl: 'assets/loginpic.png',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      backgroudColor: Colors.white,
      introductionList: list,
      foregroundColor: color3,
      onTapSkipButton: () {
        Navigator.of(context)
            .pushAndRemoveUntil(BouncyPageRoute(HomePage()), (route) => false);
      },
    );
  }
}
