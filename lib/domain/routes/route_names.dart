class RouteNameAndPathContainer {
  final String path;
  final String name;
  RouteNameAndPathContainer({required this.name,required this.path});
}

mixin RouteNames {
  static RouteNameAndPathContainer home = RouteNameAndPathContainer(name: 'home',path: '/');
  static RouteNameAndPathContainer errorScreen = RouteNameAndPathContainer(name: 'errorScreen',path: '/error_screen');

}
