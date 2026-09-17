import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const LibrakApp());
}

class LibrakApp extends StatelessWidget {
  const LibrakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LIBRAK',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const LoginPage(),
    );
  }
}

// ================= LOGIN =================

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_library_rounded,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'LIBRAK',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Smart Books. Smart Shelves. Smart Library.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Library ID / Email',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= HOME =================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LIBRAK'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Library',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Manage books, shelves and circulation.',
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.menu_book,
                    title: 'Books',
                    value: '0',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.people_outline,
                    title: 'Members',
                    value: '0',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.swap_horiz,
                    title: 'Issued',
                    value: '0',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.warning_amber,
                    title: 'Alerts',
                    value: '0',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                icon: const Icon(Icons.library_books),
                label: const Text('Open Book Catalog'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CatalogPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// ================= BOOK MODEL =================

class Book {
  String title;
  String author;
  String isbn;
  String publisher;
  String genre;
  String language;
  String publicationDate;
  String edition;
  String pages;
  String rack;
  String shelf;
  String availability;
  String description;
  String keywords;
  String coverUrl;

  Book({
    required this.title,
    required this.author,
    required this.isbn,
    required this.publisher,
    required this.genre,
    required this.language,
    required this.publicationDate,
    required this.edition,
    required this.pages,
    required this.rack,
    required this.shelf,
    required this.availability,
    required this.description,
    required this.keywords,
    required this.coverUrl,
  });
}

// ================= CATALOG =================

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final List<Book> books = [];
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books.where((book) {
      final q = search.toLowerCase();

      return book.title.toLowerCase().contains(q) ||
          book.author.toLowerCase().contains(q) ||
          book.isbn.toLowerCase().contains(q) ||
          book.keywords.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Catalog'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search books, author, ISBN or keywords',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredBooks.isEmpty
                ? const Center(
                    child: Text(
                      'No books added yet',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: book.coverUrl.isEmpty
                              ? const CircleAvatar(
                                  child: Icon(Icons.menu_book),
                                )
                              : Image.network(
                                  book.coverUrl,
                                  width: 45,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return const Icon(
                                      Icons.menu_book,
                                      size: 40,
                                    );
                                  },
                                ),
                          title: Text(book.title),
                          subtitle: Text(
                            '${book.author}\nRack ${book.rack} • Shelf ${book.shelf}',
                          ),
                          isThreeLine: true,
                          trailing: const Icon(
                            Icons.chevron_right,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookDetailsPage(
                                  book: book,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final book = await Navigator.push<Book>(
            context,
            MaterialPageRoute(
              builder: (_) => const AddBookPage(),
            ),
          );

          if (book != null) {
            setState(() {
              books.add(book);
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
      ),
    );
  }
}

// ================= ADD BOOK =================

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final title = TextEditingController();
  final author = TextEditingController();
  final isbn = TextEditingController();
  final publisher = TextEditingController();
  final genre = TextEditingController();
  final language = TextEditingController();
  final publicationDate = TextEditingController();
  final edition = TextEditingController();
  final pages = TextEditingController();
  final rack = TextEditingController();
  final shelf = TextEditingController();
  final description = TextEditingController();
  final keywords = TextEditingController();
  final coverUrl = TextEditingController();

  String availability = 'Available';
  bool loading = false;

  @override
  void dispose() {
    title.dispose();
    author.dispose();
    isbn.dispose();
    publisher.dispose();
    genre.dispose();
    language.dispose();
    publicationDate.dispose();
    edition.dispose();
    pages.dispose();
    rack.dispose();
    shelf.dispose();
    description.dispose();
    keywords.dispose();
    coverUrl.dispose();
    super.dispose();
  }

  // -------- ISBN AUTO FILL --------
  
Future<void> autoFillISBN() async {
  final code = isbn.text
      .trim()
      .replaceAll(RegExp(r'[^0-9Xx]'), '');

  if (code.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter ISBN first.'),
      ),
    );
    return;
  }

  if (code.length != 10 && code.length != 13) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a valid ISBN-10 or ISBN-13.'),
      ),
    );
    return;
  }

  setState(() {
    loading = true;
  });

  try {
    Map<String, dynamic> google = {};
    Map<String, dynamic> open = {};

    // =========================================================
    // GOOGLE BOOKS
    // =========================================================

    try {
      final url = Uri.https(
        'www.googleapis.com',
        '/books/v1/volumes',
        {
          'q': 'isbn:$code',
          'maxResults': '5',
        },
      );

      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['items'] is List &&
            (data['items'] as List).isNotEmpty) {
          final item = data['items'][0];

          if (item['volumeInfo'] is Map) {
            google = Map<String, dynamic>.from(
              item['volumeInfo'],
            );
          }
        }
      }
    } catch (_) {}

    // =========================================================
    // OPEN LIBRARY SEARCH
    // =========================================================

    try {
      final url = Uri.https(
        'openlibrary.org',
        '/search.json',
        {
          'isbn': code,
          'limit': '5',
        },
      );

      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['docs'] is List &&
            (data['docs'] as List).isNotEmpty) {
          final doc = data['docs'][0];

          if (doc is Map) {
            open = Map<String, dynamic>.from(doc);
          }
        }
      }
    } catch (_) {}

    // =========================================================
    // OPEN LIBRARY ISBN EDITION FALLBACK
    // =========================================================

    Map<String, dynamic> edition = {};

    try {
      final url = Uri.https(
        'openlibrary.org',
        '/isbn/$code.json',
      );

      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map) {
          edition = Map<String, dynamic>.from(data);
        }
      }
    } catch (_) {}

    // =========================================================
    // HELPER FUNCTIONS
    // =========================================================

    String cleanText(dynamic value) {
      if (value == null) return '';

      if (value is Map) {
        if (value['value'] != null) {
          return value['value'].toString().trim();
        }

        if (value['name'] != null) {
          return value['name'].toString().trim();
        }
      }

      return value.toString().trim();
    }

    String firstNonEmpty(List<dynamic> values) {
      for (final value in values) {
        final text = cleanText(value);

        if (text.isNotEmpty &&
            text.toLowerCase() != 'null') {
          return text;
        }
      }

      return '';
    }

    String listText(dynamic value, {int limit = 10}) {
      if (value is! List) return '';

      final result = <String>[];

      for (final item in value) {
        final text = cleanText(item);

        if (text.isNotEmpty &&
            !result.contains(text)) {
          result.add(text);
        }

        if (result.length >= limit) break;
      }

      return result.join(', ');
    }

     // =========================================================
    // TITLE
    // =========================================================

    final bookTitle = firstNonEmpty([
      google['title'],
      open['title'],
      edition['title'],
    ]);

    if (bookTitle.isEmpty) {
      throw Exception('Book not found');
    }

    // =========================================================
    // AUTHOR
    // =========================================================

    String authorText = '';

    if (google['authors'] is List) {
      authorText = listText(
        google['authors'],
        limit: 5,
      );
    }

    if (authorText.isEmpty &&
        open['author_name'] is List) {
      authorText = listText(
        open['author_name'],
        limit: 5,
      );
    }

    // =========================================================
    // PUBLISHER
    // =========================================================

    String publisherText = firstNonEmpty([
      google['publisher'],
    ]);

    if (publisherText.isEmpty &&
        open['publisher'] is List) {
      publisherText = listText(
        open['publisher'],
        limit: 3,
      );
    }

    if (publisherText.isEmpty &&
        edition['publishers'] is List) {
      publisherText = listText(
        edition['publishers'],
        limit: 3,
      );
    }

    // =========================================================
    // GENRE / CATEGORIES
    // =========================================================

    String genreText = '';

    if (google['categories'] is List) {
      genreText = listText(
        google['categories'],
        limit: 10,
      );
    }

    if (genreText.isEmpty &&
        open['subject'] is List) {
      genreText = listText(
        open['subject'],
        limit: 10,
      );
    }

    if (genreText.isEmpty &&
        edition['subjects'] is List) {
      genreText = listText(
        edition['subjects'],
        limit: 10,
      );
    }

    // =========================================================
    // LANGUAGE
    // =========================================================

    String languageText = '';

    if (google['language'] != null) {
      languageText = cleanText(
        google['language'],
      );
    }

    if (languageText.isEmpty &&
        open['language'] is List) {
      languageText = listText(
        open['language'],
        limit: 1,
      );
    }

    // =========================================================
    // PUBLICATION DATE
    // =========================================================

    final publicationText = firstNonEmpty([
      google['publishedDate'],
      open['publish_date'],
      open['first_publish_year'],
      edition['publish_date'],
    ]);

    // =========================================================
    // PAGES
    // =========================================================

    final pagesText = firstNonEmpty([
      google['pageCount'],
      open['number_of_pages_median'],
      edition['number_of_pages'],
    ]);

    // =========================================================
    // DESCRIPTION
    // =========================================================

    String descriptionText = '';

    final googleDescription =
        google['description'];

    if (googleDescription is String) {
      descriptionText =
          googleDescription.trim();
    } else if (googleDescription is Map) {
      descriptionText =
          cleanText(googleDescription);
    }

    // =========================================================
    // KEYWORDS
    // =========================================================

    String keywordsText = '';

    if (google['categories'] is List) {
      keywordsText = listText(
        google['categories'],
        limit: 10,
      );
    }

    if (keywordsText.isEmpty &&
        open['subject'] is List) {
      keywordsText = listText(
        open['subject'],
        limit: 10,
      );
    }

    // =========================================================
    // COVER IMAGE
    // =========================================================

    String coverText = '';

    if (google['imageLinks'] is Map) {
      final images = google['imageLinks'];

      coverText = firstNonEmpty([
        images['thumbnail'],
        images['smallThumbnail'],
        images['small'],
        images['medium'],
        images['large'],
      ]);
    }

    if (coverText.isEmpty &&
        open['cover_i'] != null) {
      coverText =
          'https://covers.openlibrary.org/b/id/'
          '${open['cover_i']}-L.jpg';
    }

    if (coverText.isEmpty &&
        edition['covers'] is List &&
        (edition['covers'] as List).isNotEmpty) {
      final coverId =
          (edition['covers'] as List).first;

      coverText =
          'https://covers.openlibrary.org/b/id/'
          '$coverId-L.jpg';
    }

        // =========================================================
    // FILL ALL FIELDS
    // =========================================================

    setState(() {
      isbn.text = code;

      title.text = bookTitle;

      author.text = authorText;

      publisher.text = publisherText;

      genre.text = genreText;

      language.text = languageText;

      publicationDate.text = publicationText;

      pages.text = pagesText;

      keywords.text = keywordsText;

      description.text = descriptionText;

      coverUrl.text = coverText;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Book details filled automatically!',
        ),
      ),
    );
  } catch (_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Book details not found for ISBN $code',
        ),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Book'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(
            isbn,
            'ISBN',
            Icons.qr_code,
          ),
const SizedBox(height: 8),

SizedBox(
  height: 48,
  child: OutlinedButton.icon(
    onPressed: () async {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => const ISBNScannerPage(),
        ),
      );

      if (result != null && result.isNotEmpty) {
        setState(() {
          isbn.text = result;
        });

        await autoFillISBN();
      }
    },
    icon: const Icon(Icons.camera_alt),
    label: const Text('Scan ISBN with Camera'),
  ),
),
          const SizedBox(height: 4),

          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: loading ? null : autoFillISBN,
              icon: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                loading
                    ? 'Searching Book...'
                    : 'Auto Fill by ISBN',
              ),
            ),
          ),

          const SizedBox(height: 18),

          _field(title, 'Title', Icons.title),
          _field(author, 'Author', Icons.person_outline),
          _field(publisher, 'Publisher', Icons.business),
          _field(genre, 'Genre', Icons.category_outlined),
          _field(
            language,
            'Language',
            Icons.language,
          ),
          _field(
            publicationDate,
            'Publication Date',
            Icons.calendar_today,
          ),
          _field(
            edition,
            'Edition',
            Icons.layers_outlined,
          ),
          _field(
            pages,
            'Pages',
            Icons.auto_stories,
          ),

          _field(
            keywords,
            'Keywords',
            Icons.key,
          ),

          _field(
            rack,
            'Rack',
            Icons.shelves,
          ),

          _field(
            shelf,
            'Shelf',
            Icons.view_list,
          ),

          const SizedBox(height: 4),

          DropdownButtonFormField<String>(
            value: availability,
            decoration: const InputDecoration(
              labelText: 'Availability',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Available',
                child: Text('Available'),
              ),
              DropdownMenuItem(
                value: 'Issued',
                child: Text('Issued'),
              ),
              DropdownMenuItem(
                value: 'Reserved',
                child: Text('Reserved'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  availability = value;
                });
              }
            },
          ),

          const SizedBox(height: 16),

          TextField(
            controller: coverUrl,
            decoration: const InputDecoration(
              labelText: 'Cover Image URL',
              prefixIcon: Icon(Icons.image),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: description,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 54,
            child: FilledButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save Book'),
              onPressed: () {
                if (title.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter Title'),
                    ),
                  );
                  return;
                }

                Navigator.pop(
                  context,
                  Book(
                    title: title.text.trim(),
                    author: author.text.trim(),
                    isbn: isbn.text.trim(),
                    publisher: publisher.text.trim(),
                    genre: genre.text.trim(),
                    language: language.text.trim(),
                    publicationDate:
                        publicationDate.text.trim(),
                    edition: edition.text.trim(),
                    pages: pages.text.trim(),
                    rack: rack.text.trim(),
                    shelf: shelf.text.trim(),
                    availability: availability,
                    description: description.text.trim(),
                    keywords: keywords.text.trim(),
                    coverUrl: coverUrl.text.trim(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

// ================= BOOK DETAILS =================

class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (book.coverUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                book.coverUrl,
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.menu_book_rounded,
                    size: 100,
                  );
                },
              ),
            )
          else
            const Icon(
              Icons.menu_book_rounded,
              size: 100,
            ),

          const SizedBox(height: 20),

          Text(
            book.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            book.author.isEmpty
                ? 'Author not provided'
                : book.author,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17),
          ),

          const SizedBox(height: 24),

          _info('ISBN', book.isbn),
          _info('Publisher', book.publisher),
          _info('Genre', book.genre),
          _info('Language', book.language),
          _info(
            'Publication Date',
            book.publicationDate,
          ),
          _info('Edition', book.edition),
          _info('Pages', book.pages),
          _info('Keywords', book.keywords),
          _info('Rack', book.rack),
          _info('Shelf', book.shelf),
          _info(
            'Availability',
            book.availability,
          ),

          const SizedBox(height: 18),

          const Text(
            'Description',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            book.description.isEmpty
                ? 'No description available.'
                : book.description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text(
          value.isEmpty ? 'Not provided' : value,
        ),
      ),
    );
  }
}

// ================= ISBN CAMERA SCANNER =================

class ISBNScannerPage extends StatefulWidget {
  const ISBNScannerPage({super.key});

  @override
  State<ISBNScannerPage> createState() => _ISBNScannerPageState();
}

class _ISBNScannerPageState extends State<ISBNScannerPage> {
  final MobileScannerController controller =
      MobileScannerController();

  bool alreadyScanned = false;

  String cleanISBN(String value) {
    return value.replaceAll(RegExp(r'[^0-9Xx]'), '');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan ISBN'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () {
              controller.toggleTorch();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (alreadyScanned) return;

              for (final barcode in capture.barcodes) {
                final value = barcode.rawValue;

                if (value == null) continue;

                final isbn = cleanISBN(value);

                final validISBN13 =
                    isbn.length == 13 &&
                    (isbn.startsWith('978') ||
                        isbn.startsWith('979'));

                final validISBN10 = isbn.length == 10;

                if (validISBN13 || validISBN10) {
                  alreadyScanned = true;
                  controller.stop();

                  Navigator.pop(context, isbn);
                  return;
                }
              }
            },
          ),

          Center(
            child: Container(
              width: 320,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: Center(
              child: Text(
                'Place ISBN barcode inside the box',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
