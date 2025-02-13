enum NavigationRoute {
  mainRoute("/"),
  detailRoute("/detail"),
  settingRoute("/setting");

  const NavigationRoute(this.name);
  final String name;
}
