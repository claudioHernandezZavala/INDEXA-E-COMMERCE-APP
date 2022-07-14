import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../backend/authServices.dart';
import '../../bounciPageRoute.dart';
import '../../constants.dart';
import '../../widgets/leavesFall.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController eController = TextEditingController();
  TextEditingController pController = TextEditingController();
  // late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _controller = VideoPlayerController.asset("assets/video.mp4")
    //   ..initialize().then((value) {
    //     _controller.play();
    //     _controller.setVolume(0);
    //     _controller.setLooping(true);
    //     setState(() {});
    //   });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _controller.pause();
    // _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // VideoPlayer(_controller),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Image.asset(
                    "assets/loginpic.png",
                    width: width * 0.7,
                    height: height * 0.3,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Container(
                      width: width * 0.8,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: color1.withOpacity(0.9),
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SingleChildScrollView(
                        child: Stack(
                          children: [
                            const LeavesContainer(),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Bienvenid@",
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.oswald(fontSize: 30),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: TextFormField(
                                    controller: eController,
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                      focusColor: Colors.green,
                                      fillColor: Colors.grey.withOpacity(0.3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Colors.green, width: 3),
                                      ),
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 3),
                                          gapPadding: 15),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: TextFormField(
                                    controller: pController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      focusColor: Colors.green,
                                      fillColor: Colors.grey.withOpacity(0.3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Colors.green, width: 3),
                                      ),
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 3),
                                          gapPadding: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextButton.icon(
                                    onPressed: () {
                                      firebaseSignUp(eController.text,
                                          pController.text, context);
                                    },
                                    style: ButtonStyle(
                                        minimumSize:
                                            MaterialStateProperty.all<Size?>(
                                                Size(width * 0.6, 35)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color?>(
                                                color3)),
                                    icon: Icon(
                                      Icons.lock_open,
                                      color: color1,
                                    ),
                                    label: const Text(
                                      "Registrarse",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "O registrate con google",
                                  style: height <= 700
                                      ? Theme.of(context).textTheme.bodySmall
                                      : Theme.of(context).textTheme.bodyMedium,
                                ),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: color3),
                                    child: IconButton(
                                        onPressed: () {
                                          //_controller.pause();
                                          // _controller.dispose();
                                          googleSignIn(context);
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.google,
                                          color: Colors.white,
                                        ))),
                                TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          BouncyPageRoute(
                                              const RegisterPage()));
                                    },
                                    style: ButtonStyle(
                                        minimumSize:
                                            MaterialStateProperty.all<Size?>(
                                                Size(width * 0.6, 35)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color?>(
                                                color3)),
                                    icon: Icon(
                                      Icons.assignment_ind_sharp,
                                      color: color1,
                                    ),
                                    label: const Text(
                                      "Iniciar sesion",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
