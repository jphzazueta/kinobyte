import 'package:flutter/material.dart';

class InfoField extends StatelessWidget {

  final double bottomPadding;
  final String fieldName;
  final String fieldData;

  const InfoField({
    super.key,
    this.bottomPadding = 2,
    required this.fieldName,
    required this.fieldData
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: RichText(text: 
        TextSpan(
          style: const TextStyle(
            color: Colors.white,
          ),
          children: [
            TextSpan(text: '$fieldName: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[300],
                fontSize: 13,
            )),
            TextSpan(text: fieldData,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 13,
            ))
          ]
        )
      ),
    );
  }
}