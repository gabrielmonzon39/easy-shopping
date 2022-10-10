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

var deliveryManItemsDemo = [
  CategoryItem(
    name: "Órdenes por entregar",
    icon: "1",
  ),
  CategoryItem(
    name: "Órdenes activas",
    icon: "2",
  ),
  CategoryItem(
    name: "Historial de órdenes entregadas",
    icon: "3",
  ),
  CategoryItem(
    name: "Notificaciones",
    icon: "4",
  ),
];

var superAdminItemsDemo = [
  CategoryItem(
    name: "Nuevo Proyecto",
    icon: "1",
  ),
  CategoryItem(
    name: "Generar Project Manager",
    icon: "1",
  ),
];

var projectManagerItemsDemo = [
  CategoryItem(
    name: "Nueva Tienda",
    icon: "1",
  ),
  CategoryItem(
    name: "Generar Store Manager",
    icon: "1",
  ),
];
