library tool.dev;

import 'package:dart_dev/dart_dev.dart' show dev, config;

main(List<String> args) async {
  // https://github.com/Workiva/dart_dev

  // Perform task configuration here as necessary.
  config.format..lineLength = 120;
  // Available task configurations:
  // config.analyze
  // config.copyLicense
  // config.coverage
  // config.docs
  // config.examples
  // config.format
  // config.test

  await dev(args);
}
