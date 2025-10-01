import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_ce/hive.dart';
// import 'package:your_package/core/hive/hive_registrar.g.dart';
import 'package:get_it/get_it.dart';
// import 'di.config.dart';
import 'package:injectable/injectable.dart';
import 'package:video_calling/core/service_locator/di.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() {
  Hive.init(Directory.current.path);

  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

  // if (!getIt.isRegistered<Box<ExpenseModel>>()) {
  //   getIt.registerLazySingleton(
  //     () => Hive.box<ExpenseModel>(
  //         name: BoxNames.expenses, encryptionKey: BoxNames.key),
  //   );
  // }

  getIt.init();
}
