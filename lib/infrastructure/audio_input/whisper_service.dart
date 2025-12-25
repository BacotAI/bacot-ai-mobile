import 'dart:io';
import 'dart:async';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';
import 'package:smart_interview_ai/core/helper/log_helper.dart';

@lazySingleton
class WhisperService {
  late Whisper _whisper;
  bool _isInitialized = false;
  String? _modelPath;

  Future<void>? _currentTranscription;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      _modelPath = '${dir.path}/ggml-tiny.bin';

      final modelFile = File(_modelPath!);
      if (!await modelFile.exists()) {
        try {
          final data = await rootBundle.load('assets/ml/ggml-tiny.bin');
          final bytes = data.buffer.asUint8List();
          await modelFile.writeAsBytes(bytes, flush: true);
        } catch (e) {
          Log.error(
            'Model file not found in assets. Please ensure assets/ml/ggml-tiny.bin exists.',
          );
          throw Exception(
            'Model file not found in assets. Please ensure assets/ml/ggml-tiny.bin exists.',
          );
        }
      }

      _whisper = Whisper(model: WhisperModel.tiny);
      _isInitialized = true;
      Log.info('WhisperService initialized with tiny model.');
    } catch (e) {
      _isInitialized = false;
      Log.error('WhisperService initialization failed: $e');
      rethrow;
    }
  }

  Future<String> transcribe(String path) async {
    final previousTranscription = _currentTranscription;
    final completer = Completer<void>();
    _currentTranscription = completer.future;

    if (previousTranscription != null) {
      Log.info('Whisper: Transcription already in progress, waiting...');
      await previousTranscription;
    }

    try {
      return await _transcribeInternal(path);
    } finally {
      completer.complete();
      if (_currentTranscription == completer.future) {
        _currentTranscription = null;
      }
    }
  }

  Future<String> _transcribeInternal(String path) async {
    final String outputPath;
    if (path.contains('.')) {
      outputPath = '${path.substring(0, path.lastIndexOf('.'))}.wav';
    } else {
      outputPath = '$path.wav';
    }

    // Whisper requires 16000Hz mono WAV files
    final command = '-y -i $path -ar 16000 -ac 1 $outputPath';

    Log.info('Converting audio for Whisper: $command');
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (!returnCode!.isValueSuccess()) {
      Log.error(
        'Failed to convert audio for Whisper. Return code: $returnCode',
      );
      throw Exception('Failed to convert audio for Whisper');
    }

    if (!_isInitialized) {
      await init();
    }

    try {
      Log.info('Starting Whisper transcription for: $outputPath');
      final res = await _whisper.transcribe(
        transcribeRequest: TranscribeRequest(
          audio: outputPath,
          isTranslate: false,
          isNoTimestamps: true,
        ),
      );
      Log.info('Whisper transcription completed.');
      return res.text;
    } catch (e) {
      Log.error('Transcription failed: $e');
      throw Exception('Transcription failed: $e');
    }
  }
}
