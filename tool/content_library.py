"""Reading-room index for Jodi Dean, Comrade: An Essay on Political Belonging
(Verso, 2019).

The book is in copyright, so the app bundles none of its text. The e-book has
no printed page numbers, so the index is keyed to numbered study sections (§)
that follow the book's own order: four chapters and their sub-headings.
The `page` field holds the section number. Passages have no URL (url == "");
tapping one marks it read. Titles are short study labels, not quotations."""

B = "https://www.versobooks.com/products/881-comrade"
EFLUX = "https://www.e-flux.com/journal/86/160585/four-theses-on-the-comrade/"
MIA = "https://www.marxists.org/archive/"


def P(section, title):
    return {"page": section, "title": title, "url": ""}


ch1 = [
    P(1, "A joke about comrades: Obama and Sanders"),
    P(2, "From room to relation: camera, vault, supported cover"),
    P(3, "Those you can count on: Davis and Gornick"),
    P(4, "Ego ideal and ideal ego"),
    P(5, "The communist horizon, negative and positive"),
    P(6, "Against the left’s rejection of the party"),
    P(7, "Comradeship remakes work and common time"),
    P(8, "How we imagine political work; after Occupy"),
    P(9, "Wilderson, Hani, Mandela: the joy and discipline of address"),
    P(10, "Survivors and Systems: two tendencies"),
    P(11, "Neoliberalism’s displacement of politics"),
    P(12, "Four openings for politics"),
    P(13, "Why ‘comrade’ sounds jarring; attachment to identity"),
    P(14, "The ally and the how-to guides"),
    P(15, "Educate yourself: punishment without discipline"),
    P(16, "Alliances, allies and comrades"),
]

ch2 = [
    P(17, "Method: scavenging the ruins"),
    P(18, "Comrade Woman: Kollontai, Lenin and Zetkin"),
    P(19, "Women in the CPUSA; the Mary Inman controversy"),
    P(20, "The fear of losing specificity; comrade as container"),
    P(21, "Sex, Lenin’s aside, and the non-all"),
    P(22, "The Black Comrade: two suspicions"),
    P(23, "Lucy Parsons and Cyril Briggs"),
    P(24, "Practicing social equality: Wilderson, McKinney, Claudia Jones"),
    P(25, "Briggs’s acid test and the 1932 instruction"),
    P(26, "The Black Belt Thesis: nation or race?"),
    P(27, "The black comrade as ego ideal"),
    P(28, "The Negativity of Comrade: Platonov’s Chevengur"),
    P(29, "Genosse and tovarish: property and enjoyment"),
    P(30, "The comrade as zero-level of communism"),
]

ch3 = [
    P(31, "Why there is no theory of the comrade"),
    P(32, "Thesis One: Kollontai and Gorky"),
    P(33, "The Comrade magazine, Whitman, tongzhi, Fanon, Orwell"),
    P(34, "Thesis Two: Ninotchka at the station"),
    P(35, "Comrades in arms, friend and enemy"),
    P(36, "Generic, not unique: comrades are not kin"),
    P(37, "Not neighbor, not citizen"),
    P(38, "Not friend: Lomnitz, Aristotle, Wilderson and Trevor"),
    P(39, "The inhuman comrade: ‘all Communists are the same’"),
    P(40, "Thesis Three: identity vanishes; masks"),
    P(41, "The Measures Taken; comrade and militant"),
    P(42, "The war over tovar; intimacies of common work"),
    P(43, "Thesis Four: Marx, the International, Kameradschaft"),
    P(44, "Badiou: event, truth and fidelity"),
    P(45, "The party as body of truth"),
    P(46, "Discipline"),
    P(47, "Joy, enthusiasm and courage"),
    P(48, "A politics with a body: against Žižek’s tetrad"),
    P(49, "Superego, Kronstadt, and excess"),
    P(50, "The four theses summed up"),
]

ch4 = [
    P(51, "‘I have a comrade’: discipline as relief"),
    P(52, "The ‘buts’: learning from endings"),
    P(53, "Expulsion: the Bolshevik expulsions"),
    P(54, "The Yokinen trial, Harlem 1931"),
    P(55, "Expelled but still a comrade"),
    P(56, "The ‘phony war’ against white chauvinism"),
    P(57, "The social death of the expelled"),
    P(58, "Resignation: C. L. R. James and Correspondence"),
    P(59, "Resigning as comrades: Scales, Fast, Queen Mother Moore"),
    P(60, "Drift: the heart leaking out"),
    P(61, "Commanded comradeship; many endings"),
    P(62, "The End of the World: The Golden Notebook"),
    P(63, "Words lose their meaning: the I, I, I"),
    P(64, "Comrades after communism?"),
]

source_parts = [
    {
        "id": "allies",
        "short": "Allies",
        "title": "Chapter One · From Allies to Comrades",
        "subtitle": "The comrade as a relation of people on the same side; survivors and systems; why allyship is a symptom rather than a model.",
        "notebooks": "Opening · Survivors and Systems · From Allies to Comrades",
        "editorialNote": "The framing chapter. It sets out the three registers Dean uses throughout—comrade as a term of address, a figure of political belonging and a carrier of expectations—and places the book against two tendencies of the contemporary left: attachment to identity and fascination with vast systems.",
        "pages": "§§1–16",
        "contentsUrl": B,
        "passages": ch1,
    },
    {
        "id": "generic",
        "short": "Generic",
        "title": "Chapter Two · The Generic Comrade",
        "subtitle": "Is the comrade male, or white? Women and black communists in the CPUSA, the Black Belt thesis, and Platonov’s comrades of the destitute.",
        "notebooks": "Comrade Woman · The Black Comrade · The Black Belt Thesis · The Negativity of Comrade",
        "editorialNote": "Dean answers two objections with history rather than definitions, drawing mostly on the US Communist Party of the 1920s–40s. She calls her method ‘speculative-compositive’: examples are lifted from their contexts and salvaged for present use, not offered as a full history.",
        "pages": "§§17–30",
        "contentsUrl": B,
        "passages": ch2,
    },
    {
        "id": "theses",
        "short": "Theses",
        "title": "Chapter Three · Four Theses on the Comrade",
        "subtitle": "Sameness and utopia; anyone but not everyone; the individual as the comrade’s Other; fidelity to a truth—and the four attributes of discipline, joy, enthusiasm, courage.",
        "notebooks": "Theses One–Four · Generic, Not Unique",
        "editorialNote": "The theoretical core. An earlier version appeared as ‘Four Theses on the Comrade’ in e-flux journal 86 (November 2017), which is free to read online and makes a good companion to this chapter.",
        "pages": "§§31–50",
        "contentsUrl": EFLUX,
        "passages": ch3,
    },
    {
        "id": "ending",
        "short": "Endings",
        "title": "Chapter Four · You Are Not My Comrade",
        "subtitle": "Four ways comradeship ends: expulsion, resignation, drift, and the end of the world.",
        "notebooks": "Expulsion · Resignation · Drift · The End of the World",
        "editorialNote": "Dean refuses to let fear of failure stop a beginning, and studies endings to learn from them: the 1931 Yokinen trial, the CPUSA’s ‘phony war’ against chauvinism, C. L. R. James’s resignation, quiet drift, and Doris Lessing’s The Golden Notebook.",
        "pages": "§§51–64",
        "contentsUrl": B,
        "passages": ch4,
    },
]

companion_texts = [
    {
        "title": "Four Theses on the Comrade (e-flux journal 86)",
        "year": "2017",
        "description": "Dean’s free online essay that became chapter three: the four theses and the four attributes in compact form.",
        "url": EFLUX,
    },
    {
        "title": "Mark Fisher · Exiting the Vampire Castle",
        "year": "2013",
        "description": "The essay Dean quotes at the end of chapter one: a polemic against left call-out culture and a plea to relearn comradeship and solidarity.",
        "url": "https://www.opendemocracy.net/en/opendemocracyuk/exiting-vampire-castle/",
    },
    {
        "title": "Alexandra Kollontai · Communism and the Family",
        "year": "1920",
        "description": "Kollontai’s vision of a ‘great universal family of workers’ who are above all comrades—the source of Dean’s first thesis.",
        "url": MIA + "kollonta/1920/communism-family.htm",
    },
    {
        "title": "Clara Zetkin · Lenin on the Women’s Question",
        "year": "1920",
        "description": "Zetkin’s record of her conversations with Lenin, used in chapter two on women comrades, commissions, and Lenin’s aside on love and discipline.",
        "url": MIA + "zetkin/1920/lenin/zetkin1.htm",
    },
    {
        "title": "Lenin · A Great Beginning",
        "year": "1919",
        "description": "Lenin on the communist subbotniks—voluntary Saturday labour—and on discipline as a victory over one’s own habits, quoted in chapter three.",
        "url": MIA + "lenin/works/1919/jun/19.htm",
    },
    {
        "title": "Harry Haywood · The Struggle for the Leninist Position on the Negro Question",
        "year": "1933",
        "description": "Haywood’s own case for the Black Belt self-determination line that Dean discusses in chapter two.",
        "url": MIA + "haywood/1933/09/x01.htm",
    },
    {
        "title": "Marx · Letter to Kugelmann on the Commune",
        "year": "1871",
        "description": "Marx praises ‘our heroic Party comrades in Paris’—party in the broad historical sense, as Dean notes in thesis four.",
        "url": MIA + "marx/works/1871/letters/71_04_12.htm",
    },
]

downloads = {
    "book": B,
    "essay": EFLUX,
    "fisher": "https://www.opendemocracy.net/en/opendemocracyuk/exiting-vampire-castle/",
}
