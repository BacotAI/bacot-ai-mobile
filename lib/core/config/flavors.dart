enum Flavor { dev, uat, prod }

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Tulkun dev';
      case Flavor.uat:
        return 'Tulkun uat';
      case Flavor.prod:
        return 'Tulkun';
    }
  }
}
