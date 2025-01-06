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
  final List<String> departments;
  final List<Semester> semesters;

  YearStructure({
    required this.name,
    required this.departments,
    required this.semesters,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'departments': departments,
        'semesters': semesters.map((s) => s.toJson()).toList(),
      };
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
  final String content;

  CourseStructure({
    required this.name,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'content': content,
      };
}
