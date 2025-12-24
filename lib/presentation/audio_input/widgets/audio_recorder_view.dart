import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/material.dart';
import 'package:smart_interview_ai/core/config/app_colors.dart';
import 'package:smart_interview_ai/core/network/api_client.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/core/helper/log_helper.dart';
import 'package:smart_interview_ai/core/helper/presentation_helper.dart';
import 'package:smart_interview_ai/infrastructure/audio_input/repositories/audio_repository_impl.dart';
import 'package:smart_interview_ai/domain/audio_input/audio_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_interview_ai/presentation/audio_input/widgets/audio_control_button.dart';
import 'package:smart_interview_ai/presentation/audio_input/widgets/audio_wave_display.dart';
import 'package:smart_interview_ai/presentation/audio_input/widgets/speech_result_dialog.dart';
import 'package:smart_interview_ai/infrastructure/audio_input/whisper_service.dart';

class AudioRecorderView extends StatefulWidget {
  const AudioRecorderView({super.key});

  @override
  State<AudioRecorderView> createState() => _AudioRecorderViewState();
}

class _AudioRecorderViewState extends State<AudioRecorderView> {
  late final RecorderController recorderController;
  late final AudioRepository _audioRepository;
  final WhisperService _whisperService = WhisperService();

  String? path;
  bool isRecording = false;
  bool isPaused = false;
  bool isUploading = false;
  bool isLocalMode = false;
  bool isTranscribingLocal = false;

  @override
  void initState() {
    super.initState();
    _audioRepository = AudioRepositoryImpl(sl<ApiClient>());
    _initialiseController();
  }

  void _initialiseController() {
    recorderController = RecorderController();
  }

  Future<void> _startRecording() async {
    final hasPermission = await Permission.microphone.request().isGranted;
    if (!hasPermission) {
      if (mounted) {
        PresentationHelper.showImmediateSnackBar(
          context,
          const SnackBar(content: Text('Microphone permission is required')),
        );
      }
      return;
    }

    final dir = await getApplicationDocumentsDirectory();

    // Using .m4a as it's the standard for AAC.
    // To strictly support MP3, we would need a converter (e.g. ffmpeg) or a specific MP3 encoder
    // which is often not supported natively on all Android/iOS versions without external libs.
    // For this implementation, we use AAC (m4a) which is widely supported.
    final filePath =
        '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await recorderController.record(path: filePath);

    setState(() {
      isRecording = true;
      path = filePath;
    });
  }

  Future<void> _uploadAudio(String filePath) async {
    try {
      if (mounted) {
        PresentationHelper.showImmediateSnackBar(
          context,
          const SnackBar(content: Text('Uploading audio...')),
        );
      }

      final result = await _audioRepository.uploadAudio(filePath);

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SpeechResultDialog(result: result);
          },
        );

        setState(() {
          isUploading = false;
        });

        PresentationHelper.showImmediateSnackBar(
          context,
          const SnackBar(
            content: Text('Upload successful!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        PresentationHelper.showImmediateSnackBar(
          context,
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _processLocalAudio(String path) async {
    Log.info('Starting local audio processing for path: $path');
    setState(() {
      isTranscribingLocal = true;
    });

    if (mounted) {
      PresentationHelper.showImmediateSnackBar(
        context,
        const SnackBar(content: Text('Transcribing locally...')),
      );
    }

    try {
      final result = await _whisperService.transcribe(path);

      Log.info('Whisper transcription completed. Result text length: $result');

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SpeechResultDialog(result: result);
          },
        );
        PresentationHelper.showImmediateSnackBar(
          context,
          const SnackBar(
            content: Text('Transcription successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Log.info('Local transcription successful and dialog shown.');
      }
    } catch (e) {
      Log.error('Local transcription failed: $e');
      if (mounted) {
        PresentationHelper.showImmediateSnackBar(
          context,
          SnackBar(
            content: Text(
              'Local transcription failed: $e. Did you add the model?',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isTranscribingLocal = false;
        });
      }
      Log.info('Finished local audio processing.');
    }
  }

  Future<void> _stopRecording() async {
    final path = await recorderController.stop();
    setState(() {
      isRecording = false;
      isPaused = false;
      // Only set isUploading if we are going to actually upload/process immediately
      if (!isLocalMode) isUploading = true;
    });

    if (path != null && mounted) {
      if (isLocalMode) {
        await _processLocalAudio(path);
        return;
      }

      // Server Mode Logic
      final outputPath = path.replaceFirst('.m4a', '.mp3');

      final command = '-i $path -acodec libmp3lame -q:a 2 $outputPath';

      try {
        final result = await FFmpegKit.execute(command);

        ReturnCode? returnCode = await result.getReturnCode();

        if (mounted && returnCode != null) {
          if (returnCode.isValueSuccess()) {
            PresentationHelper.showImmediateSnackBar(
              context,
              SnackBar(content: Text('Saved as MP3: $outputPath')),
            );

            // Upload the MP3 file
            await _uploadAudio(outputPath);

            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                isUploading = false;
              });
            });
          } else {
            PresentationHelper.showImmediateSnackBar(
              context,
              SnackBar(content: Text('Failed to save as MP3')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          PresentationHelper.showImmediateSnackBar(
            context,
            SnackBar(content: Text('Error converting file: $e')),
          );
        }
      }
    }
  }

  Future<void> _togglePause() async {
    if (isRecording) {
      if (isPaused) {
        await recorderController.record(); // Resume
        setState(() => isPaused = false);
      } else {
        await recorderController.pause();
        setState(() => isPaused = true);
      }
    }
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
          // Header / Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Record Audio',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Mode Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Server', style: TextStyle(color: Colors.white)),
              Switch(
                value: isLocalMode,
                onChanged: (val) {
                  setState(() {
                    isLocalMode = val;
                  });
                },
                activeThumbColor: theme.colorScheme.secondary,
              ),
              const Text('Local', style: TextStyle(color: Colors.white)),
            ],
          ),

          const Spacer(),
          AudioWaveformDisplay(recorderController: recorderController),
          const Spacer(),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isRecording) ...[
                  // Pause/Resume
                  AudioControlButton(
                    onTap: _togglePause,
                    icon: isPaused
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                    color: AppColors.warning,
                    size: 56,
                  ),
                  const SizedBox(width: 32),
                ],

                // Record / Stop
                GestureDetector(
                  onTap: (isUploading || isTranscribingLocal)
                      ? null
                      : (isRecording ? _stopRecording : _startRecording),
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRecording
                          ? AppColors.error
                          : theme.colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isRecording
                                      ? AppColors.error
                                      : theme.colorScheme.primary)
                                  .withValues(alpha: 0.4),
                        ),
                      ],
                    ),
                    child: (isUploading || isTranscribingLocal)
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Icon(
                            isRecording
                                ? Icons.stop_rounded
                                : Icons.mic_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
