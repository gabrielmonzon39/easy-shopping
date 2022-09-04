class CategoryItem {
  final int? id;
  final String? name;
  final String? icon;

  CategoryItem({this.id, this.name, this.icon});
}

var categoryItemsDemo = [
  CategoryItem(
    name: "Ingresar producto",
    icon: "1",
  ),
  CategoryItem(
    name: "Mis productos",
    icon: "2",
  ),
  CategoryItem(
    name: "Mis ventas",
    icon: "3",
  ),
  CategoryItem(
    name: "Información",
    icon: "4",
  ),
];
