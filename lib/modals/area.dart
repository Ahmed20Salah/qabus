class Area {
  final String name;
  final String nameAr;
  final int id;

  Area({this.id, this.name, this.nameAr})
      : assert(id != null),
        assert(name != null),
        assert(nameAr != null);
}
