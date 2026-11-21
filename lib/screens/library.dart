import 'package:material_ui/material_ui.dart';

import '../data.dart';
import '../store.dart';
import '../theme.dart';

/// The reading room: every section of the book as a numbered study section (§),
/// with an on-device "read" tracker. The book is in copyright, so no text is
/// bundled and passages have no URL; tapping a row marks it read.
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  static const _filters = ['All passages', 'Unread', 'Read'];

  final _search = TextEditingController();
  String _partId = course.sourceParts.first.id;
  String _query = '';
  String _filter = _filters.first;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clear() {
    _search.clear();
    setState(() {
      _query = '';
      _filter = _filters.first;
    });
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final part = course.sourceParts.firstWhere((p) => p.id == _partId);
          final q = _query.trim().toLowerCase();
          final passages = part.passages.where((p) {
            final read = store.isRead(p);
            final matchesFilter = _filter == 'All passages' || (_filter == 'Read' ? read : !read);
            return matchesFilter && ('${p.title} ${p.page}').toLowerCase().contains(q);
          }).toList();
          final totalRead = store.readCount(course.allPassages);
          final partRead = store.readCount(part.passages);

          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              PageIntro(
                eyebrow: 'Chapter reading room',
                plain: 'Four chapters.\n',
                emphasis: 'Section by section.',
                body: 'Comrade is in copyright, so this app contains none of its text. Read along in your own copy: the book is split into 64 numbered study sections that follow its chapters and sub-headings. Tap a section when you have read it.',
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: ProgressLine(totalRead / course.passageCount, height: 6)),
                        const SizedBox(width: 12),
                        Text('$totalRead/${course.passageCount}', style: display(16, weight: 600, height: 1)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('SECTIONS MARKED READ ON THIS DEVICE', style: mono(10, color: C.muted, spacing: 0.6)),
                    const SizedBox(height: 12),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(Icons.wifi, size: 16, color: C.muted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'The index and your progress are stored on your device. Companion texts open in your browser and need a connection.',
                          style: display(12.5, weight: 450, color: C.muted, height: 1.4),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: pagePadding,
                child: Row(
                  children: [
                    for (var i = 0; i < course.sourceParts.length; i++)
                      _partTab(course.sourceParts[i], i),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow('${part.notebooks} · ${part.pages}'),
                    Text(part.title, style: display(29, height: 1.08)),
                    const SizedBox(height: 8),
                    Text(part.subtitle, style: reading(16.5, color: C.muted, height: 1.5)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: ProgressLine(partRead / part.passages.length, height: 4, color: C.forest)),
                        const SizedBox(width: 12),
                        Text('$partRead / ${part.passages.length} read', style: mono(11, color: C.muted)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SecondaryButton(
                      'About the book',
                      icon: Icons.open_in_new,
                      onPressed: () => openUrl(context, part.contentsUrl),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: C.paperDeep,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('EDITION NOTE', style: mono(10, medium: true, spacing: 0.9)),
                          const SizedBox(height: 8),
                          Text(part.editorialNote, style: reading(15.5, height: 1.5)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SearchField(
                      controller: _search,
                      hint: 'Search ${part.passages.length} sections or a § number…',
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilterChips(
                items: _filters,
                selected: _filter,
                onSelected: (value) => setState(() => _filter = value),
              ),
              const SizedBox(height: 12),
              const Divider(color: C.ink),
              for (final passage in passages) _PassageRow(passage: passage),
              if (passages.isEmpty)
                EmptyState(
                  title: 'No passages match.',
                  body: 'Try a broader phrase, another section number, or a different filter.',
                  action: SecondaryButton('Clear search', onPressed: _clear),
                ),
              _downloads(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 44, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('Free texts beside the book'),
                    Text('Companion texts.', style: display(32, height: 1.05)),
                  ],
                ),
              ),
              const Divider(color: C.ink),
              for (final text in course.companionTexts)
                InkWell(
                  onTap: () => openUrl(context, text.url),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.lineSoft))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 52, child: Text(text.year, style: mono(12, medium: true, color: C.coral))),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(text.title, style: display(18, height: 1.2, spacing: -0.3)),
                              const SizedBox(height: 5),
                              Text(text.description, style: reading(15, color: C.muted, height: 1.45)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.open_in_new, size: 17, color: C.muted),
                      ],
                    ),
                  ),
                ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(border: Border.all(color: C.lineSoft)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Source & method', style: display(15, weight: 650, height: 1.3)),
                    const SizedBox(height: 6),
                    Text(
                      'Jodi Dean, Comrade: An Essay on Political Belonging (London and New York: Verso, 2019). The app bundles no text from the book. Section numbers (§) are this app’s own study divisions following the book’s chapters and sub-headings, since the e-book has no printed page numbers. Section labels are short study titles, not quotations. Lesson explanations are original study aids; check interpretive claims against the book and other scholarship.',
                      style: reading(15, color: C.muted, height: 1.5),
                    ),
                    const SizedBox(height: 4),
                    UnderlinedLink(
                      'Comrade at Verso Books',
                      icon: Icons.open_in_new,
                      onTap: () => openUrl(context, course.downloads['book']!),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );

  Widget _partTab(SourcePart p, int i) {
    final selected = p.id == _partId;
    final read = store.readCount(p.passages);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Semantics(
        button: true,
        selected: selected,
        child: Material(
          color: selected ? C.ink : Colors.transparent,
          shape: RoundedRectangleBorder(side: BorderSide(color: selected ? C.ink : C.lineSoft)),
          child: InkWell(
            onTap: () {
              _search.clear();
              setState(() {
                _partId = p.id;
                _query = '';
              });
            },
            child: Container(
              width: 132,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CHAPTER ${i + 1}', style: mono(9.5, spacing: 0.8, color: selected ? C.accentSoft : C.coral)),
                  const SizedBox(height: 6),
                  Text(p.short, style: reading(22, italic: true, height: 1.05, color: selected ? C.paper : C.ink)),
                  const SizedBox(height: 6),
                  Text('$read/${p.passages.length} read', style: mono(10, color: selected ? C.paperDeep : C.muted)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _downloads(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(20, 32, 20, 0),
        padding: const EdgeInsets.all(18),
        color: C.plum,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Read it whole', color: C.accentSoft, bottom: 8),
            Text('Get the book, start free.', style: display(23, color: C.paper, height: 1.12)),
            const SizedBox(height: 8),
            Text(
              'Comrade is published by Verso. Chapter three began as a free e-flux essay, and Mark Fisher’s essay quoted in chapter one is free online too.',
              style: reading(15.5, color: C.paperDeep, height: 1.5),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 18,
              children: [
                UnderlinedLink('The book', icon: Icons.north_east, color: C.paper, onTap: () => openUrl(context, course.downloads['book']!)),
                UnderlinedLink('Four Theses', icon: Icons.north_east, color: C.paper, onTap: () => openUrl(context, course.downloads['essay']!)),
                UnderlinedLink('Fisher', icon: Icons.north_east, color: C.paper, onTap: () => openUrl(context, course.downloads['fisher']!)),
              ],
            ),
          ],
        ),
      );
}

class _PassageRow extends StatelessWidget {
  const _PassageRow({required this.passage});
  final Passage passage;

  @override
  Widget build(BuildContext context) {
    final read = store.isRead(passage);
    return Container(
      decoration: BoxDecoration(
        color: read ? C.raised : null,
        border: const Border(bottom: BorderSide(color: C.lineSoft)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => passage.url.isEmpty ? store.setRead(passage, !read) : openUrl(context, passage.url),
              child: Container(
                constraints: const BoxConstraints(minHeight: 56),
                padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text('§${passage.page}', style: mono(12, color: C.coral, medium: true)),
                    ),
                    Expanded(
                      child: Text(
                        passage.title,
                        style: display(15.5, weight: 520, height: 1.28, color: read ? C.muted : C.ink),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (passage.url.isNotEmpty) const Icon(Icons.open_in_new, size: 16, color: C.muted),
                  ],
                ),
              ),
            ),
          ),
          Semantics(
            label: read ? 'Mark section ${passage.page} unread' : 'Mark section ${passage.page} read',
            button: true,
            child: InkWell(
              onTap: () => store.setRead(passage, !read),
              child: Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                child: ExcludeSemantics(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: read ? C.forest : Colors.transparent,
                      border: Border.all(color: read ? C.forest : C.lineStrong, width: 1.5),
                    ),
                    child: read ? const Icon(Icons.check, size: 16, color: C.paper) : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
