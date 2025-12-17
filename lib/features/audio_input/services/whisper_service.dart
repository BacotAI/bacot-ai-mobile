import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';

class WhisperService {
  late Whisper _whisper;
  bool _isInitialized = false;
  String? _modelPath;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      _modelPath = '${dir.path}/ggml-base.bin';

      final modelFile = File(_modelPath!);
      if (!await modelFile.exists()) {
        try {
          final data = await rootBundle.load('assets/ml/ggml-base.bin');
          final bytes = data.buffer.asUint8List();
          await modelFile.writeAsBytes(bytes, flush: true);
        } catch (e) {
          throw Exception(
            'Model file not found in assets. Please ensure assets/ml/ggml-base.bin exists.',
          );
        }
      }

      _whisper = Whisper(model: WhisperModel.base);
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  Future<String> transcribe(String path) async {
    final String outputPath;
    if (path.contains('.')) {
      outputPath = '${path.substring(0, path.lastIndexOf('.'))}.wav';
    } else {
      outputPath = '$path.wav';
    }
    final command = '-i $path -ar 16000 -ac 1 $outputPath';

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (!returnCode!.isValueSuccess()) {
      throw Exception('Failed to convert audio for Whisper');
    }

    if (!_isInitialized) {
      await init();
    }

    try {
      final res = await _whisper.transcribe(
        transcribeRequest: TranscribeRequest(
          audio: outputPath,
          isTranslate: false,
          isNoTimestamps: true,
        ),
      );
      return res.text;
    } catch (e) {
      throw Exception('Transcription failed: $e');
    }
  }
}
