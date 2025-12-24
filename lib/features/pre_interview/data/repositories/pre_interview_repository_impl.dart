import '../../domain/entities/question_entity.dart';
import '../../domain/repositories/pre_interview_repository.dart';

class PreInterviewRepositoryImpl implements PreInterviewRepository {
  @override
  Future<List<QuestionEntity>> getQuestions() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      const QuestionEntity(
        id: '1',
        text: 'Apa kelemahan terbesar Anda?',
        hrInsight:
            'HR tidak mencari keburukan Anda. Mereka ingin melihat Self-Awareness (kesadaran diri) dan apakah Anda punya inisiatif untuk memperbaikinya.',
        difficulty: QuestionDifficulty.tricky,
        estimatedDurationSeconds: 60,
        communityStats: '60% pengguna gagal/harus retake di pertanyaan ini.',
        powerWords: ['Self-Awareness', 'Inisiatif', 'Continuous Improvement'],
      ),
      const QuestionEntity(
        id: '2',
        text:
            'Ceritakan tantangan terbesar yang pernah Anda hadapi dan bagaimana Anda menyelesaikannya.',
        hrInsight:
            'HR ingin melihat kemampuan problem solving dan ketangguhan Anda (Resilience). Fokus pada aksi dan hasil nyata yang Anda berikan.',
        difficulty: QuestionDifficulty.hard,
        estimatedDurationSeconds: 120,
        communityStats: '45% pengguna merasa ini adalah pertanyaan tersulit.',
        powerWords: [
          'Problem Solving',
          'Conflict Resolution',
          'Adaptability',
          'Result-Oriented',
        ],
      ),
      const QuestionEntity(
        id: '3',
        text: 'Mengapa kami harus mempekerjakan Anda?',
        hrInsight:
            'Ini adalah kesempatan Anda untuk "menjual" diri. HR ingin melihat keselarasan antara skill Anda dengan kebutuhan perusahaan.',
        difficulty: QuestionDifficulty.easy,
        estimatedDurationSeconds: 90,
        communityStats:
            '80% pengguna berhasil melewati pertanyaan ini dengan baik.',
        powerWords: [
          'Value Proposition',
          'Alignment',
          'Impact',
          'Contribution',
        ],
      ),
      const QuestionEntity(
        id: '4',
        text: 'Bagaimana gaya kepemimpinan Anda?',
        hrInsight:
            'HR ingin tahu cara Anda mengelola tim dan mendelegasikan tugas. Gunakan contoh nyata tentang bagaimana Anda memotivasi orang lain.',
        difficulty: QuestionDifficulty.tricky,
        estimatedDurationSeconds: 90,
        communityStats: '55% pengguna kesulitan memberikan contoh konkret.',
        powerWords: ['Delegasi', 'Mentoring', 'KPI', 'Inisiatif', 'Empati'],
      ),
    ];
  }
}
