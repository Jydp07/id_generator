// import 'dart:convert';
// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:student_id_generator/src/core/utils/shared_preferences_utility.dart';
// import 'package:student_id_generator/src/core/utils/snackbar_utility.dart';
// import 'package:student_id_generator/src/feature/data/models/saved_layout.dart';
// import 'package:student_id_generator/src/shared/data/enums/enums.dart';

// /// Utility class for saving and loading layout configurations
// /// Web-compatible implementation using browser's localStorage
// class StorageUtility {
//   static const String _currentLayoutKey = 'current_layout';

//   /// Load a specific layout by name
//   static Future<SavedLayout?> loadLayout(String name) async {
//     try {
//       final layouts = await _getSavedLayouts();
//       return layouts.firstWhereOrNull((layout) => layout.name == name);
//     } catch (e) {
//       log('Error loading layout: $e');
//       SnackbarUtility.showSnackbar(
//         'Failed to load layout: $e',
//         SnackbarType.error,
//       );
//       return null;
//     }
//   }

//   /// Delete a layout
//   static Future<bool> deleteLayout(String name) async {
//     try {
//       final layouts = await _getSavedLayouts();
//       layouts.removeWhere((layout) => layout.name == name);
//       await _saveLayoutsToStorage(layouts);

//       SnackbarUtility.showSnackbar(
//         'Layout "$name" deleted successfully!',
//         SnackbarType.success,
//       );

//       return true;
//     } catch (e) {
//       log('Error deleting layout: $e');
//       SnackbarUtility.showSnackbar(
//         'Failed to delete layout: $e',
//         SnackbarType.error,
//       );
//       return false;
//     }
//   }

//   /// Save current layout as default
//   static Future<bool> saveCurrentLayout(SavedLayout layout) async {
//     try {
//       if (SharedPreferencesUtility.isAvailable()) {
//         await SharedPreferencesUtility.saveCurrentLayout(layout);
//       } else {
//         // Fallback to in-memory storage
//         _fallbackStorage[_currentLayoutKey] = layout.toJson();
//       }
//       return true;
//     } catch (e) {
//       log('Error saving current layout: $e');
//       return false;
//     }
//   }

//   /// Load current layout
//   static Future<SavedLayout?> loadCurrentLayout() async {
//     try {
//       if (SharedPreferencesUtility.isAvailable()) {
//         return await SharedPreferencesUtility.loadCurrentLayout();
//       } else {
//         // Fallback to in-memory storage
//         final layoutData = _fallbackStorage[_currentLayoutKey];
//         if (layoutData != null) {
//           return SavedLayout.fromJson(layoutData);
//         }
//       }
//       return null;
//     } catch (e) {
//       log('Error loading current layout: $e');
//       return null;
//     }
//   }

//   // /// Export layouts to JSON file (for backup)
//   // static Future<void> exportLayouts() async {
//   //   try {
//   //     final layouts = await _getSavedLayouts();
//   //     final exportData = {
//   //       'layouts': layouts.map((layout) => layout.toJson()).toList(),
//   //       'exportDate': DateTime.now().toIso8601String(),
//   //       'version': '1.0.0',
//   //     };

//   //     final jsonString = jsonEncode(exportData);
//   //     final blob = html.Blob([jsonString], 'application/json');
//   //     final url = html.Url.createObjectUrlFromBlob(blob);

//   //     html.AnchorElement(href: url)
//   //       ..setAttribute('download',
//   //           'student_id_layouts_${DateTime.now().millisecondsSinceEpoch}.json')
//   //       ..click();

//   //     html.Url.revokeObjectUrl(url);

//   //     SnackbarUtility.showSnackbar(
//   //       'Layouts exported successfully!',
//   //       SnackbarType.success,
//   //     );
//   //   } catch (e) {
//   //     log('Error exporting layouts: $e');
//   //     SnackbarUtility.showSnackbar(
//   //       'Failed to export layouts: $e',
//   //       SnackbarType.error,
//   //     );
//   //   }
//   // }

//   /// Import layouts from JSON file
//   static Future<bool> importLayouts(String jsonString) async {
//     try {
//       final importData = jsonDecode(jsonString) as Map<String, dynamic>;
//       final layoutsData = importData['layouts'] as List<dynamic>;

//       final importedLayouts = layoutsData
//           .map((data) => SavedLayout.fromJson(data as Map<String, dynamic>))
//           .toList();

//       final existingLayouts = await _getSavedLayouts();

//       // Merge layouts (existing ones with same name will be overwritten)
//       for (final importedLayout in importedLayouts) {
//         final existingIndex = existingLayouts.indexWhere(
//           (layout) => layout.name == importedLayout.name,
//         );
//         if (existingIndex != -1) {
//           existingLayouts[existingIndex] = importedLayout;
//         } else {
//           existingLayouts.add(importedLayout);
//         }
//       }

//       await _saveLayoutsToStorage(existingLayouts);

//       SnackbarUtility.showSnackbar(
//         'Layouts imported successfully!',
//         SnackbarType.success,
//       );

//       return true;
//     } catch (e) {
//       log('Error importing layouts: $e');
//       SnackbarUtility.showSnackbar(
//         'Failed to import layouts: $e',
//         SnackbarType.error,
//       );
//       return false;
//     }
//   }

//   // Fallback in-memory storage for when localStorage is not available
//   static final Map<String, Map<String, dynamic>> _fallbackStorage = {};
// }
