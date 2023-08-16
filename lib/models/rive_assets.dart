import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(this.src,
      {required this.artboard,
      required this.stateMachineName,
      required this.title});

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAsset> sideMenus = [
  RiveAsset("assets/icons/little-icons.riv",
      artboard: "HOME",
      stateMachineName: "HOME_interactivity",
      title: "Eventos y zonas"),
  RiveAsset("assets/icons/little-icons.riv",
      artboard: "REFRESH/RELOAD",
      stateMachineName: "RELOAD_Interactivity",
      title: "Registro de Invitados"),
  RiveAsset("assets/icons/little-icons.riv",
      artboard: "USER",
      stateMachineName: "USER_Interactivity",
      title: "Listado de Invitados")
];

List<RiveAsset> sideMenus2 = [
  RiveAsset("assets/icons/little-icons.riv",
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity",
      title: "Consulta"),
  RiveAsset("assets/icons/little-icons.riv",
      artboard: "LIKE/STAR",
      stateMachineName: "STAR_Interactivity",
      title: "Ingresos/Salidas"),
];
List<RiveAsset> sideMenus3 = [
  RiveAsset(
    "assets/icons/little-icons.riv",
    artboard: "TIMER",
    stateMachineName: "TIMER_Interactivity",
    title: "Historial de eventos",
  ),
  
];


