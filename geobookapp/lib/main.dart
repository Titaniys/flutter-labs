import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'core/utils/logger.dart';
import 'injection_container.dart';
import 'presentation/view_models/country_view_model.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация зависимостей
  final container = InjectionContainer();
  await container.init();

  // Отключаем логгер в релизе
  Logger.enable(kDebugMode);

  runApp(MyApp(viewModel: container.countryViewModel));
}

class MyApp extends StatelessWidget {
  final CountryViewModel viewModel;

  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CountryViewModel>.value(
      value: viewModel,
      child: MaterialApp(
        title: 'Географический справочник',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}