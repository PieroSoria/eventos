import 'dart:math';

import 'package:eventos/Utils/rive_utils.dart';
import 'package:eventos/components/side_menu.dart';
import 'package:eventos/models/menu_btn.dart';
import 'package:eventos/models/rive_assets.dart';
import 'package:eventos/page/consulta.dart';
import 'package:eventos/page/eventosyzonas.dart';
import 'package:eventos/page/historialdeeventos.dart';
import 'package:eventos/page/importar.dart';
import 'package:eventos/page/ingresoysalidas.dart';
import 'package:eventos/page/invitados.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Index extends StatefulWidget {
  final String user;
  const Index({super.key, required this.user});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> with SingleTickerProviderStateMixin {
  late Widget _currentWidget;
  late SMIBool isSideBarClose;
  bool isSideMenuClose = true;
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scalAnimation;
  late RiveAsset selectMenu;
  late RiveAsset selectMenu2;
  late RiveAsset selectMenu3;
  


  void comprobacion() {}

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    _currentWidget = EventosyZonas(widget: widget,);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(1, 116, 211, 1),
      extendBody: true,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClose ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: SideMenu(
              currentWidget: _currentWidget,
              widget: widget.user,
              onSelectMenu: (menu) {
                setState(() {
                  selectMenu = menu;
                  if (selectMenu == sideMenus.first) {
                    _currentWidget = EventosyZonas(widget: widget);
                  }else if (selectMenu == sideMenus[1]) {
                    _currentWidget = Importar(widget: widget,);
                  }else if (selectMenu == sideMenus[2]) {
                    _currentWidget = const Invitados();
                  }
                });
                setState(() {
                  selectMenu2 = menu;
                  if (selectMenu2 == sideMenus2.first) {
                    _currentWidget = Consulta(widget: widget,);
                  } else if (selectMenu2 == sideMenus2[1]) {
                    _currentWidget = IngresoySalidas(widget: widget,);
                  }
                });
                setState(() {
                  selectMenu3 = menu;
                  if (selectMenu3 == sideMenus3.first) {
                    _currentWidget = Historial(widget: widget,);
                  }
                });
              },
            ),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation.value - 30 * animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  child: _currentWidget,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideMenuClose ? 0 : 220,
            top: 16,
            child: MenuBtn(
              riveonInit: (artboard) {
                StateMachineController controller = RiveUtils.getRiveController(
                    artboard,
                    stateMachineName: "State Machine");
                isSideBarClose = controller.findSMI("isOpen") as SMIBool;
                isSideBarClose.value = true;
              },
              press: () {
                isSideBarClose.value = !isSideBarClose.value;
                if (isSideMenuClose) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
                setState(() {
                  isSideMenuClose = isSideBarClose.value;
                });
              },
            ),
          ),
        ],
      ),
      
    );
  }
}
