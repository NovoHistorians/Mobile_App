class EducationLevel {
  final String name;
  final Map<String, YearStructure> years;

  EducationLevel({required this.name, required this.years});

  Map<String, dynamic> toJson() => {
        'name': name,
        'years': years.map((k, v) => MapEntry(k, v.toJson())),
      };
}

class YearStructure {
  final String name;
  final Map<String, List<Semester>>? departments;
  final List<Semester>? semesters;

  YearStructure({
    required this.name,
    this.departments,
    this.semesters,
  }) : assert(
          (departments == null && semesters != null) ||
              (departments != null && semesters == null),
          'A year must have either departments or semesters, but not both.',
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
    };
    if (departments != null) {
      data['departments'] = departments!
          .map((k, v) => MapEntry(k, v.map((s) => s.toJson()).toList()));
    }
    if (semesters != null) {
      data['semesters'] = semesters!.map((s) => s.toJson()).toList();
    }
    return data;
  }
}

class Semester {
  final String name;
  final List<ChapterStructure> chapters;

  Semester({required this.name, required this.chapters});

  Map<String, dynamic> toJson() => {
        'name': name,
        'chapters': chapters.map((c) => c.toJson()).toList(),
      };
}

class ChapterStructure {
  final String name;
  final List<CourseStructure> courses;
  final String backgroundImage;

  ChapterStructure(
      {required this.name,
      required this.courses,
      required this.backgroundImage});

  Map<String, dynamic> toJson() => {
        'name': name,
        'courses': courses.map((c) => c.toJson()).toList(),
        'backgroundImage': backgroundImage
      };
}

class CourseStructure {
  final String name;
  late String content;

  CourseStructure({
    required this.name,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'content': content,
      };
}
