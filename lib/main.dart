import 'package:flutter/material.dart';
import 'package:upday_task/initial.dart';
import 'package:upday_task/settings/app_settings.dart';

void main() => runApp(
  InitialSetup(
    environment: AppEnvironment.DEV,
  ),
);
