import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/event_services.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<EventService>(create: (_) => EventService.instance),
      ],
      child: const App(),
    ),
  );
}

