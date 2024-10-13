// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kino_byte/helpers/enums.dart';
import 'package:kino_byte/services/databaseService.dart';
import 'package:kino_byte/helpers/custom_drop_down_menu.dart';

// Custom class for the pop-up that shows when selecting an option from SpeedDial
class CustomAlertDialog extends StatefulWidget {
  final ValueKey valueKey;
  final DatabaseService databaseService;
  final Map<String, dynamic> movieDetails;
  final int selectedDateTime;
  Platform? selectedPlatform;
  ScreenType? selectedScreenType;
  Location? selectedLocation;
  MovieLanguage? selectedAudioLanguage;
  MovieLanguage? selectedSubstitlesLanguage;

  CustomAlertDialog({
    super.key,
    required this.valueKey,
    required this.databaseService,
    required this.movieDetails,
    required this.selectedDateTime,
    required this.selectedPlatform,
    required this.selectedScreenType,
    required this.selectedLocation,
    required this.selectedAudioLanguage,
    required this.selectedSubstitlesLanguage,
  });

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF06062B),
      // elevation: 1,
      titleTextStyle: const TextStyle(fontSize: 30, color:Colors.white, fontWeight: FontWeight.bold),
      title: const Text ('Enter view information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Platform', style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold)),
              AddMovieDropdown(
                hintText: 'Select', 
                entries: Platform.values.map(
                  (Platform platform) {
                    return DropdownMenuEntry(
                      value: platform, 
                      label: platform.label,
                      style: MenuItemButton.styleFrom(foregroundColor: Colors.white),);
                  }
                ).toList(),
                onSelectedFunction: (value) => widget.selectedPlatform = value,
              ),
            ],
          ),
          const SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Screen Type', style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold)),
              AddMovieDropdown(
                hintText: 'Select', 
                entries: ScreenType.values.map(
                  (ScreenType screenType) {
                    return DropdownMenuEntry(
                      value: screenType, 
                      label: screenType.label,
                      style: MenuItemButton.styleFrom(foregroundColor: Colors.white),);
                  }
                ).toList(),
                onSelectedFunction: (value) => widget.selectedScreenType = value,
              ),
            ],
          ),
          const SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Location', style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold)),
              AddMovieDropdown(
                hintText: 'Select', 
                entries: Location.values.map(
                  (Location location) {
                    return DropdownMenuEntry(
                      value: location, 
                      label: location.label,
                      style: MenuItemButton.styleFrom(foregroundColor: Colors.white),);
                  }
                ).toList(),
                onSelectedFunction: (value) => widget.selectedLocation = value,
              ),
            ],
          ),
          const SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Audio\nLanguage', style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold)),
              AddMovieDropdown(
                hintText: 'Select', 
                entries: MovieLanguage.values.map(
                  (MovieLanguage movieLanguage) {
                    return DropdownMenuEntry(
                      value: movieLanguage, 
                      label: movieLanguage.label,
                      style: MenuItemButton.styleFrom(foregroundColor: Colors.white),);
                  }
                ).toList(),
                onSelectedFunction: (value) => widget.selectedAudioLanguage = value,
              ),
            ],
          ),
          const SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtitles\nLanguage', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              AddMovieDropdown(
                hintText: 'Select', 
                entries: MovieLanguage.values.map(
                  (MovieLanguage movieLanguage) {
                    return DropdownMenuEntry(
                      value: movieLanguage, 
                      label: movieLanguage.label,
                      style: MenuItemButton.styleFrom(foregroundColor: Colors.white),);
                  }
                ).toList(),
                onSelectedFunction: (value) => widget.selectedSubstitlesLanguage = value,
              ),
            ],
          ),
        ]
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.databaseService.addVisualization(
              widget.valueKey, 
              widget.movieDetails, 
              widget.selectedPlatform, 
              widget.selectedScreenType, 
              widget.selectedLocation,
              widget.selectedAudioLanguage, 
              widget.selectedSubstitlesLanguage,
              widget.selectedDateTime,
            );
            setState(() {});
            Navigator.pop(context, 'Accept');
            },
          child: const Text('Accept'),
        ),
      ],
    );
  }
}