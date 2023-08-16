// ignore_for_file: file_names
import 'package:eventos/components/infoCard.dart';
import 'package:eventos/components/side_menu_tile.dart';
import 'package:eventos/models/rive_assets.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../Utils/rive_utils.dart';

class SideMenu extends StatefulWidget {
  final Widget currentWidget;
  final Function(RiveAsset) onSelectMenu;
  final String widget;
  const SideMenu(
      {super.key,
      required this.currentWidget,
      required this.onSelectMenu,
      required this.widget});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  RiveAsset selectMenu = sideMenus.first;
  RiveAsset selectMenu2 = sideMenus2.first;
  RiveAsset selectMenu3 = sideMenus3.first;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: const Color.fromRGBO(1, 116, 211, 1),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                name: widget.widget,
                profesion: 'BIENVENIDO',
              ),
              const SizedBox(
                height: 30,
              ),
              ...sideMenus.map(
                (menu) => SideMenuTile(
                  menu: menu,
                  riveonInit: (artboard) {
                    StateMachineController controller =
                        RiveUtils.getRiveController(artboard,
                            stateMachineName: menu.stateMachineName);
                    menu.input = controller.findSMI("active") as SMIBool;
                  },
                  press: () {
                    menu.input!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      menu.input!.change(false);
                    });
                    setState(() {
                      selectMenu = menu;
                      widget.onSelectMenu(menu);
                    });
                  },
                  isActive: selectMenu == menu,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Acciones".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sideMenus2.map(
                (menu) => SideMenuTile(
                  menu: menu,
                  riveonInit: (artboard) {
                    StateMachineController controller =
                        RiveUtils.getRiveController(artboard,
                            stateMachineName: menu.stateMachineName);
                    menu.input = controller.findSMI("active") as SMIBool;
                  },
                  press: () {
                    menu.input!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      menu.input!.change(false);
                    });
                    setState(() {
                      selectMenu = menu;
                      widget.onSelectMenu(menu);
                    });
                  },
                  isActive: selectMenu == menu,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Historial".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sideMenus3.map(
                (menu) => SideMenuTile(
                  menu: menu,
                  riveonInit: (artboard) {
                    StateMachineController controller =
                        RiveUtils.getRiveController(artboard,
                            stateMachineName: menu.stateMachineName);
                    menu.input = controller.findSMI("active") as SMIBool;
                  },
                  press: () {
                    menu.input!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      menu.input!.change(false);
                    });
                    setState(() {
                      selectMenu = menu;
                      widget.onSelectMenu(menu);
                    });
                  },
                  isActive: selectMenu == menu,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: TextButton(
                    onPressed: (){
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255)
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.white,size: 30,),
                        SizedBox(width: 10,),
                        Text("Cerrar Session",style: TextStyle(color: Colors.white, fontSize: 18),)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
