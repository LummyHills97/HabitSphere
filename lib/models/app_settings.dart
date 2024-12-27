import 'package:isar/isar.dart';

// Run this command to generate the file: dart run build_runner build
part 'app_settings.g.dart';

@Collection()
class AppSettings {
  // AppSettings ID
  Id id = Isar.autoIncrement;

  // First launch date
  DateTime? firstLaunchDate;
}
