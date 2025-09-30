import 'dart:io';
import 'package:hive_ce/hive.dart';
// import 'package:your_package/core/hive/hive_registrar.g.dart';
import 'package:get_it/get_it.dart';
// import 'di.config.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() {
  Hive.init(Directory.current.path);

  // if (!getIt.isRegistered<Box<ExpenseModel>>()) {
  //   getIt.registerLazySingleton(
  //     () => Hive.box<ExpenseModel>(
  //         name: BoxNames.expenses, encryptionKey: BoxNames.key),
  //   );
  // }
}
