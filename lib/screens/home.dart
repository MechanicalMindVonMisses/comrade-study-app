import 'package:material_ui/material_ui.dart';

import '../data.dart';
import '../main.dart' show Brand;
import '../nav.dart';
import '../store.dart';
import '../theme.dart';

const _forms = [
  ('I', 'A shared room', 'From the Latin camera: a chamber or vault that makes an inside apart from an outside and holds it open. Dean calls comradeship a political relation of supported cover.'),
  ('II', 'A form of address', '“Comrade” takes the place of Sir, Madam and Citizen. It equalizes—and reminds the one addressed that something is expected of them.'),
  ('III', 'The same side', 'Anyone, but not everyone, can be a comrade. Belonging presupposes a division; the sameness of comrades is sameness with respect to a side.'),
  ('IV', 'An ego ideal', 'Belonging works back on those who belong. You see your own work through your comrades’ eyes and are accountable to them.'),
  ('V', 'Fidelity to a truth', 'Comrades are bound not by identity but by fidelity to a political truth, made real through common, disciplined work in an organized body.'),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final next = store.nextLesson;
          final started = store.completedCount > 0;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _Hero(next: next, started: started),
              const _Ledger(),
              if (started) _ContinueStrip(next: next),
              const _Route(),
              const _FormsPlayer(),
              const _Critical(),
              const _SourceBanner(),
              const _Footer(),
            ],
          );
        },
      );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.next, required this.started});
  final Lesson next;
  final bool started;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Jodi Dean’s essay on political belonging'),
            Text.rich(
              TextSpan(children: [
                const TextSpan(text: 'From the\n'),
                TextSpan(
                  text: 'ally\n',
                  style: reading(60, weight: 430, italic: true, height: 0.98).copyWith(letterSpacing: -3),
                ),
                const TextSpan(text: 'to the comrade.'),
              ]),
              style: display(56, height: 0.98),
            ),
            const SizedBox(height: 22),
            Text.rich(
              TextSpan(children: [
                const TextSpan(text: 'A rigorous, interactive path through '),
                TextSpan(text: 'Comrade', style: reading(18, italic: true, color: C.muted)),
                const TextSpan(text: '—Dean’s case that the left must move from allies to comrades, from the critique of allyship to the four theses and the ways comradeship ends.'),
              ]),
              style: reading(18, color: C.muted, height: 1.5),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              started ? 'Continue learning' : 'Begin with lesson 01',
              icon: Icons.arrow_forward,
              expand: true,
              onPressed: () => AppNav.openLesson(context, next.id),
            ),
            const SizedBox(height: 8),
            UnderlinedLink(
              'Explore all ${course.lessons.length} lessons',
              onTap: () => AppNav.openModule(context, null),
            ),
            const SizedBox(height: 16),
            for (final proof in const ['No prior theory needed', 'Every section indexed', 'Works fully offline'])
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  const Icon(Icons.check, size: 16, color: C.forest),
                  const SizedBox(width: 8),
                  Flexible(child: Text(proof, style: display(12.5, weight: 500, height: 1.3))),
                ]),
              ),
            const SizedBox(height: 32),
            const _Notebooks(),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(children: [
                TextSpan(text: 'VERSO 2019  ', style: mono(11, spacing: 0.6)),
                const TextSpan(text: 'Four chapters. Four theses. One relation.'),
              ]),
              style: reading(15, color: C.muted, height: 1.4),
            ),
          ],
        ),
      );
}

/// Typographic sculpture: four chapters and four theses as a row of spines.
class _Notebooks extends StatelessWidget {
  const _Notebooks();

  static const _labels = ['1', '2', '3', '4', 'I', 'II', 'III', 'IV'];
  static const _colors = [C.ink, C.plum, C.forest, C.ink, C.plum, C.forest, C.ink, C.plum];
  static const _heights = [150.0, 176.0, 160.0, 186.0, 168.0, 154.0, 180.0, 164.0];

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: Container(
          height: 300,
          width: double.infinity,
          color: C.paperDeep,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 40,
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < _labels.length; i++)
                      Expanded(
                        child: Container(
                          height: _heights[i],
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.only(top: 8),
                          alignment: Alignment.topCenter,
                          color: _colors[i],
                          child: Text(_labels[i], style: mono(10, medium: true, color: C.paper, height: 1)),
                        ),
                      ),
                  ],
                ),
              ),
              Positioned(
                top: 24,
                child: Transform.rotate(
                  angle: -0.04,
                  child: Container(
                    width: 168,
                    height: 214,
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: C.coral,
                      boxShadow: [BoxShadow(color: Color(0x33120F0C), blurRadius: 24, offset: Offset(0, 12))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('§', style: display(34, weight: 650, height: 1)),
                            Text('AN ESSAY', style: mono(7.5, spacing: 0.9)),
                          ],
                        ),
                        const Spacer(),
                        Text('COM-\nRADE', style: display(27, weight: 720, height: 0.95)),
                        const SizedBox(height: 6),
                        Text('ON POLITICAL\nBELONGING', style: mono(7, spacing: 0.6, height: 1.3)),
                        const SizedBox(height: 8),
                        Container(height: 1, color: C.ink),
                        const SizedBox(height: 6),
                        Text('JODI DEAN · 2019', style: mono(8.5, spacing: 1.2)),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                child: Text('CHAPTERS 1–4 · THESES I–IV', style: mono(12, medium: true, spacing: 1)),
              ),
            ],
          ),
        ),
      );
}

class _Ledger extends StatelessWidget {
  const _Ledger();

  @override
  Widget build(BuildContext context) {
    final cells = [
      ('${course.lessons.length}', 'guided lessons'),
      ('${course.passageCount}', 'indexed passages'),
      ('${course.quizCount}', 'knowledge checks'),
      ('04', 'interactive labs'),
    ];
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: C.ink), bottom: BorderSide(color: C.ink)),
      ),
      child: Column(
        children: [
          for (var row = 0; row < 2; row++)
            IntrinsicHeight(
              child: Row(
                children: [
                  for (var col = 0; col < 2; col++)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
                        decoration: BoxDecoration(
                          border: Border(
                            right: col == 0 ? const BorderSide(color: C.lineSoft) : BorderSide.none,
                            bottom: row == 0 ? const BorderSide(color: C.lineSoft) : BorderSide.none,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cells[row * 2 + col].$1, style: display(40, weight: 600, height: 1)),
                            const SizedBox(height: 6),
                            Text(cells[row * 2 + col].$2.toUpperCase(), style: mono(10, color: C.muted, spacing: 0.8)),
                          ],
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

class _ContinueStrip extends StatelessWidget {
  const _ContinueStrip({required this.next});
  final Lesson next;

  @override
  Widget build(BuildContext context) => Container(
        color: C.ink,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow('Your study · ${store.percent}% complete', color: C.accentSoft),
            Text('${next.number}. ${next.title}', style: display(26, color: C.paper)),
            const SizedBox(height: 14),
            ProgressLine(store.percent / 100, track: C.lineStrong),
            const SizedBox(height: 18),
            SecondaryButton(
              'Continue',
              icon: Icons.arrow_forward,
              foreground: C.paper,
              onPressed: () => AppNav.openLesson(context, next.id),
            ),
          ],
        ),
      );
}

class _Route extends StatelessWidget {
  const _Route();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 44, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow('Your route through the book'),
                  Text('Six levels.\nOne relation.', style: display(38, height: 1.02)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(color: C.ink),
            for (final module in course.modules)
              InkWell(
                onTap: () => AppNav.openModule(context, module.id),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: C.lineSoft)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 44,
                        child: Text(module.index, style: reading(26, italic: true, color: C.coral, height: 1.1)),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(module.title, style: display(20, height: 1.15)),
                            const SizedBox(height: 4),
                            Text(module.subtitle.toUpperCase(), style: mono(10, color: C.muted, spacing: 0.7)),
                            const SizedBox(height: 8),
                            Text(module.description, style: reading(15, color: C.muted, height: 1.45)),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8, top: 2),
                        child: Icon(Icons.south_east, size: 22),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
}

class _FormsPlayer extends StatefulWidget {
  const _FormsPlayer();

  @override
  State<_FormsPlayer> createState() => _FormsPlayerState();
}

class _FormsPlayerState extends State<_FormsPlayer> {
  int step = 1;

  @override
  Widget build(BuildContext context) {
    final (numeral, title, text) = _forms[step];
    return Container(
      color: C.plum,
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('A concept you can touch · ch. 1–3', color: C.accentSoft),
          const PageTitle('The comrade in\n', 'five moves.', size: 34, color: C.paper),
          const SizedBox(height: 16),
          Text(
            'Dean builds the comrade step by step, from a shared room to fidelity to a truth. Step through the moves and ask: what binds these people together—and what does it ask of them?',
            style: reading(16.5, color: C.paperDeep, height: 1.5),
          ),
          const SizedBox(height: 8),
          UnderlinedLink(
            'Read the lesson on the fourth thesis',
            icon: Icons.east,
            color: C.paper,
            onTap: () => AppNav.openLesson(context, 'fidelity-truth'),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              for (var i = 0; i < _forms.length; i++) ...[
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: step == i,
                    label: 'Move ${i + 1}: ${_forms[i].$2}',
                    child: InkWell(
                      onTap: () => setState(() => step = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: step == i ? C.coral : Colors.transparent,
                          border: Border.all(color: step == i ? C.coral : C.paperDeep.withValues(alpha: 0.45)),
                        ),
                        child: ExcludeSemantics(
                          child: Text(
                            _forms[i].$1,
                            style: reading(18, italic: true, color: step == i ? C.ink : C.paper, height: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (i < _forms.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text('→', style: mono(11, color: C.accentSoft, height: 1)),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border.all(color: C.paperDeep.withValues(alpha: 0.45))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(numeral, style: reading(64, italic: true, color: C.coral, height: 1)),
                const SizedBox(height: 12),
                Eyebrow('Move ${step + 1} of ${_forms.length}', color: C.accentSoft, bottom: 8),
                Text(title, style: display(24, color: C.paper)),
                const SizedBox(height: 8),
                Text(text, style: reading(16, color: C.paperDeep, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            'Next move',
            icon: Icons.arrow_forward,
            foreground: C.paper,
            onPressed: () => setState(() => step = (step + 1) % _forms.length),
          ),
        ],
      ),
    );
  }
}

class _Critical extends StatelessWidget {
  const _Critical();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 44, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Not a certainty machine'),
            Text.rich(
              TextSpan(children: [
                const TextSpan(text: '“Read the essay.\nTest the examples.\n'),
                TextSpan(
                  text: 'Keep the questions open.”',
                  style: reading(33, weight: 430, italic: true, color: C.coral, height: 1.12),
                ),
              ]),
              style: display(31, height: 1.12),
            ),
            const SizedBox(height: 20),
            Text(
              'Comrade is a polemic as well as a theory. Readers have welcomed it as an answer to left individualism and questioned its narrow archive and its defence of party discipline. This course separates what Dean argues, what her sources show, and what critics say.',
              style: reading(16.5, color: C.muted, height: 1.55),
            ),
            const SizedBox(height: 8),
            UnderlinedLink(
              'See the critical-reading lesson',
              onTap: () => AppNav.openLesson(context, 'end-of-world'),
            ),
          ],
        ),
      );
}

class _SourceBanner extends StatelessWidget {
  const _SourceBanner();

  @override
  Widget build(BuildContext context) => Container(
        color: C.paperDeep,
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.menu_book_outlined, size: 34),
            const SizedBox(height: 14),
            const Eyebrow('Always return to the text'),
            Text('The chapter-by-chapter reading room.', style: display(28, height: 1.08)),
            const SizedBox(height: 10),
            Text(
              'Sixty-four study sections across four chapters, a tracker for what you have read in your own copy, and free companion texts.',
              style: reading(16, color: C.muted, height: 1.5),
            ),
            const SizedBox(height: 18),
            SecondaryButton(
              'Enter the library',
              icon: Icons.arrow_forward,
              onPressed: () => AppNav.goTab(context, AppNav.library),
            ),
          ],
        ),
      );
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) => Container(
        color: C.ink,
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 36),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Brand(color: C.paper),
            const SizedBox(height: 18),
            Text(
              'A guided reading of a short book about a big word.\nBuilt for careful readers, not converts.',
              style: reading(15.5, color: C.paperDeep, height: 1.5),
            ),
            const SizedBox(height: 12),
            UnderlinedLink('Start studying', color: C.paper, onTap: () => AppNav.openModule(context, null)),
            UnderlinedLink('Review concepts', color: C.paper, onTap: () => AppNav.goTab(context, AppNav.glossary)),
            UnderlinedLink(
              'Comrade at Verso',
              icon: Icons.north_east,
              color: C.paper,
              onTap: () => openUrl(context, course.downloads['book']!),
            ),
          ],
        ),
      );
}
