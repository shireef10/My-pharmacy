import 'package:flutter/material.dart';
import 'package:my_pharmacy/CategoriesData.dart';
import 'detailsText.dart';

class CategoriesItems extends StatelessWidget {
  CategoriesData categories;

  CategoriesItems(this.categories);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => detailsText(categories.webLink)));
      },
      child: Container(
        margin: EdgeInsets.all(2),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(categories.ImagePath),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                margin: EdgeInsets.all(8),
                color: Color.fromARGB(100, 0, 5, 0),
                child: Text(
                  categories.Name,
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
