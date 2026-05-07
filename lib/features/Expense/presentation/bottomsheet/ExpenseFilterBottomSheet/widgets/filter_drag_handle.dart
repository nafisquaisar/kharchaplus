import 'package:flutter/material.dart';

class FilterDragHandle
    extends StatelessWidget {

  const FilterDragHandle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Center(

      child: Container(

        height: 5,
        width: 52,

        decoration: BoxDecoration(

          color: Colors.grey.shade300,

          borderRadius:
          BorderRadius.circular(100),
        ),
      ),
    );
  }
}
