import 'package:flutter/material.dart';

class ToolsList extends StatelessWidget {
  const ToolsList({super.key, this.scrollController, this.isActive = true});

  final ScrollController? scrollController;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: isActive ? scrollController : null,
      physics: isActive
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          width: MediaQuery.of(context).size.width,
          child: const Text("Tool one"),
        );
      },
    );
  }
}
