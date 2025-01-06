import 'education_system.dart';

final Map<String, EducationLevel> educationSystem = {
  'الإبتدائي': EducationLevel(
    name: 'الإبتدائي',
    years: {
      'الأولى إبتدائي': YearStructure(
        name: 'الأولى إبتدائي',
        departments: ['none'],
        semesters: [
          Semester(
            name: 'الفصل الأول',
            chapters: [
              ChapterStructure(
                name: 'الحضارات القديمة في الجزائر',
                courses: [
                  CourseStructure(
                    name: 'الحضارة النوميدية',
                    content: '''
# حضارة نوميديا القديمة

## التعريف بالحضارة النوميدية
* مملكة نوميديا القديمة
* موقعها الجغرافي
* أهم ملوكها

## الحياة الاجتماعية
1. العادات والتقاليد
2. نظام الحكم
3. الحياة اليومية

---

# التراث النوميدي

## المعالم الأثرية
* الضريح الملكي المدغاسن
* مدينة تيمقاد الرومانية
* قصر ماسينيسا

## الفنون والصناعات
- صناعة الفخار
- النقوش الصخرية
- صناعة الحلي
''',
                  ),
                  CourseStructure(
                    name: 'الفينيقيون في شمال إفريقيا',
                    content: '''
# التواجد الفينيقي في شمال إفريقيا

## التأسيس والتوسع
* تأسيس قرطاج
* المستوطنات الساحلية
* العلاقات مع السكان المحليين

## النشاط التجاري
1. التجارة البحرية
2. المبادلات التجارية
3. الموانئ الرئيسية

---

# الحضارة القرطاجية

## مظاهر الحضارة
* العمارة والبناء
* النظام السياسي
* الديانة والمعتقدات

## التراث المادي
- المعابد والمقابر
- النقود والعملات
- الصناعات التقليدية
''',
                  ),
                ],
                backgroundImage: 'assets/images/chapter1.png',
              ),
            ],
          ),
        ],
      ),
      'الثانية إبتدائي': YearStructure(
        name: 'الثانية إبتدائي',
        departments: ['none'],
        semesters: [/* ... */],
      ),
      'الثالثة إبتدائي': YearStructure(
        name: 'الثالثة إبتدائي',
        departments: ['none'],
        semesters: [/* ... */],
      ),
      'الرابعة إبتدائي': YearStructure(
        name: 'الرابعة إبتدائي',
        departments: ['none'],
        semesters: [/* ... */],
      ),
      'الخامسة إبتدائي': YearStructure(
        name: 'الخامسة إبتدائي',
        departments: ['none'],
        semesters: [/* ... */],
      ),
      // Add other years...
    },
  ),
  'المتوسط': EducationLevel(
    name: 'المتوسط',
    years: {
      'الأولى متوسط': YearStructure(
        name: 'الأولى متوسط',
        departments: ['none'],
        semesters: [/* ... */],
      ),
      'الثانية متوسط': YearStructure(
        name: 'الثانية متوسط',
        departments: ['none'],
        semesters: [/* ... */],
      ),
      'الثالثة متوسط': YearStructure(
        name: 'الثالثة متوسط',
        departments: ['none'],
        semesters: [/* ... */],
      ),
      'الرابعة متوسط': YearStructure(
        name: 'الرابعة متوسط',
        departments: ['none'],
        semesters: [/* ... */],
      ),
    },
  ),
  'الثانوي': EducationLevel(
    name: 'الثانوي',
    years: {
      'الأولى ثانوي': YearStructure(
        name: 'الأولى ثانوي',
        departments: ['علمي', 'أدبي'],
        semesters: [/* ... */],
      ),
      'الثانية ثانوي': YearStructure(
        name: 'الثانية ثانوي',
        departments: [
          'رياضيات',
          'علوم تجريبية',
          'تقني رياضي',
          'تسيير وإقتصاد',
          'آداب وفلسفة',
          'لغات أجنبية'
        ],
        semesters: [/* ... */],
      ),
      'الثالثة ثانوي': YearStructure(
        name: 'الثالثة ثانوي',
        departments: [
          'رياضيات',
          'علوم تجريبية',
          'تقني رياضي',
          'تسيير وإقتصاد',
          'آداب وفلسفة',
          'لغات أجنبية'
        ],
        semesters: [/* ... */],
      ),
    },
  ),
  'الجامعي': EducationLevel(
    name: 'الجامعي',
    years: {
      'الأولى جامعي': YearStructure(
        name: 'الأولى جامعي',
        departments: [
          'تاريخ',
          'علوم سياسية',
          'علوم إجتماعية',
          'فلسفة',
          'علوم إنسانية'
        ],
        semesters: [/* ... */],
      ),
      'الثانية جامعي': YearStructure(
        name: 'الثانية جامعي',
        departments: [
          'تاريخ',
          'علوم سياسية',
          'علوم إجتماعية',
          'فلسفة',
          'علوم إنسانية'
        ],
        semesters: [/* ... */],
      ),
      'الثالثة جامعي': YearStructure(
        name: 'الثالثة جامعي',
        departments: [
          'تاريخ',
          'علوم سياسية',
          'علوم إجتماعية',
          'فلسفة',
          'علوم إنسانية'
        ],
        semesters: [/* ... */],
      ),
      'الرابعة جامعي': YearStructure(
        name: 'الرابعة جامعي',
        departments: [
          'تاريخ',
          'علوم سياسية',
          'علوم إجتماعية',
          'فلسفة',
          'علوم إنسانية'
        ],
        semesters: [/* ... */],
      ),
      'الخامسة جامعي': YearStructure(
        name: 'الخامسة جامعي',
        departments: [
          'تاريخ',
          'علوم سياسية',
          'علوم إجتماعية',
          'فلسفة',
          'علوم إنسانية'
        ],
        semesters: [/* ... */],
      ),
      // Add other university years...
    },
  ),
};
