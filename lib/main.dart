import 'package:flutter/material.dart';

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

// ---------------- LOGIN ----------------

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
              const SizedBox(height: 12),
              const Text(
                'Commercial Library Management Platform',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- HOME ----------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LIBRAK'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
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

// ---------------- BOOK MODEL ----------------

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
  });
}

// ---------------- CATALOG ----------------

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
      return book.title.toLowerCase().contains(search.toLowerCase()) ||
          book.author.toLowerCase().contains(search.toLowerCase()) ||
          book.isbn.toLowerCase().contains(search.toLowerCase());
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
                hintText: 'Search books, author or ISBN',
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 70,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No books added yet',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 6),
                        Text('Tap + to add a book'),
                      ],
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
                          leading: const CircleAvatar(
                            child: Icon(Icons.menu_book),
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

// ---------------- ADD BOOK ----------------

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

  String availability = 'Available';

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
    super.dispose();
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
          _field(title, 'Title', Icons.title),
          _field(author, 'Author', Icons.person_outline),
          _field(isbn, 'ISBN', Icons.qr_code),
          _field(publisher, 'Publisher', Icons.business),
          _field(genre, 'Genre', Icons.category_outlined),
          _field(language, 'Language', Icons.language),
          _field(
            publicationDate,
            'Publication Date',
            Icons.calendar_today,
          ),
          _field(edition, 'Edition', Icons.layers_outlined),
          _field(pages, 'Pages', Icons.auto_stories),
          _field(rack, 'Rack', Icons.shelves),
          _field(shelf, 'Shelf', Icons.view_list),
          
          DropdownButtonFormField<String>(
            initialValue: availability,
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
            controller: description,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 52,
            child: FilledButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save Book'),
              onPressed: () {
                if (title.text.trim().isEmpty ||
                    author.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter Title and Author',
                      ),
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

// ---------------- BOOK DETAILS ----------------

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
          const Icon(
            Icons.menu_book_rounded,
            size: 90,
          ),
          const SizedBox(height: 16),

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
            book.author,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17),
          ),

          const SizedBox(height: 24),

          _info('ISBN', book.isbn),
          _info('Publisher', book.publisher),
          _info('Genre', book.genre),
          _info('Language', book.language),
          _info('Publication Date', book.publicationDate),
          _info('Edition', book.edition),
          _info('Pages', book.pages),
          _info('Rack', book.rack),
          _info('Shelf', book.shelf),
          _info('Availability', book.availability),

          const SizedBox(height: 16),

          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            book.description.isEmpty
                ? 'No description available.'
                : book.description,
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
