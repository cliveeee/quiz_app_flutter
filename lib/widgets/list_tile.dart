import 'package:flutter/material.dart';

enum AnswerType { radio, checkbox }

class AnswerTile extends StatelessWidget {
  final String answerText;
  final bool isSelected;
  final void Function(bool?)? onChanged;
  final AnswerType answerType;

  const AnswerTile({
    Key? key,
    required this.answerText,
    required this.isSelected,
    required this.onChanged,
    required this.answerType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Toggle the selection when the tile is tapped
        if (answerType == AnswerType.radio) {
          onChanged!(true); // Select this radio button
        } else {
          onChanged!(isSelected ? false : true); // Toggle checkbox
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.deepPurple
              : Colors.white, // Default white, change to purple when selected
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.deepPurple, // Purple border
            width: 2.0,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          leading: answerType == AnswerType.radio
              ? Radio<bool>(
                  value: true, // This value indicates the selected state
                  groupValue: isSelected
                      ? true
                      : null, // Set groupValue to null if no answer is selected
                  onChanged: onChanged,
                  activeColor: Colors.white, // White color for selected radio button
                )
              : Checkbox(
                  value: isSelected,
                  onChanged: onChanged,
                  activeColor: Colors.white, // White color for selected checkbox
                ),
          title: Text(
            answerText,
            style: TextStyle(
              fontSize: 16,
              color: isSelected
                  ? Colors.white
                  : Colors.black, // Default black, change to white when selected
            ),
          ),
        ),
      ),
    );
  }
}
