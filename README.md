# label_printer

[![Pub Version](https://img.shields.io/pub/v/esc_pos_printer)](https://pub.dev/packages/label_printer)

The library allows to print label using an ESC/POS thermal WiFi/Ethernet printer.

It can be used in [Flutter](https://flutter.dev/) or pure [Dart](https://dart.dev/) projects. For Flutter projects, both Android and iOS are supported.

To scan for printers in your network, consider using [ping_discover_network](https://pub.dev/packages/ping_discover_network) package. Note that most of the ESC/POS printers by default listen on port 9100.

## TODO (PRs are welcomed!)

- Print Image from assets or boundary Image with png format
- I will update more feature later ...


## How to Help

- Test and report bugs
- Share your ideas about what could be improved (code optimization, new features...)
- PRs are welcomed!

### Simple print Label:

```dart
final printer = LabelPrinter('192.168.0.1', 9100, {
    printerType: PrinterType.label,
    printMode: PrintMode.overwrite,
    metric: Metric.mm,
    direction: Direction.up,
    dpi: 203,
    verticalGap: 2,
    horizontalGap: 2,
    labelWidth: 65,
    labelHeight: 35,
});

printer.image(image, {
    numOfSet: 1
    numOfPrint: 1
    xOffset: 0
    yOffset: 0
    alpha: 50
})
```

### Simple raw commands:

```dart
// PRINT 1,1
// EOP
printer.raw([80, 82, 73, 78, 84, 32, 49, 44, 49, 13, 10, 69, 79, 80, 13, 10])

// Or if you want to using LATIN instead
printer.rawText('PRINT 1,1\r\nEOP\r\n');

```

## THANKS FOR SUPPORT, LEAVE ME A START OR A LIKE IF IT HELPFUL
