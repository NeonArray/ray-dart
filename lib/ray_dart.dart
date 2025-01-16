library;

import 'package:ray_dart/src/ray.dart';
import 'package:ray_dart/src/settings/ray_settings_factory.dart';

export 'src/fluent_api.dart';

// Using a symbol here so that null can be used as a value for any arg
const _key = Symbol('default_arg_value');

Ray ray([
  dynamic arg1 = _key,
  dynamic arg2 = _key,
  dynamic arg3 = _key,
  dynamic arg4 = _key,
  dynamic arg5 = _key,
  dynamic arg6 = _key,
  dynamic arg7 = _key,
  dynamic arg8 = _key,
  dynamic arg9 = _key,
  dynamic arg10 = _key,
]) {
  List<dynamic> args = [
    if (arg1 != _key) arg1,
    if (arg2 != _key) arg2,
    if (arg3 != _key) arg3,
    if (arg4 != _key) arg4,
    if (arg5 != _key) arg5,
    if (arg6 != _key) arg5,
    if (arg7 != _key) arg5,
    if (arg8 != _key) arg5,
    if (arg9 != _key) arg5,
    if (arg10 != _key) arg5,
  ];
  var settings = RaySettingsFactory.createFromConfigFile();
  return (Ray(settings: settings))..send(args);
}
