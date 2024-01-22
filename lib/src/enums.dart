/*
 * label_printer
 * Created by Nguyen Thanh Minh
 * 
 * Copyright (c) 2023-2023. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

class PrinterType {
  const PrinterType._internal(this.value);
  final int value;

  static const label = PrinterType._internal(1);
  static const receipt = PrinterType._internal(2);
}

class Metric {
  const Metric._internal(this.value);
  final int value;

  static const mm = Metric._internal(1);
  static const inch = Metric._internal(2);

  String get unitString {
    return this == mm ? 'mm' : '';
  }
}

class Direction {
  const Direction._internal(this.value);
  final int value;

  static const up = Direction._internal(1);
  static const down = Direction._internal(2);
  static const upMirror = Direction._internal(3);
  static const downMirror = Direction._internal(4);

  String get directionString {
    if (value == Direction.up.value) {
      return '0';
    } else if (value == Direction.down.value) {
      return '1';
    } else if (value == Direction.upMirror.value) {
      return '0,1';
    } else if (value == Direction.downMirror.value) {
      return '1,1';
    }
    return '0';
  }
}

class PrintMode {
  const PrintMode._internal(this.value);
  final int value;

  static const overwrite = PrintMode._internal(1);
  static const or = PrintMode._internal(2);
  static const xor = PrintMode._internal(3);

  String get printString {
    if (value == PrintMode.overwrite.value) {
      return '0';
    } else if (value == PrintMode.or.value) {
      return '1';
    } else if (value == PrintMode.xor.value) {
      return '2';
    }
    return '0';
  }
}

class PosPrintResult {
  const PosPrintResult._internal(this.value);
  final int value;
  static const success = PosPrintResult._internal(1);
  static const timeout = PosPrintResult._internal(2);
  // final printer = BitmapPrinter('', 1, )

  String get msg {
    if (value == PosPrintResult.success.value) {
      return 'Success';
    } else if (value == PosPrintResult.timeout.value) {
      return 'Error. Printer connection timeout';
    } else {
      return 'Unknown error';
    }
  }
}

class PrintTextSize {
  const PrintTextSize._internal(this.size);
  final int size;

  static const xxSmall = PrintTextSize._internal(1);
  static const xSmall = PrintTextSize._internal(2);
  static const small = PrintTextSize._internal(3);
  static const medium = PrintTextSize._internal(4);
  static const large = PrintTextSize._internal(5);
  static const xLarge = PrintTextSize._internal(6);
  static const xxLarge = PrintTextSize._internal(7);
  static const xxxLarge = PrintTextSize._internal(8);

  int get value => size;
}

class PrintRotation {
  const PrintRotation._internal(this.degree);
  final int degree;

  static const none = PrintRotation._internal(0);
  static const quarter = PrintRotation._internal(90);
  static const half = PrintRotation._internal(180);
  static const quarterTo = PrintRotation._internal(270);

  int get value => degree;
}

class PrintAlign {
  const PrintAlign._internal(this.align);
  final int align;

  static const left = PrintAlign._internal(1);
  static const center = PrintAlign._internal(2);
  static const right = PrintAlign._internal(3);

  String get value {
    if (align == PrintAlign.left.align) {
      return '0';
    } else if (align == PrintAlign.center.align) {
      return '1';
    } else if (align == PrintAlign.right.align) {
      return '2';
    }
    return '0';
  }
}
