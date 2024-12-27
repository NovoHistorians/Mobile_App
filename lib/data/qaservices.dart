// QA Service for handling predefined responses
class QAService {
  static final Map<String, String> _qaDatabase = {
    'ما هو التاريخ':
        'التاريخ هو دراسة الماضي وتوثيق الأحداث والتطورات التي شهدها الإنسان على مر العصور.',
    'ما هي العصور القديمة':
        'العصور القديمة هي الفترة التي تمتد من ظهور الكتابة حتى سقوط الإمبراطورية الرومانية الغربية.',
    'متى بدأ العصر الحجري':
        'بدأ العصر الحجري منذ حوالي 3.4 مليون سنة قبل الميلاد واستمر حتى اكتشاف المعادن.',
    'ما هو العصر البرونزي':
        'العصر البرونزي هو فترة في التاريخ البشري تميزت باستخدام البرونز في صناعة الأدوات والأسلحة.',
    'كيف أذاكر التاريخ':
        'لمذاكرة التاريخ بشكل فعال، يمكنك اتباع الخطوات التالية: تنظيم المعلومات زمنياً، ربط الأحداث ببعضها، فهم الأسباب والنتائج، واستخدام الخرائط الذهنية.',
  };

  static List<String> getSuggestions(String query) {
    if (query.isEmpty) return [];
    return _qaDatabase.keys
        .where((question) => question.contains(query))
        .toList();
  }

  static String? getAnswer(String question) {
    // First try exact match
    if (_qaDatabase.containsKey(question)) {
      return _qaDatabase[question];
    }

    // Then try case-insensitive partial match
    final lowerQuestion = question.toLowerCase();
    for (var entry in _qaDatabase.entries) {
      if (entry.key.toLowerCase().contains(lowerQuestion)) {
        return entry.value;
      }
    }

    // Default response if no match found
    return 'عذراً، لا أستطيع الإجابة على هذا السؤال حالياً. يمكنك طرح سؤال آخر أو إعادة صياغة سؤالك.';
  }
}
