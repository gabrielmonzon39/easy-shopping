import 'package:easy_shopping/model/category_items.dart';
import 'package:easy_shopping/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CategoryItemCardWidget extends StatelessWidget {
  final CategoryItem? item;
  final height = 200.0;
  final width = 175.0;
  final Color borderColor = const Color(0xffE2E2E2);
  final double borderRadius = 18;
  final Color color;

  const CategoryItemCardWidget({Key? key, this.item, this.color = Colors.blue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.7),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: iconWidget(),
          ),
          SizedBox(
            height: 80,
            child: Center(
              child: AppText(
                text: item?.name,
                textAlign: TextAlign.center,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget iconWidget() {
    return Icon(
      getIcon(),
      size: 45,
    );
  }

  IconData getIcon() {
    switch (item!.icon!) {
      case "1":
        return Icons.add;
      case "2":
        return Icons.local_grocery_store;
      case "3":
        return Icons.monetization_on;
      case "4":
        return Icons.info;
      default:
        return Icons.close;
    }
  }
}
