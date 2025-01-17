Ray dart is a library to enable sending data to the [Ray app by Spatie](https://myray.app/docs/getting-started/introduction). It does not yet have feature parity with other implementations such as spatie/ray-php but it is mostly there.

## Getting started

This library is not a published package as of yet, so in order to use it you would need to clone this repo and add to your dependencies manually.

## Usage

```dart
import 'package:ray_dart/ray_dart.dart';

ray('some literal string');
ray([1, 2, 3, 4])..clearScreen()..showApp();
ray().hide();
// etc
```

## Testing

Tests are a WIP and at the moment only include a single test group.

Regardless, to test:

```bash
dart test
```

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.