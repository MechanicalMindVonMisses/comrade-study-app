import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../data.dart';
import '../nav.dart';
import '../theme.dart';

const _labs = [
  ('accountability', 'Who shows up?', 'allies vs comrades'),
  ('scale', 'The many', 'survivors · systems'),
  ('relations', 'Five relations', 'kin → comrade'),
  ('discipline', 'Discipline', 'joy vs superego'),
];

class LabsScreen extends StatelessWidget {
  const LabsScreen({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
        valueListenable: AppNav.lab,
        builder: (context, requested, _) {
          final active = _labs.any((l) => l.$1 == requested) ? requested : 'accountability';
          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              const PageIntro(
                eyebrow: 'Interactive labs',
                plain: 'Put the comrade\n',
                emphasis: 'in motion.',
                body: 'Four arguments from Comrade, turned into deliberately simple models. Change one thing at a time, inspect the result, and read the assumption note before applying an idea to a real organization.',
                trailing: _Note('Models clarify mechanisms; they do not replace evidence.', icon: Icons.warning_amber),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: pagePadding,
                child: Row(
                  children: [
                    for (var i = 0; i < _labs.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Semantics(
                          button: true,
                          selected: active == _labs[i].$1,
                          child: Material(
                            color: active == _labs[i].$1 ? C.ink : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: active == _labs[i].$1 ? C.ink : C.lineSoft),
                            ),
                            child: InkWell(
                              onTap: () => AppNav.lab.value = _labs[i].$1,
                              child: Container(
                                width: 150,
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('0${i + 1}', style: mono(10, color: active == _labs[i].$1 ? C.accentSoft : C.coral, medium: true)),
                                    const SizedBox(height: 6),
                                    Text(_labs[i].$2, style: display(15, weight: 600, height: 1.2, color: active == _labs[i].$1 ? C.paper : C.ink)),
                                    const SizedBox(height: 4),
                                    Text(_labs[i].$3, style: mono(10.5, color: active == _labs[i].$1 ? C.paperDeep : C.muted)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: C.ink),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: switch (active) {
                  'scale' => const _ScaleLab(),
                  'relations' => const _RelationsLab(),
                  'discipline' => const _DisciplineLab(),
                  _ => const _AccountabilityLab(),
                },
              ),
            ],
          );
        },
      );
}

class _Note extends StatelessWidget {
  const _Note(this.text, {this.icon = Icons.balance});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(top: 2), child: Icon(icon, size: 17, color: C.muted)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: display(13, weight: 470, color: C.muted, height: 1.45))),
        ],
      );
}

class _LabHead extends StatelessWidget {
  const _LabHead(this.eyebrow, this.title, this.body);
  final String eyebrow;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(eyebrow),
          Text(title, style: display(29, height: 1.08)),
          const SizedBox(height: 10),
          Text(body, style: reading(16.5, color: C.muted, height: 1.55)),
          const SizedBox(height: 20),
        ],
      );
}

class _SliderField extends StatelessWidget {
  const _SliderField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
    this.unit = '',
  });
  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final String unit;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final divisions = ((max - min) / step).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: display(14, weight: 540, height: 1.3))),
              Text('${grouped(value)}$unit', style: mono(14, medium: true)),
            ],
          ),
          Semantics(
            label: label,
            value: '${grouped(value)}$unit',
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                tickMarkShape: SliderTickMarkShape.noTickMark,
              ),
              child: Slider(
                value: value.clamp(min, max).toDouble(),
                min: min.toDouble(),
                max: max.toDouble(),
                divisions: divisions < 1 ? null : divisions,
                padding: const EdgeInsets.symmetric(vertical: 4),
                onChanged: max > min ? (v) => onChanged(v.round()) : null,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${grouped(min)}$unit', style: mono(10, color: C.muted)),
              Text('${grouped(max)}$unit', style: mono(10, color: C.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metrics extends StatelessWidget {
  const _Metrics(this.items);
  final List<(String, String)> items;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(border: Border.all(color: C.lineSoft)),
        child: Column(
          children: [
            for (var row = 0; row < items.length; row += 2)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = row; i < row + 2 && i < items.length; i++)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border(
                              right: i.isEven ? const BorderSide(color: C.lineSoft) : BorderSide.none,
                              top: row > 0 ? const BorderSide(color: C.lineSoft) : BorderSide.none,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(items[i].$1.toUpperCase(), style: mono(9.5, color: C.muted, spacing: 0.5)),
                              const SizedBox(height: 8),
                              Text(items[i].$2, style: display(27, weight: 600, height: 1)),
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

class _FormulaLarge extends StatelessWidget {
  const _FormulaLarge(this.formula, this.value, this.caption);
  final String formula;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        color: C.ink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formula, style: reading(20, italic: true, color: C.accentSoft, height: 1.2)),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, style: mono(23, medium: true, color: C.paper, height: 1.2)),
            ),
            const SizedBox(height: 6),
            Text(caption.toUpperCase(), style: mono(9.5, color: C.paperDeep, spacing: 0.7)),
          ],
        ),
      );
}

/// A horizontal bar split into labelled segments, sized by value.
class _SplitBar extends StatelessWidget {
  const _SplitBar(this.segments, {this.semantics, this.height = 56});
  final List<(String, double, Color, Color)> segments;
  final String? semantics;
  final double height;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semantics ?? segments.map((s) => '${s.$1}: ${_h(s.$2)}').join(', '),
        child: ExcludeSemantics(
          child: SizedBox(
            height: height,
            child: Row(
              children: [
                for (final (label, value, bg, fg) in segments)
                  if (value > 0.0001)
                    Expanded(
                      flex: (value * 1000).round().clamp(1, 1 << 30),
                      child: Container(
                        color: bg,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          label,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          style: display(11, weight: 600, color: fg, height: 1.15),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      );
}

String _h(double hours) {
  final rounded = (hours * 10).round() / 10;
  return rounded == rounded.roundToDouble() ? '${rounded.round()} h' : '${rounded.toStringAsFixed(1)} h';
}

Widget _resetButton(VoidCallback onPressed) => TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh, size: 16, color: C.ink),
      label: Text('Reset example', style: display(13, height: 1.2).copyWith(decoration: TextDecoration.underline)),
      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 44)),
    );

String _pct(double share) => '${(share * 100).round()}%';

/// A row of thin vertical bars (values 0–1), optionally highlighting one.
class _Bars extends StatelessWidget {
  const _Bars(this.values, this.color, {this.highlight, this.semantics = ''});
  final List<double> values;
  final Color color;
  final int? highlight;
  final String semantics;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semantics,
        child: ExcludeSemantics(
          child: Container(
            height: 64,
            color: C.paperDeep,
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < values.length; i++)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      height: 2 + 58 * values[i].clamp(0.0, 1.0),
                      color: i == highlight ? C.coral : color,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}

class _Verdict extends StatelessWidget {
  const _Verdict(this.text, this.tone);
  final String text;
  final Color tone;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: C.raised, border: Border(left: BorderSide(color: tone, width: 3))),
        child: Semantics(liveRegion: true, child: Text(text, style: reading(16, height: 1.5))),
      );
}

// ───────────────────────────── 01 · Who shows up? ─────────────────────────────

class _AccountabilityLab extends StatefulWidget {
  const _AccountabilityLab();

  @override
  State<_AccountabilityLab> createState() => _AccountabilityLabState();
}

class _AccountabilityLabState extends State<_AccountabilityLab> {
  int cost = 50, account = 60, weeks = 26, group = 20;

  /// Weekly turnout share. Allies: each person's willingness erodes with the
  /// grind. Comrades: the same erosion, softened by accountability, plus a pull
  /// toward showing up when others do (and away from it below a 40% threshold).
  List<double> _run(double a) {
    final f = cost / 100 * 0.04;
    var p = 0.9;
    final out = <double>[p];
    for (var t = 1; t <= weeks; t++) {
      p = (p - f * (1 - a) + a * 0.05 * (p - 0.4)).clamp(0.0, 1.0);
      out.add(p);
    }
    return out;
  }

  List<double> _sample(List<double> xs) {
    const n = 13;
    return [for (var i = 0; i < n; i++) xs[(i * (xs.length - 1) / (n - 1)).round()]];
  }

  @override
  Widget build(BuildContext context) {
    final ally = _run(0);
    final comrade = _run(account / 100);
    final a = ally.last, c = comrade.last;
    final tone = c >= 0.6 ? C.forest : (c >= 0.3 ? C.coral : C.error);
    final verdict = account == 0
        ? 'With no accountability the two groups are identical: everyone shows up only as long as their own comfort allows.'
        : c > comrade.first
            ? 'Accountability outweighs the grind. Because people see their work through each other’s eyes, turnout grows instead of eroding: by week $weeks about ${(c * group).round()} of $group still show up, against ${(a * group).round()} allies.'
            : c >= 0.4
                ? 'Accountability slows the erosion: by week $weeks about ${(c * group).round()} of $group comrades still show up, against ${(a * group).round()} allies.'
                : 'Below the threshold the expectation itself weakens—when few show up, there is no one to face the next day. Raise accountability or lower the cost to see the group recover.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LabHead(
          'Lesson 02 · ch. 1 §§3–4',
          'Who is still there in week 26?',
          'Two groups face the same grinding task—selling papers, phone banking. Allies show up as long as they personally feel like it. Comrades feel the same grind, but also answer to each other.',
        ),
        _SliderField(label: 'Cost of the task (grind)', value: cost, min: 0, max: 100, step: 5, unit: '%', onChanged: (x) => setState(() => cost = x)),
        _SliderField(label: 'Accountability to comrades', value: account, min: 0, max: 100, step: 5, unit: '%', onChanged: (x) => setState(() => account = x)),
        _SliderField(label: 'Length of the campaign', value: weeks, min: 4, max: 52, unit: ' wk', onChanged: (x) => setState(() => weeks = x)),
        _SliderField(label: 'People in each group', value: group, min: 5, max: 100, step: 5, onChanged: (x) => setState(() => group = x)),
        _resetButton(() => setState(() {
              cost = 50;
              account = 60;
              weeks = 26;
              group = 20;
            })),
        const SizedBox(height: 16),
        Text('ALLIES · TURNOUT OVER $weeks WEEKS', style: mono(10, spacing: 0.6)),
        const SizedBox(height: 8),
        _Bars(_sample(ally), C.lineStrong, semantics: 'Ally turnout falls to ${_pct(a)}'),
        const SizedBox(height: 14),
        Text('COMRADES · TURNOUT OVER $weeks WEEKS', style: mono(10, spacing: 0.6)),
        const SizedBox(height: 8),
        _Bars(_sample(comrade), C.forest, semantics: 'Comrade turnout ends at ${_pct(c)}'),
        const SizedBox(height: 16),
        const _FormulaLarge(
          'pₜ₊₁ = pₜ − f(1−a) + 0.05a(pₜ − 0.4)',
          'grind × (1 − accountability) + pull of others',
          'f = weekly erosion from the grind · a = accountability',
        ),
        const SizedBox(height: 16),
        _Metrics([
          ('Allies in week $weeks', '${(a * group).round()} / $group'),
          ('Comrades in week $weeks', '${(c * group).round()} / $group'),
          ('Ally turnout', _pct(a)),
          ('Comrade turnout', _pct(c)),
        ]),
        const SizedBox(height: 16),
        _Verdict(verdict, tone),
        const SizedBox(height: 16),
        const _Note('A toy model of Dean’s claim that comrades can count on each other even when the work is unpleasant. It leaves out disagreement, leadership, burnout and the risk—discussed in chapter four—that accountability turns punitive.'),
      ],
    );
  }
}

// ───────────────────────────── 02 · The many ─────────────────────────────

class _ScaleLab extends StatefulWidget {
  const _ScaleLab();

  @override
  State<_ScaleLab> createState() => _ScaleLabState();
}

class _ScaleLabState extends State<_ScaleLab> {
  int scale = 6, organized = 3, coordination = 50;

  static const _sup = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹'];
  static const _examples = [
    'one household',
    'a street',
    'a workplace',
    'a neighbourhood',
    'a town',
    'a city district',
    'a city',
    'a region',
    'a large country',
    'the planet',
  ];

  String _pow(num exp) => '10${_sup[exp.round().clamp(0, 9)]}';

  @override
  Widget build(BuildContext context) {
    // Effective capacity in "person-equivalents": the organized many, discounted
    // by how well they coordinate. Log10 so problems from 1 to 10⁹ fit one bar.
    final capLog = organized + _log10((coordination / 100).clamp(0.01, 1.0));
    final gap = (scale - capLog).clamp(0.0, 9.0);
    final reached = capLog >= scale;
    final tone = reached ? C.forest : (gap <= 2 ? C.coral : C.error);
    final verdict = reached
        ? 'Within reach. An organized side of this size can act on a problem at the scale of ${_examples[scale]}. Neither the lone survivor nor the spectator of systems has this capacity.'
        : 'Still ${gap.toStringAsFixed(1)} orders of magnitude short of a problem at the scale of ${_examples[scale]}. The survivor frame stops at one person; the systems frame stops at watching. Only more people, better organized, close the gap.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LabHead(
          'Lesson 04 · ch. 1 §§10–12',
          'Survivors, systems, and the organized many.',
          'Pick the scale of a problem. A survivor can act only on what one person can carry; a systems frame only observes. Add people on the same side and see when the problem comes within reach.',
        ),
        _SliderField(label: 'Scale of the problem (people affected, 10ⁿ)', value: scale, min: 0, max: 9, onChanged: (x) => setState(() => scale = x)),
        Text('${_pow(scale)} people · ${_examples[scale]}', style: mono(11, color: C.muted)),
        const SizedBox(height: 14),
        _SliderField(label: 'People organized on the same side (10ⁿ)', value: organized, min: 0, max: 9, onChanged: (x) => setState(() => organized = x)),
        Text('${_pow(organized)} people', style: mono(11, color: C.muted)),
        const SizedBox(height: 14),
        _SliderField(label: 'Coordination (discipline, shared line)', value: coordination, min: 5, max: 100, step: 5, unit: '%', onChanged: (x) => setState(() => coordination = x)),
        _resetButton(() => setState(() {
              scale = 6;
              organized = 3;
              coordination = 50;
            })),
        const SizedBox(height: 16),
        Text('CAPACITY AGAINST SCALE · POWERS OF TEN', style: mono(10, spacing: 0.6)),
        const SizedBox(height: 8),
        _SplitBar(
          [
            ('Organized', capLog.clamp(0.0, scale.toDouble()), C.forest, C.paper),
            ('Gap', gap, C.lineStrong, C.paper),
          ],
          semantics: 'Organized capacity ${capLog.toStringAsFixed(1)} of ${scale.toString()} orders of magnitude',
          height: 44,
        ),
        const SizedBox(height: 16),
        _FormulaLarge(
          'capacity = organized × coordination',
          '${_pow(organized)} × $coordination% ≈ 10^${capLog.toStringAsFixed(1)}',
          'against a problem of ${_pow(scale)} people',
        ),
        const SizedBox(height: 16),
        _Metrics([
          ('Survivor frame', 'reach 1'),
          ('Systems frame', 'observe'),
          ('Organized side', '10^${capLog.toStringAsFixed(1)}'),
          ('Gap', reached ? 'none' : '${gap.toStringAsFixed(1)} ×10'),
        ]),
        const SizedBox(height: 16),
        _Verdict(verdict, tone),
        const SizedBox(height: 16),
        const _Note('A deliberately crude picture of Dean’s first opening—the power of number—and of her claim that survivors and systems both erase the collective middle term. Real capacity is not headcount: it depends on strategy, institutions, and the strength of the other side.'),
      ],
    );
  }
}

double _log10(double x) => math.log(x) / math.ln10;
// ───────────────────────────── 03 · Five relations ─────────────────────────────

class _RelationsLab extends StatefulWidget {
  const _RelationsLab();

  @override
  State<_RelationsLab> createState() => _RelationsLabState();
}

class _RelationsLabState extends State<_RelationsLab> {
  int selected = 4;

  static const _criteria = [
    'Open to strangers',
    'Presupposes a political side',
    'Indifferent to identity',
    'Mediated by the state',
  ];

  // (name, mediated by, who chooses, [criteria], Dean’s point)
  static const _relations = [
    ('Kin', 'Blood, marriage, inheritance', 'Birth or marriage', [false, false, false, false],
        'One is born kin, not a comrade. Kin can oppose each other politically; families pass on property and position, while comradeship cuts against them. Families are stuck with each other.'),
    ('Neighbor', 'Proximity', 'Where you happen to live', [true, false, false, false],
        'Living near someone does not make them a comrade. Communists were suspected precisely because their ties could be stronger with distant comrades than with the people next door.'),
    ('Citizen', 'The state and its territory', 'Birth or naturalization', [true, false, true, true],
        'Citizenship looks similar—generic and equalizing—but it is mediated by the state. Comradeship exceeds the state; the discipline of the comrade can stand against the law of the state.'),
    ('Friend', 'Personal preference and virtue', 'Each individual, for a few', [false, false, false, false],
        'Friendship is chosen, singular and for the good of the friends; it is not necessarily political. Comrades may be friends, but personal dislike is not betrayal, and keeping the two apart takes work.'),
    ('Comrade', 'Fidelity to a political truth, organized in a party', 'The collective, through organization', [true, true, true, false],
        'Anyone but not everyone: open to strangers, indifferent to identity, and premised on a division into sides. Comrades need each other—their desire is not to let down and not to be let down.'),
  ];

  @override
  Widget build(BuildContext context) {
    final (name, mediator, chooser, marks, point) = _relations[selected];
    final score = marks.where((m) => m).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LabHead(
          'Lesson 13 · ch. 3 §§36–39',
          'Five ways to be bound together.',
          'Dean defines the comrade by what it is not. Pick a relation and compare what mediates it, who chooses it, and which of the comrade’s features it shares.',
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < _relations.length; i++)
              Semantics(
                button: true,
                selected: selected == i,
                child: Material(
                  color: selected == i ? C.ink : Colors.transparent,
                  shape: RoundedRectangleBorder(side: BorderSide(color: selected == i ? C.ink : C.lineSoft)),
                  child: InkWell(
                    onTap: () => setState(() => selected = i),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Text(_relations[i].$1, style: display(14, weight: 600, height: 1.2, color: selected == i ? C.paper : C.ink)),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(border: Border.all(color: C.lineSoft)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MEDIATED BY', style: mono(9.5, color: C.muted, spacing: 0.5)),
              const SizedBox(height: 4),
              Text(mediator, style: display(18, weight: 600, height: 1.2)),
              const SizedBox(height: 12),
              Text('CHOSEN BY', style: mono(9.5, color: C.muted, spacing: 0.5)),
              const SizedBox(height: 4),
              Text(chooser, style: display(18, weight: 600, height: 1.2)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(border: Border.all(color: C.lineSoft)),
          child: Column(
            children: [
              for (var c = 0; c < _criteria.length; c++)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: c > 0 ? const Border(top: BorderSide(color: C.lineSoft)) : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(_criteria[c], style: display(13.5, weight: 520, height: 1.3))),
                      for (var r = 0; r < _relations.length; r++)
                        SizedBox(
                          width: 26,
                          child: Semantics(
                            label: '${_relations[r].$1}: ${_relations[r].$4[c] ? 'yes' : 'no'}',
                            child: Icon(
                              _relations[r].$4[c] ? Icons.check : Icons.remove,
                              size: 16,
                              color: r == selected ? (_relations[r].$4[c] ? C.forest : C.error) : C.lineStrong,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: C.paperDeep,
                child: Row(
                  children: [
                    Expanded(child: Text('K · N · C · F · C', style: mono(9.5, color: C.muted, spacing: 0.6))),
                    for (var r = 0; r < _relations.length; r++)
                      SizedBox(
                        width: 26,
                        child: Text(_relations[r].$1[0], textAlign: TextAlign.center, style: mono(10, medium: r == selected, color: r == selected ? C.coral : C.muted)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _FormulaLarge(
          'anyone, but not everyone',
          '$name: ${marks[0] && marks[1] ? 'yes' : 'no'}',
          'needs both openness to strangers and a political side · $score of 4 features',
        ),
        const SizedBox(height: 16),
        _Verdict(point, name == 'Comrade' ? C.forest : C.coral),
        const SizedBox(height: 16),
        const _Note('A summary table, not a sociology. Dean’s point is that these relations differ in kind and can coexist—comrades may also be kin, neighbors, citizens or friends—and that confusing them “substantializes” comradeship and loses its generic cut.'),
      ],
    );
  }
}

// ───────────────────────────── 04 · Discipline ─────────────────────────────

class _DisciplineLab extends StatefulWidget {
  const _DisciplineLab();

  @override
  State<_DisciplineLab> createState() => _DisciplineLabState();
}

class _DisciplineLabState extends State<_DisciplineLab> {
  int discipline = 55, rectification = 50;

  /// Threshold beyond which discipline turns superegoic; a path back
  /// (self-criticism, readmission) pushes it higher.
  double get _threshold => 0.45 + 0.45 * rectification / 100;

  (double, double) _at(double x) {
    final s = ((x - _threshold) / 0.6).clamp(0.0, 1.0);
    return (x * (1 - s), s);
  }

  @override
  Widget build(BuildContext context) {
    final x = discipline / 100;
    final (capacity, superego) = _at(x);
    final courage = x * (1 - superego) * (1 - superego);
    final curve = [for (var i = 0; i <= 20; i++) _at(i / 20).$1];
    final String verdict;
    final Color tone;
    if (x < 0.25) {
      verdict = 'Too little discipline: politics stays individual. Nobody knows what to expect of anyone, and drift sets in—the heart slowly leaks out.';
      tone = C.coral;
    } else if (superego == 0) {
      verdict = 'Discipline is building capacity. Shared expectations turn scattered longing into collective will; joy, enthusiasm and courage rise with it.';
      tone = C.forest;
    } else if (superego < 0.5) {
      verdict = 'The superego is creeping in. The demand to do more becomes a demand for purity; expulsions start to replace self-criticism, and fear eats into courage.';
      tone = C.coral;
    } else {
      verdict = 'A ‘phony war’: discipline has turned on itself. Comrades fear each other, branches are liquidated, and the discipline that made the collective strong destroys what it built.';
      tone = C.error;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LabHead(
          'Lesson 16 · ch. 3 §§46–50, ch. 4',
          'Discipline and its excess.',
          'Dean calls discipline the law and language of collective desire—and admits it carries all the excesses of the superego. Turn up discipline, then change how much room there is for self-criticism and a path back.',
        ),
        _SliderField(label: 'Shared discipline (expectations, tasks, unity)', value: discipline, min: 0, max: 100, step: 5, unit: '%', onChanged: (v) => setState(() => discipline = v)),
        _SliderField(label: 'Self-criticism and a path back', value: rectification, min: 0, max: 100, step: 5, unit: '%', onChanged: (v) => setState(() => rectification = v)),
        _resetButton(() => setState(() {
              discipline = 55;
              rectification = 50;
            })),
        const SizedBox(height: 16),
        Text('COLLECTIVE CAPACITY ACROSS DISCIPLINE 0–100%', style: mono(10, spacing: 0.6)),
        const SizedBox(height: 8),
        _Bars(curve, C.forest, highlight: (x * 20).round(), semantics: 'Capacity curve; current capacity ${_pct(capacity)}'),
        const SizedBox(height: 14),
        _SplitBar(
          [
            ('Capacity', capacity, C.forest, C.paper),
            ('Superego', x - capacity, C.error, C.paper),
            ('', 1 - x, C.paperDeep, C.ink),
          ],
          semantics: 'Capacity ${_pct(capacity)}, lost to superego ${_pct(x - capacity)}',
          height: 40,
        ),
        const SizedBox(height: 16),
        _FormulaLarge(
          'capacity = d · (1 − superego)',
          '${_pct(x)} · (1 − ${_pct(superego)}) = ${_pct(capacity)}',
          'superego starts above ${_pct(_threshold)} discipline',
        ),
        const SizedBox(height: 16),
        _Metrics([
          ('Collective capacity', _pct(capacity)),
          ('Joy & enthusiasm', _pct(capacity)),
          ('Courage', _pct(courage)),
          ('Fear (superego)', _pct(superego)),
        ]),
        const SizedBox(height: 16),
        _Verdict(verdict, tone),
        const SizedBox(height: 16),
        const _Note('A caricature with made-up curves. It stages Dean’s double claim—discipline is what gives a collective a body, and the same discipline can turn superegoic—using the contrast she draws between the 1931 Yokinen trial (expelled, with a path back) and the 1950s ‘phony war’.'),
      ],
    );
  }
}
