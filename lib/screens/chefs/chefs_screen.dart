import 'package:flutter/material.dart';
import 'package:yumm_ai/screens/chefs/widgets/chef_card_widget.dart';

class ChefsScreen extends StatelessWidget {
  const ChefsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select your desired chef")),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: Column(
          children: [
            Divider(),
            SizedBox(height: 20),
            ChefCardWidget(
              suffixImage: "",
              backgroundImage: "",
              onTap: () {},
              title: "Something Chef",
              description:
                  "Scan inside your fridge to prepare\nthe combination of available\nitems "
                  "",
            ),
          ],
        ),
      ),
    );
  }
}
