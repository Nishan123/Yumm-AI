import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class PurchasePremiumCard extends StatelessWidget {
  const PurchasePremiumCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18,vertical: 12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.whiteColor,width: 3),
        boxShadow: [BoxShadow(color: AppColors.shadowColor,spreadRadius: 1,blurRadius: 8)],
      ),
      child: Column(children: [
        Text("Hello"),
        ElevatedButton(onPressed: (){},child: Text("Hello"),)
      ],),
    );
  }
}
