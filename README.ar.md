<p align="center">
  <a href="https://opencode.ai">
    <picture>
      <source srcset="packages/console/app/src/asset/logo-ornate-dark.svg" media="(prefers-color-scheme: dark)">
      <source srcset="packages/console/app/src/asset/logo-ornate-light.svg" media="(prefers-color-scheme: light)">
      <img src="packages/console/app/src/asset/logo-ornate-light.svg" alt="شعار OpenCode">
    </picture>
  </a>
</p>
<p align="center">وكيل برمجة بالذكاء الاصطناعي مفتوح المصدر.</p>
<p align="center">
  <a href="https://github.com/adulash/opencode"><img alt="GitHub" src="https://img.shields.io/badge/GitHub-adulash%2Fopencode-181717?style=flat-square&logo=github" /></a>
  <a href="mailto:adula.dev@gmail.com"><img alt="Email" src="https://img.shields.io/badge/email-adula.dev%40gmail.com-blue?style=flat-square" /></a>
  <a href="https://github.com/adulash/opencode/releases/latest"><img alt="Latest release" src="https://img.shields.io/github/v/release/adulash/opencode?style=flat-square" /></a>
</p>

<p align="center">
  <a href="README.md">English</a> |
  <a href="README.ar.md">العربية</a>
</p>

[![OpenCode Terminal UI](packages/web/src/assets/lander/screenshot.png)](https://opencode.ai)

---

### التثبيت

```bash
# Linux و macOS
curl -fsSL https://raw.githubusercontent.com/adulash/opencode/dev/install | bash
```

```powershell
# Windows
irm https://raw.githubusercontent.com/adulash/opencode/dev/install.ps1 | iex
```

يمكنك ايضا تنزيل الملف التنفيذي مباشرة من [صفحة الاصدارات](https://github.com/adulash/opencode/releases).

> [!NOTE]
> هذه النسخة تنشر اصداراتها الخاصة على GitHub، وهي **غير** منشورة على npm او Homebrew او Scoop او Chocolatey او AUR او nixpkgs — تلك الحزم تثبت OpenCode الاصلي بالانجليزية. استخدم الاوامر اعلاه للحصول على النسخة المعربة.

> [!TIP]
> احذف الاصدارات الاقدم من 0.1.x قبل التثبيت.

### تطبيق سطح المكتب (BETA)

يتوفر OpenCode ايضا كتطبيق سطح مكتب. نزله من [صفحة الاصدارات](https://github.com/adulash/opencode/releases) الخاصة بهذه النسخة.

| المنصة  | التنزيل                        |
| ------- | ------------------------------ |
| Windows | `opencode-desktop-win-x64.exe` |

> [!NOTE]
> هذه النسخة تبني تطبيق سطح المكتب لنظام Windows فقط حاليا، والمثبت غير موقع رقميا لذا قد يظهر تحذير SmartScreen عند اول تشغيل. على macOS و Linux استخدم امر تثبيت سطر الاوامر اعلاه. التطبيق يحدث نفسه من اصدارات هذا المستودع.

#### مجلد التثبيت

يحترم سكربت التثبيت ترتيب الاولوية التالي لمسار التثبيت:

1. `$OPENCODE_INSTALL_DIR` - مجلد تثبيت مخصص
2. `$XDG_BIN_DIR` - مسار متوافق مع مواصفات XDG Base Directory
3. `$HOME/bin` - مجلد الثنائيات القياسي للمستخدم (ان وجد او امكن انشاؤه)
4. `$HOME/.opencode/bin` - المسار الافتراضي الاحتياطي

```bash
# امثلة
OPENCODE_INSTALL_DIR=/usr/local/bin curl -fsSL https://raw.githubusercontent.com/adulash/opencode/dev/install | bash
XDG_BIN_DIR=$HOME/.local/bin curl -fsSL https://raw.githubusercontent.com/adulash/opencode/dev/install | bash
```

### Agents

يتضمن OpenCode وكيليْن (Agents) مدمجين يمكنك التبديل بينهما باستخدام زر `Tab`.

- **build** - الافتراضي، وكيل بصلاحيات كاملة لاعمال التطوير
- **plan** - وكيل للقراءة فقط للتحليل واستكشاف الكود
  - يرفض تعديل الملفات افتراضيا
  - يطلب الاذن قبل تشغيل اوامر bash
  - مثالي لاستكشاف قواعد كود غير مألوفة او لتخطيط التغييرات

بالاضافة الى ذلك يوجد وكيل فرعي **general** للبحث المعقد والمهام متعددة الخطوات.
يستخدم داخليا ويمكن استدعاؤه بكتابة `@general` في الرسائل.

تعرف على المزيد حول [agents](https://opencode.ai/docs/agents).

### التوثيق

لمزيد من المعلومات حول كيفية ضبط OpenCode، [**راجع التوثيق**](https://opencode.ai/docs).

### المساهمة

اذا كنت مهتما بالمساهمة في OpenCode، يرجى قراءة [contributing docs](./CONTRIBUTING.md) قبل ارسال pull request.

### البناء فوق OpenCode

اذا كنت تعمل على مشروع مرتبط بـ OpenCode ويستخدم "opencode" كجزء من اسمه (مثل "opencode-dashboard" او "opencode-mobile")، يرجى اضافة ملاحظة في README توضح انه ليس مبنيا بواسطة فريق OpenCode ولا يرتبط بنا بأي شكل.

### FAQ

#### ما الفرق عن Claude Code؟

هو مشابه جدا لـ Claude Code من حيث القدرات. هذه هي الفروقات الاساسية:

- 100% مفتوح المصدر
- غير مقترن بمزود معين. نوصي بالنماذج التي نوفرها عبر [OpenCode Zen](https://opencode.ai/zen)؛ لكن يمكن استخدام OpenCode مع Claude او OpenAI او Google او حتى نماذج محلية. مع تطور النماذج ستتقلص الفجوات وستنخفض الاسعار، لذا من المهم ان يكون مستقلا عن المزود.
- دعم LSP جاهز للاستخدام
- تركيز على TUI. تم بناء OpenCode بواسطة مستخدمي neovim ومنشئي [terminal.shop](https://terminal.shop)؛ وسندفع حدود ما هو ممكن داخل الطرفية.
- معمارية عميل/خادم. على سبيل المثال، يمكن تشغيل OpenCode على جهازك بينما تقوده عن بعد من تطبيق جوال. هذا يعني ان واجهة TUI هي واحدة فقط من العملاء الممكنين.

---

## التواصل مع المطور

هذه النسخة يتولى صيانتها وتعريبها مطور مستقل. لأي سؤال او اقتراح او بلاغ عن خلل يخص هذه النسخة، استخدم القنوات التالية **وليس** قنوات مشروع OpenCode الاصلي:

| القناة | الرابط |
| --- | --- |
| المستودع | [github.com/adulash/opencode](https://github.com/adulash/opencode) |
| البلاغات والاقتراحات | [فتح issue جديد](https://github.com/adulash/opencode/issues/new/choose) |
| النقاشات العامة | [GitHub Discussions](https://github.com/adulash/opencode/discussions) |
| البريد الالكتروني | [adula.dev@gmail.com](mailto:adula.dev@gmail.com) |
| الثغرات الامنية | [تقرير خاص عبر GitHub Security](https://github.com/adulash/opencode/security/advisories/new) — او راجع [SECURITY.md](./SECURITY.md) |

---

## المصدر الاصلي والتعريب

هذا المشروع نسخة معدلة (fork) من مشروع **OpenCode** مفتوح المصدر:

- **المشروع الاصلي:** [github.com/anomalyco/opencode](https://github.com/anomalyco/opencode) — [opencode.ai](https://opencode.ai)
- **الرخصة:** MIT، وكل الحقوق والفضل في العمل الاصلي تعود لفريق OpenCode ومساهميه. راجع [LICENSE](./LICENSE).

**ما الذي تغير في هذه النسخة؟** تم تعريب المشروع بشكل احترافي بواسطة [adulash](https://github.com/adulash):

- ترجمة واجهات تطبيق سطح المكتب وواجهة الويب ولوحة التحكم الى العربية.
- تعريب التوثيق.
- دعم اتجاه الكتابة من اليمين الى اليسار (RTL) عبر الواجهات.
- معالجة مشكلات المحاذاة والتباين وعرض النصوص العربية داخل واجهة الطرفية (TUI).
- تعديلات وتحسينات اخرى.

> هذه النسخة **غير رسمية** وغير مرتبطة بفريق OpenCode. لا ترسل بلاغات هذه النسخة الى المستودع الاصلي، والعكس صحيح: اذا كان الخلل موجودا في OpenCode الاصلي فمن الافضل الابلاغ عنه هناك ايضا.
