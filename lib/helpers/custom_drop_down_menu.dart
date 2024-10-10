import 'package:flutter/material.dart';

class AddMovieDropdown extends StatelessWidget {
  final String hintText;
  final List<DropdownMenuEntry> entries;
  final void Function(dynamic) onSelectedFunction;

  const AddMovieDropdown({
    super.key,
    required this.hintText,
    required this.entries,
    required this.onSelectedFunction,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      hintText: 'Select',
      menuStyle: const MenuStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 23, 23, 70),),),
      textStyle: const TextStyle(color: Colors.white,),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.white),
        constraints: BoxConstraints.tight(const Size.fromHeight(60)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        )
      ),
      dropdownMenuEntries: entries,
      onSelected: onSelectedFunction,
    );
  }
}
