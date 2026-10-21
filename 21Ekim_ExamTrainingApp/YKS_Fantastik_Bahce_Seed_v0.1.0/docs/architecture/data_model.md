# Veri modeli ve doğrulama taslağı

Şema henüz uygulanmış değildir, TASK-003 ve sonraki görevlerde test edilerek oluşturulur.

| Varlık | Zorunlu alanlar | Not |
| --- | --- | --- |
| `StudentPreferences` | `id`, `displayName?`, `field?`, `targetDate?`, `themeMode`, `humorousExitEnabled` | Tek cihaz, giriş zorunlu değil |
| `Subject` | `id`, `stage`, `name`, `order` | stage: TYT / AYT |
| `Topic` | `id`, `subjectId`, `name`, `order`, `curriculumYear?` | Kaynak/yıl metadata |
| `TopicProgress` | `topicId`, `status`, `answeredCount`, `updatedAt` | Durum üçlü |
| `ExamSession` | `id`, `stage`, `occurredAt`, `title`, `scope`, `questionPlan` | Branş/kapsam esnek |
| `ExamScore` | `examId`, `subjectId`, `correct`, `wrong`, `blank`, `net` | Sınırların dışına çıkma |
| `DailyTask` | `id`, `scheduledDate`, `subjectId?`, `topicId?`, `description`, `targetQuestions`, `isDone` | Null target olabilir |
| `FocusSession` | `id`, `startedAt`, `elapsedSeconds`, `subjectId?`, `completed` | Duraklatma doğru |
| `CurriculumManifest` | `version`, `year`, `source`, `updatedAt` | Resmî olmayan içerik açık etiketli |

Net hesaplama: `correct - (wrong / 4.0)`. Doğru/yanlış/boş tamsayı >= 0; toplam soru sayısı aşılmamalıdır. Puan simülatörü için resmî katsayılar ayrı sürümlü veri modeliyle sağlanmalıdır.
