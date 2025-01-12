import 'education_system.dart';

final Map<String, EducationLevel> educationSystem = {
  'الإبتدائي': EducationLevel(
    name: 'الإبتدائي',
    years: {
      'الثالثة إبتدائي': YearStructure(
        name: 'الثالثة إبتدائي',
        departments: null,
        semesters: [
          Semester(
            name: 'الفصل الأول',
            chapters: [
              ChapterStructure(
                  name: "أدوات ومفاهيم المادة",
                  courses: [
                    CourseStructure(
                        name: "الأحداث الشخصية والتاريخية", content: ''''''),
                    CourseStructure(
                        name: "المكان وأهميته في الأحداث", content: ''''''),
                    CourseStructure(name: "الماضي والحاضر", content: '''''')
                  ],
                  backgroundImage: "assets/images/chapter.png"),
              ChapterStructure(
                  name: "التاريخ العام",
                  courses: [
                    CourseStructure(
                        name: "أنواع الآثار القديمة", content: ''''''),
                    CourseStructure(name: "المراحل التاريخية", content: ''''''),
                    CourseStructure(
                        name: "قدم تعمير شمال إفريقيا", content: '''''')
                  ],
                  backgroundImage: "assets/images/chapter.png"),
              ChapterStructure(
                  name: "التاريخ الوطني",
                  courses: [
                    CourseStructure(
                        name: "مصادر المعلومة التاريخية", content: ''''''),
                    CourseStructure(
                        name: "المعلومة التاريخية", content: ''''''),
                    CourseStructure(name: "تاريخ منطقتي", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png"),
            ],
          ),
        ],
      ),
      'الرابعة إبتدائي': YearStructure(
        name: 'الرابعة إبتدائي',
        departments: null,
        semesters: [
          Semester(
            name: 'الفصل الأول',
            chapters: [
              ChapterStructure(
                name: "أدوات ومفاهيم المادة التاريخية",
                courses: [
                  CourseStructure(name: "التقويم التاريخي", content: ''''''),
                  CourseStructure(name: "المرحلة التاريخية", content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "الإسلام في المغرب العربي",
                courses: [
                  CourseStructure(
                      name: "المغرب قبل الفتح الإسلامي", content: ''''''),
                  CourseStructure(
                      name: "الفتح الإسلامي للمغرب", content: ''''''),
                  CourseStructure(
                      name: "التحول في حياة المجتمع بعد الفتح الإسلامي",
                      content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "التاريخ الوطني",
                courses: [
                  CourseStructure(
                      name: "الدولة الجزائرية في العهد العثماني",
                      content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
            ],
          ),
        ],
      ),
      'الخامسة إبتدائي': YearStructure(
        name: 'الخامسة إبتدائي',
        departments: null,
        semesters: [
          Semester(
            name: 'الفصل الأول',
            chapters: [
              ChapterStructure(
                name: "أدوات ومفاهيم",
                courses: [
                  CourseStructure(name: "المادة", content: ''''''),
                  CourseStructure(
                      name: "الكرونولوجيا (العصور التاريخية)", content: ''''''),
                  CourseStructure(name: "شخصيات تاريخية", content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "التاريخ العام",
                courses: [
                  CourseStructure(name: "الاستعمار الحديث", content: ''''''),
                  CourseStructure(name: "انعكاسات الاستعمار", content: ''''''),
                  CourseStructure(
                      name: "الاستعمار في إفريقيا والمغرب العربي",
                      content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "التاريخ الوطني",
                courses: [
                  CourseStructure(name: "المقاومة الوطنية", content: ''''''),
                  CourseStructure(
                      name: "الثورة التحريرية الكبرى في الجزائر",
                      content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "ما بعد الاستقلال",
                courses: [
                  CourseStructure(
                      name: "التحديات الاجتماعية والاقتصادية", content: ''''''),
                  CourseStructure(name: "الجهود التنموية", content: ''''''),
                  CourseStructure(name: "السياسة الخارجية", content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
            ],
          ),
        ],
      ),
      // Add other years...
    },
  ),
  'المتوسط': EducationLevel(
    name: 'المتوسط',
    years: {
      'الأولى متوسط': YearStructure(
        name: 'الأولى متوسط',
        departments: null,
        semesters: [
          Semester(
            name: 'الفصل الأول',
            chapters: [
              ChapterStructure(
                name: "حضارات ما قبل التاريخ",
                courses: [
                  CourseStructure(
                      name: "دراسة الآثار القديمة", content: ''''''),
                  CourseStructure(
                      name: "كرونولوجيا عصور ما قبل التاريخ", content: ''''''),
                  CourseStructure(
                      name: "الآثار عنوان الفترة التي عاشها الإنسان",
                      content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "التاريخ الوطني",
                courses: [
                  CourseStructure(
                      name: "الجزائر وشمال أفريقيا في العصور القديمة",
                      content: ''''''),
                  CourseStructure(
                      name: "التطور الحضاري لممالك شمال أفريقيا القديمة",
                      content: ''''''),
                  CourseStructure(
                      name: "الاحتلال الثلاثي القديم لشمال أفريقيا ومقاومته",
                      content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "التاريخ العام",
                courses: [
                  CourseStructure(name: "حضارات العصر القديم", content: ''''''),
                  CourseStructure(
                      name: "منجزات حضارات العصر القديم", content: ''''''),
                  CourseStructure(
                      name: "بعدا التأثير والتأثر", content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
            ],
          ),
        ],
      ),
      'الثانية متوسط': YearStructure(
        name: 'الثانية متوسط',
        departments: null,
        semesters: [
          Semester(
            name: 'الفصل الأول',
            chapters: [
              ChapterStructure(
                name: "الوثائق التاريخية",
                courses: [
                  CourseStructure(
                      name: "الخطوات المنهجية لدراسة الوثيقة التاريخية",
                      content: ''''''),
                  CourseStructure(
                      name: "ميادين تحول المجتمع الإسلامي", content: ''''''),
                  CourseStructure(
                      name: "التطور الحضاري للدولة الإسلامية", content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "التاريخ الوطني",
                courses: [
                  CourseStructure(
                      name: "مظاهر تحول شمال إفريقيا إلى المغرب الإسلامي",
                      content: ''''''),
                  CourseStructure(
                      name: "الدول الإسلامية في الجزائر والمغرب الإسلامي",
                      content: ''''''),
                  CourseStructure(
                      name: "انعكاسات تراجع السيادة الإسلامية على الأندلس",
                      content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "التاريخ العام",
                courses: [
                  CourseStructure(
                      name: "انتشار الإسلام في المشرق والمغرب",
                      content: ''''''),
                  CourseStructure(
                      name: "مظاهر الحضارة الإسلامية", content: ''''''),
                  CourseStructure(
                      name: "تأثيرات الحضارة الإسلامية", content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
            ],
          ),
        ],
      ),
      'الثالثة متوسط': YearStructure(
        name: 'الثالثة متوسط',
        departments: null,
        semesters: [
          Semester(
            name: 'الفصل الأول',
            chapters: [
              ChapterStructure(
                name: "الوثائق التاريخية",
                courses: [
                  CourseStructure(name: "الخريطة التاريخية", content: ''''''),
                  CourseStructure(name: "الدولة العثمانية", content: ''''''),
                  CourseStructure(
                      name: "العلاقات الخارجية للدولة العثمانية",
                      content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "التاريخ الوطني",
                courses: [
                  CourseStructure(
                      name:
                          "الدولة الجزائرية الحديثة من القرن 16م إلى الاحتلال الفرنسي",
                      content: ''''''),
                  CourseStructure(
                      name: "الأسطول والبحرية الجزائرية", content: ''''''),
                  CourseStructure(
                      name: "مكانة الجزائر الدولية وعلاقاتها الخارجية",
                      content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "التاريخ العام",
                courses: [
                  CourseStructure(name: "النهضة الأوروبية", content: ''''''),
                  CourseStructure(
                      name: "أثر الحضارة الإسلامية في النهضة الأوروبية",
                      content: ''''''),
                  CourseStructure(
                      name: "اختلال التوازن بين الشرق الإسلامي والغرب المسيحي",
                      content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
            ],
          ),
        ],
      ),
      'الرابعة متوسط': YearStructure(
        name: 'الرابعة متوسط',
        departments: null,
        semesters: [
          Semester(
            name: 'الفصل الأول',
            chapters: [
              ChapterStructure(
                name: "الوثائق التاريخية",
                courses: [
                  CourseStructure(name: "الوثيقة التاريخية", content: ''''''),
                  CourseStructure(
                      name: "دراسة نقدية لرسالة بولينياك", content: ''''''),
                  CourseStructure(
                      name: "دراسة مقتطف من بيان أول نوفمبر", content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "التاريخ الوطني",
                courses: [
                  CourseStructure(
                      name: "الاحتلال الفرنسي للجزائر والمقاومة الوطنية",
                      content: ''''''),
                  CourseStructure(name: "الثورة التحريرية", content: ''''''),
                  CourseStructure(
                      name: "مراحل الثورة التحريرية", content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
              ChapterStructure(
                name: "التاريخ العام",
                courses: [
                  CourseStructure(
                      name: "بؤر التوتر في العالم", content: ''''''),
                  CourseStructure(
                      name:
                          "أبعاد الصراع في بؤرة من بؤر التوتر في العالم - القضية الفلسطينية",
                      content: ''''''),
                  CourseStructure(
                      name: "موقف الجزائر من القضايا العادلة في العالم",
                      content: ''''''),
                ],
                backgroundImage: "assets/images/chapter.png",
              ),
            ],
          ),
        ],
      ),
    },
  ),
  'الثانوي': EducationLevel(
    name: 'الثانوي',
    years: {
      'الأولى ثانوي': YearStructure(
        name: 'الأولى ثانوي',
        departments: {
          "أدبي": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "العالم الإسلامي ووضعه الداخلي وعلاقاته الخارجية",
                  courses: [
                    CourseStructure(
                        name: "أوضاع العالم الإسلامي", content: ''''''),
                    CourseStructure(
                        name: "العلاقات الداخلية للعالم الإسلامي",
                        content: ''''''),
                    CourseStructure(
                        name: "علاقات العالم الإسلامي الخارجية وانعكاساتها",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name: "التحولات الكبرى في أوروبا",
                  courses: [
                    CourseStructure(name: "النهضة ومظاهرها", content: ''''''),
                    CourseStructure(
                        name: "أهم الثورات السياسية", content: ''''''),
                    CourseStructure(
                        name: "الثورة السياسية والحركات القومية",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name: "الجزائر في العصر الحديث",
                  courses: [
                    CourseStructure(
                        name: "من المغرب الأوسط إلى الجزائر", content: ''''''),
                    CourseStructure(
                        name: "الدولة الجزائرية في ظل الحكم العثماني",
                        content: ''''''),
                    CourseStructure(
                        name: "علاقات الجزائر الخارجية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
          "علمي": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "العالم الإسلامي ووضعه الداخلي وعلاقاته الخارجية",
                  courses: [
                    CourseStructure(
                        name: "أوضاع العالم الإسلامي", content: ''''''),
                    CourseStructure(
                        name: "العلاقات الداخلية للعالم الإسلامي",
                        content: ''''''),
                    CourseStructure(
                        name: "علاقات العالم الإسلامي الخارجية وانعكاساتها",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name: "التحولات الكبرى في أوروبا",
                  courses: [
                    CourseStructure(name: "النهضة ومظاهرها", content: ''''''),
                    CourseStructure(
                        name: "أهم الثورات السياسية", content: ''''''),
                    CourseStructure(
                        name: "الثورة السياسية والحركات القومية",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name: "الجزائر في العصر الحديث",
                  courses: [
                    CourseStructure(
                        name: "من المغرب الأوسط إلى الجزائر", content: ''''''),
                    CourseStructure(
                        name: "الدولة الجزائرية في ظل الحكم العثماني",
                        content: ''''''),
                    CourseStructure(
                        name: "علاقات الجزائر الخارجية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
        },
        semesters: null,
      ),
      'الثانية ثانوي': YearStructure(
        name: 'الثانية ثانوي',
        departments: {
          "رياضيات": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "الاستعمار الأوروبي في أفريقيا وآسيا ومقاومته",
                  courses: [
                    CourseStructure(
                        name: "الحركة الاستعمارية (الظروف والأسباب والأهداف)",
                        content: ''''''),
                    CourseStructure(
                        name: "السياسة الاستعمارية في أفريقيا وآسيا",
                        content: ''''''),
                    CourseStructure(
                        name: "الكفاح التحرري في أفريقيا وآسيا",
                        content: ''''''),
                    CourseStructure(name: "الحركات التحررية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name:
                      "العلاقات الأوروبية/الأوروبية وانعكاساتها القارية والعالمية",
                  courses: [
                    CourseStructure(
                        name: "طبيعة العلاقات الأوروبية/الأوروبية ومظاهرها",
                        content: ''''''),
                    CourseStructure(
                        name: "المواجهة العسكرية الأوروبية الأولى 1914-1918",
                        content: ''''''),
                    CourseStructure(
                        name: "المواجهة العسكرية الأوروبية الثانية 1939-1945",
                        content: ''''''),
                    CourseStructure(
                        name: "تطور العالم عقب المواجهة العسكرية الثانية",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name:
                      "الاستعمار الفرنسي في الجزائر والمقاومة الوطنية 1830-1954",
                  courses: [
                    CourseStructure(
                        name: "ظروف وأسباب وأهداف الاستعمار الفرنسي للجزائر",
                        content: ''''''),
                    CourseStructure(
                        name:
                            "السياسة الاستعمارية الفرنسية في الجزائر ومظاهرها",
                        content: ''''''),
                    CourseStructure(
                        name:
                            "انعكاسات السياسة الاستعمارية على المجتمع الجزائري",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
          "علوم تجريبية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "الاستعمار الأوروبي في أفريقيا وآسيا ومقاومته",
                  courses: [
                    CourseStructure(
                        name: "الحركة الاستعمارية (الظروف والأسباب والأهداف)",
                        content: ''''''),
                    CourseStructure(
                        name: "السياسة الاستعمارية في أفريقيا وآسيا",
                        content: ''''''),
                    CourseStructure(
                        name: "الكفاح التحرري في أفريقيا وآسيا",
                        content: ''''''),
                    CourseStructure(name: "الحركات التحررية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name:
                      "العلاقات الأوروبية/الأوروبية وانعكاساتها القارية والعالمية",
                  courses: [
                    CourseStructure(
                        name: "طبيعة العلاقات الأوروبية/الأوروبية ومظاهرها",
                        content: ''''''),
                    CourseStructure(
                        name: "المواجهة العسكرية الأوروبية الأولى 1914-1918",
                        content: ''''''),
                    CourseStructure(
                        name: "المواجهة العسكرية الأوروبية الثانية 1939-1945",
                        content: ''''''),
                    CourseStructure(
                        name: "تطور العالم عقب المواجهة العسكرية الثانية",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name:
                      "الاستعمار الفرنسي في الجزائر والمقاومة الوطنية 1830-1954",
                  courses: [
                    CourseStructure(
                        name: "ظروف وأسباب وأهداف الاستعمار الفرنسي للجزائر",
                        content: ''''''),
                    CourseStructure(
                        name:
                            "السياسة الاستعمارية الفرنسية في الجزائر ومظاهرها",
                        content: ''''''),
                    CourseStructure(
                        name:
                            "انعكاسات السياسة الاستعمارية على المجتمع الجزائري",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
          "تقني رياضي": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "الاستعمار الأوروبي في أفريقيا وآسيا ومقاومته",
                  courses: [
                    CourseStructure(
                        name: "الحركة الاستعمارية (الظروف والأسباب والأهداف)",
                        content: ''''''),
                    CourseStructure(
                        name: "السياسة الاستعمارية في أفريقيا وآسيا",
                        content: ''''''),
                    CourseStructure(
                        name: "الكفاح التحرري في أفريقيا وآسيا",
                        content: ''''''),
                    CourseStructure(name: "الحركات التحررية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name:
                      "العلاقات الأوروبية/الأوروبية وانعكاساتها القارية والعالمية",
                  courses: [
                    CourseStructure(
                        name: "طبيعة العلاقات الأوروبية/الأوروبية ومظاهرها",
                        content: ''''''),
                    CourseStructure(
                        name: "المواجهة العسكرية الأوروبية الأولى 1914-1918",
                        content: ''''''),
                    CourseStructure(
                        name: "المواجهة العسكرية الأوروبية الثانية 1939-1945",
                        content: ''''''),
                    CourseStructure(
                        name: "تطور العالم عقب المواجهة العسكرية الثانية",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name:
                      "الاستعمار الفرنسي في الجزائر والمقاومة الوطنية 1830-1954",
                  courses: [
                    CourseStructure(
                        name: "ظروف وأسباب وأهداف الاستعمار الفرنسي للجزائر",
                        content: ''''''),
                    CourseStructure(
                        name:
                            "السياسة الاستعمارية الفرنسية في الجزائر ومظاهرها",
                        content: ''''''),
                    CourseStructure(
                        name:
                            "انعكاسات السياسة الاستعمارية على المجتمع الجزائري",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
          "تسيير وإقتصاد": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "الاستعمار الأوروبي في أفريقيا وآسيا ومقاومته",
                  courses: [
                    CourseStructure(
                        name: "الحركة الاستعمارية (الظروف والأسباب والأهداف)",
                        content: ''''''),
                    CourseStructure(
                        name: "السياسة الاستعمارية في أفريقيا وآسيا",
                        content: ''''''),
                    CourseStructure(
                        name: "الكفاح التحرري في أفريقيا وآسيا",
                        content: ''''''),
                    CourseStructure(name: "الحركات التحررية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name:
                      "العلاقات الأوروبية/الأوروبية وانعكاساتها القارية والعالمية",
                  courses: [
                    CourseStructure(
                        name: "طبيعة العلاقات الأوروبية/الأوروبية ومظاهرها",
                        content: ''''''),
                    CourseStructure(
                        name: "المواجهة العسكرية الأوروبية الأولى 1914-1918",
                        content: ''''''),
                    CourseStructure(
                        name: "المواجهة العسكرية الأوروبية الثانية 1939-1945",
                        content: ''''''),
                    CourseStructure(
                        name: "تطور العالم عقب المواجهة العسكرية الثانية",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name:
                      "الاستعمار الفرنسي في الجزائر والمقاومة الوطنية 1830-1954",
                  courses: [
                    CourseStructure(
                        name: "ظروف وأسباب وأهداف الاستعمار الفرنسي للجزائر",
                        content: ''''''),
                    CourseStructure(
                        name:
                            "السياسة الاستعمارية الفرنسية في الجزائر ومظاهرها",
                        content: ''''''),
                    CourseStructure(
                        name:
                            "انعكاسات السياسة الاستعمارية على المجتمع الجزائري",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
          "آداب وفلسفة": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "الاستعمار الأوروبي في أفريقيا وآسيا ومقاومته",
                  courses: [
                    CourseStructure(
                        name: "الحركة الاستعمارية (الظروف والأسباب والأهداف)",
                        content: ''''''),
                    CourseStructure(
                        name: "السياسة الاستعمارية في أفريقيا وآسيا",
                        content: ''''''),
                    CourseStructure(
                        name: "الكفاح التحرري في أفريقيا وآسيا",
                        content: ''''''),
                    CourseStructure(name: "الحركات التحررية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name:
                      "العلاقات الأوروبية/الأوروبية وانعكاساتها القارية والعالمية",
                  courses: [
                    CourseStructure(
                        name: "طبيعة العلاقات الأوروبية/الأوروبية ومظاهرها",
                        content: ''''''),
                    CourseStructure(
                        name: "المواجهة العسكرية الأوروبية الأولى 1914-1918",
                        content: ''''''),
                    CourseStructure(
                        name: "المواجهة العسكرية الأوروبية الثانية 1939-1945",
                        content: ''''''),
                    CourseStructure(
                        name: "تطور العالم عقب المواجهة العسكرية الثانية",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name:
                      "الاستعمار الفرنسي في الجزائر والمقاومة الوطنية 1830-1954",
                  courses: [
                    CourseStructure(
                        name: "ظروف وأسباب وأهداف الاستعمار الفرنسي للجزائر",
                        content: ''''''),
                    CourseStructure(
                        name:
                            "السياسة الاستعمارية الفرنسية في الجزائر ومظاهرها",
                        content: ''''''),
                    CourseStructure(
                        name:
                            "انعكاسات السياسة الاستعمارية على المجتمع الجزائري",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
          "لغات أجنبية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "الاستعمار الأوروبي في أفريقيا وآسيا ومقاومته",
                  courses: [
                    CourseStructure(
                        name: "الحركة الاستعمارية (الظروف والأسباب والأهداف)",
                        content: ''''''),
                    CourseStructure(
                        name: "السياسة الاستعمارية في أفريقيا وآسيا",
                        content: ''''''),
                    CourseStructure(
                        name: "الكفاح التحرري في أفريقيا وآسيا",
                        content: ''''''),
                    CourseStructure(name: "الحركات التحررية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name:
                      "العلاقات الأوروبية/الأوروبية وانعكاساتها القارية والعالمية",
                  courses: [
                    CourseStructure(
                        name: "طبيعة العلاقات الأوروبية/الأوروبية ومظاهرها",
                        content: ''''''),
                    CourseStructure(
                        name: "المواجهة العسكرية الأوروبية الأولى 1914-1918",
                        content: ''''''),
                    CourseStructure(
                        name: "المواجهة العسكرية الأوروبية الثانية 1939-1945",
                        content: ''''''),
                    CourseStructure(
                        name: "تطور العالم عقب المواجهة العسكرية الثانية",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name:
                      "الاستعمار الفرنسي في الجزائر والمقاومة الوطنية 1830-1954",
                  courses: [
                    CourseStructure(
                        name: "ظروف وأسباب وأهداف الاستعمار الفرنسي للجزائر",
                        content: ''''''),
                    CourseStructure(
                        name:
                            "السياسة الاستعمارية الفرنسية في الجزائر ومظاهرها",
                        content: ''''''),
                    CourseStructure(
                        name:
                            "انعكاسات السياسة الاستعمارية على المجتمع الجزائري",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
        },
        semesters: null,
      ),
      'الثالثة ثانوي': YearStructure(
        name: 'الثالثة ثانوي',
        departments: {
          "رياضيات": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "تطور العالم في ظل الثنائية القطبية",
                  courses: [
                    CourseStructure(name: "بروز الصراع", content: ''''''),
                    CourseStructure(name: "قيادة العالم", content: ''''''),
                    CourseStructure(name: "الأزمات الدولية", content: ''''''),
                    CourseStructure(name: "مساعي الانفراج", content: ''''''),
                    CourseStructure(
                        name: "من الثنائية إلى الأحادية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name: "تطور العالم الثالث (1945 - 1989)",
                  courses: [
                    CourseStructure(
                        name: "بين تراجع الاستعمار", content: ''''''),
                    CourseStructure(
                        name: "استمرارية حركات التحرر", content: ''''''),
                    CourseStructure(
                        name: "انعكاسات علاقات الثنائية القطبية على العالم",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
          "علوم تجريبية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "تطور العالم في ظل الثنائية القطبية",
                  courses: [
                    CourseStructure(name: "بروز الصراع", content: ''''''),
                    CourseStructure(name: "قيادة العالم", content: ''''''),
                    CourseStructure(name: "الأزمات الدولية", content: ''''''),
                    CourseStructure(name: "مساعي الانفراج", content: ''''''),
                    CourseStructure(
                        name: "من الثنائية إلى الأحادية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name: "تطور العالم الثالث (1945 - 1989)",
                  courses: [
                    CourseStructure(
                        name: "بين تراجع الاستعمار", content: ''''''),
                    CourseStructure(
                        name: "استمرارية حركات التحرر", content: ''''''),
                    CourseStructure(
                        name: "انعكاسات علاقات الثنائية القطبية على العالم",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
          "تقني رياضي": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "تطور العالم في ظل الثنائية القطبية",
                  courses: [
                    CourseStructure(name: "بروز الصراع", content: ''''''),
                    CourseStructure(name: "قيادة العالم", content: ''''''),
                    CourseStructure(name: "الأزمات الدولية", content: ''''''),
                    CourseStructure(name: "مساعي الانفراج", content: ''''''),
                    CourseStructure(
                        name: "من الثنائية إلى الأحادية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name: "تطور العالم الثالث (1945 - 1989)",
                  courses: [
                    CourseStructure(
                        name: "بين تراجع الاستعمار", content: ''''''),
                    CourseStructure(
                        name: "استمرارية حركات التحرر", content: ''''''),
                    CourseStructure(
                        name: "انعكاسات علاقات الثنائية القطبية على العالم",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
          "تسيير وإقتصاد": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "تطور العالم في ظل الثنائية القطبية",
                  courses: [
                    CourseStructure(name: "بروز الصراع", content: ''''''),
                    CourseStructure(name: "قيادة العالم", content: ''''''),
                    CourseStructure(name: "الأزمات الدولية", content: ''''''),
                    CourseStructure(name: "مساعي الانفراج", content: ''''''),
                    CourseStructure(
                        name: "من الثنائية إلى الأحادية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name: "تطور العالم الثالث (1945 - 1989)",
                  courses: [
                    CourseStructure(
                        name: "بين تراجع الاستعمار", content: ''''''),
                    CourseStructure(
                        name: "استمرارية حركات التحرر", content: ''''''),
                    CourseStructure(
                        name: "انعكاسات علاقات الثنائية القطبية على العالم",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
          "آداب وفلسفة": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "تطور العالم في ظل الثنائية القطبية",
                  courses: [
                    CourseStructure(name: "بروز الصراع", content: ''''''),
                    CourseStructure(name: "قيادة العالم", content: ''''''),
                    CourseStructure(name: "الأزمات الدولية", content: ''''''),
                    CourseStructure(name: "مساعي الانفراج", content: ''''''),
                    CourseStructure(
                        name: "من الثنائية إلى الأحادية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name: "تطور العالم الثالث (1945 - 1989)",
                  courses: [
                    CourseStructure(
                        name: "بين تراجع الاستعمار", content: ''''''),
                    CourseStructure(
                        name: "استمرارية حركات التحرر", content: ''''''),
                    CourseStructure(
                        name: "انعكاسات علاقات الثنائية القطبية على العالم",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
          "لغات أجنبية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [
                ChapterStructure(
                  name: "تطور العالم في ظل الثنائية القطبية",
                  courses: [
                    CourseStructure(name: "بروز الصراع", content: ''''''),
                    CourseStructure(name: "قيادة العالم", content: ''''''),
                    CourseStructure(name: "الأزمات الدولية", content: ''''''),
                    CourseStructure(name: "مساعي الانفراج", content: ''''''),
                    CourseStructure(
                        name: "من الثنائية إلى الأحادية", content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
                ChapterStructure(
                  name: "تطور العالم الثالث (1945 - 1989)",
                  courses: [
                    CourseStructure(
                        name: "بين تراجع الاستعمار", content: ''''''),
                    CourseStructure(
                        name: "استمرارية حركات التحرر", content: ''''''),
                    CourseStructure(
                        name: "انعكاسات علاقات الثنائية القطبية على العالم",
                        content: ''''''),
                  ],
                  backgroundImage: "assets/images/chapter.png",
                ),
              ],
            ),
          ],
        },
        semesters: null,
      ),
    },
  ),
  'الجامعي': EducationLevel(
    name: 'الجامعي',
    years: {
      'الأولى جامعي': YearStructure(
        name: 'الأولى جامعي',
        departments: {
          "تاريخ": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم سياسية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم إجتماعية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "فلسفة": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم إنسانية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
        },
        semesters: null,
      ),
      'الثانية جامعي': YearStructure(
        name: 'الثانية جامعي',
        departments: {
          "تاريخ": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم سياسية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم إجتماعية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "فلسفة": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم إنسانية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
        },
        semesters: null,
      ),
      'الثالثة جامعي': YearStructure(
        name: 'الثالثة جامعي',
        departments: {
          "تاريخ": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم سياسية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم إجتماعية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "فلسفة": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم إنسانية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
        },
        semesters: null,
      ),
      'الرابعة جامعي': YearStructure(
        name: 'الرابعة جامعي',
        departments: {
          "تاريخ": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم سياسية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم إجتماعية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "فلسفة": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم إنسانية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
        },
        semesters: null,
      ),
      'الخامسة جامعي': YearStructure(
        name: 'الخامسة جامعي',
        departments: {
          "تاريخ": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم سياسية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم إجتماعية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "فلسفة": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
          "علوم إنسانية": [
            Semester(
              name: 'الفصل الأول',
              chapters: [],
            ),
          ],
        },
        semesters: null,
      ),
      // Add other university years...
    },
  ),
};
