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

  // Padding movieField(String fieldName, String fieldData) {   // For displaying field with the name bold and the data normal weight
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 3.0),
  //     child: RichText(text: 
  //       TextSpan(
  //         style: const TextStyle(
  //           color: Colors.white,
  //         ),
  //         children: [
  //           TextSpan(text: '$fieldName: ',
  //             style: const TextStyle(
  //               fontWeight: FontWeight.bold,
  //             )),
  //           TextSpan(text: fieldData)])),
  //   );
  // } 

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