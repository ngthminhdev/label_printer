/*
 * label_printer
 * Created by Nguyen Thanh Minh
 * 
 * Copyright (c) 2023-2023. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:label_printer/src/enums.dart';

class LabelPrinter {
  LabelPrinter({
    this.printerType = PrinterType.label,
    this.printMode = PrintMode.overwrite,
    this.metric = Metric.mm,
    this.direction = Direction.up,
    this.dpi = 203,
    this.verticalGap = 0,
    this.horizontalGap = 0,
    this.labelWidth = 0,
    this.labelHeight = 0,
  });

  String? _host;
  int? _port;

  late Socket _socket;

  final PrinterType printerType;
  final PrintMode printMode;
  final Metric metric;
  final Direction direction;

  // Printer model DPI
  final int dpi;

  // Label size
  final int labelWidth;
  final int labelHeight;

  // Label gap size
  final int verticalGap;
  final int horizontalGap;

  String _internalCommand = '';

  String? get host => _host;
  int? get port => _port;

  /// Connect to printer
  Future<PosPrintResult> connect(String host,
      {int port = 9100, Duration timeout = const Duration(seconds: 5)}) async {
    _host = host;
    _port = port;
    try {
      _socket = await Socket.connect(host, port, timeout: timeout);
      return Future<PosPrintResult>.value(PosPrintResult.success);
    } catch (e) {
      return Future<PosPrintResult>.value(PosPrintResult.timeout);
    }
  }

  /// [delayMs]: milliseconds to wait after destroying the socket
  void disconnect({int? delayMs}) async {
    _socket.destroy();
    if (delayMs != null) {
      await Future.delayed(Duration(milliseconds: delayMs), () => null);
    }
  }

  // ************************* PRINTER COMMAND *************************

  /// Get printer info
  void info() {
    _socket.write('SELFTEST');
  }

  /// Prefix seting up command before print
  ///
  String _prefixCommand() {
    return 'SIZE $labelWidth ${metric.unitString}, $labelHeight ${metric.unitString}\r\nGAP $horizontalGap ${metric.unitString}, $verticalGap ${metric.unitString}\r\nDIRECTION ${direction.directionString}\r\nCLS\r\n';
  }

  /// Execute print command
  void _execute({int numOfSet = 1, int numOfPrint = 1}) {
    _socket.write('\nPRINT $numOfSet,$numOfPrint\r\nEOP\r\n');
  }

  /// Print image
  ///
  /// [image] image in png format
  /// [numOfSet] specifies how many copies should be printed foreach particular label set
  /// [numOfPrint] specifies how many sets of labels will be printed
  /// [xOffset] horizontal position to start print
  /// [yOffset] vertical position to start print
  /// [alpha] the alpha channel level of the pixel is being ignored
  ///
  void image(img.Image image,
      {int numOfSet = 1,
      int numOfPrint = 1,
      int xOffset = 0,
      int yOffset = 0,
      int alpha = 50}) {
    int dotsPerMm = (dpi / 25.4).round();
    int width = labelWidth * dotsPerMm; //
    int height = labelHeight * dotsPerMm;
    List<int> imgBit = _getImageInBitmap(image, alpha: alpha, width: width, height: height);

    String bitCmd = 'BITMAP $xOffset,$yOffset,$width,$height,$printMode,';
    int len = bitCmd.length;
    Uint8List buffer = Uint8List(imgBit.length + len);
    buffer.setRange(0, len, utf8.encode(bitCmd));
    buffer.setRange(len, buffer.length, imgBit);

    _socket.write(_prefixCommand());
    _socket.add(buffer);
    _execute(numOfSet: numOfSet, numOfPrint: numOfPrint);
  }

  List<int> _getImageInBitmap(img.Image image,
      {int alpha = 50, int width = 0, height = 0}) {
    try {
      final data = List.generate(height, (y) => List<int>.filled(width, 0));

      for (int y = 0; y < height; y++) {
        for (int b = 0; b < width; b++) {
          int byte = 0;
          int mask = 128;
          for (int x = b * 8; x < (b + 1) * 8; x++) {
            int? color = image.getPixel(x, y);
            int aChannel = img.getAlpha(color);
            if (aChannel <= alpha) {
              byte ^= mask; // mark as empty dot (not print)
            }
            mask = mask >> 1;
          }
          data[y][b] = byte;
        }
      }

      List<int> flatData = data.expand((row) => row).toList();
      return flatData;
    } catch (e) {
      return [];
    }
  }

  /// Add raw Uint8List command to printer
  ///
  /// [cmd] Uint8List commands
  ///
  void raw(List<int> cmd) {
    _socket.add(cmd);
  }

  /// Add raw text command to printer
  ///
  /// [cmd] String commands
  ///
  void rawText(String cmd) {
    _socket.write(cmd);
  }

  /// Get current building command before execute
  String get commands => _internalCommand;

  /// Add text to print
  ///
  /// [text] text to print
  /// [xOffset] horizontal position to start print
  /// [yOffset] vertical position to start print
  /// [size] text size
  /// [rotation] text rotation
  /// [xScale] horizontal scale (1-10)
  /// [yScale] vertical scale (1-10)
  ///
  void addText(
    String text, {
    int xOffset = 0,
    int yOffset = 0,
    PrintTextSize size = PrintTextSize.xxSmall,
    PrintRotation rotation = PrintRotation.none,
    int xScale = 0,
    int yScale = 0,
  }) {
    String cmd =
        'TEXT $xOffset,$yOffset,"${size.value}",${rotation.value},$xScale,$yScale,"$text"\r\n';
    _internalCommand += cmd;
  }
}
