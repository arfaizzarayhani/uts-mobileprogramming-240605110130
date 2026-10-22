import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/destination.dart';
import 'services/weather_service.dart';
import 'widgets/weather_card.dart';

void main() {
  runApp(const SelaApp());
}

const _forest = Color(0xFF24483C);
const _moss = Color(0xFF71816B);
const _paper = Color(0xFFF5F1E8);
const _surface = Color(0xFFFFFDF8);
const _clay = Color(0xFFC86F52);
const _sand = Color(0xFFE9DFC9);

const _destinations = <Destination>[
  Destination(
    id: 'penglipuran',
    name: 'Desa Penglipuran',
    region: 'Bangli, Bali',
    category: 'Budaya',
    duration: '1 hari',
    description: 'Jalan kaki di antara rumah-rumah tradisional yang tertata rapi, lalu duduk sejenak di bawah naungan bambu. Suasana desa terasa paling hidup saat pagi belum terlalu ramai.',
    bestTime: 'Pagi hari, sekitar pukul 08.00',
    travelNote: 'Gunakan alas kaki yang nyaman dan jaga suasana tenang saat melewati area rumah warga.',
    imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=1200&q=85',
    color: Color(0xFF54715B),
    latitude: -8.4333,
    longitude: 115.3500,
  ),
  Destination(
    id: 'kawah-ijen',
    name: 'Kawah Ijen',
    region: 'Banyuwangi, Jawa Timur',
    category: 'Alam',
    duration: '1 hari',
    description: 'Pendakian sebelum subuh membawa perjalanan menuju kawah berwarna toska dan bentang pegunungan yang luas. Cek informasi kawasan dan kondisi jalur sebelum berangkat.',
    bestTime: 'Musim kemarau, dengan berangkat dini hari',
    travelNote: 'Siapkan jaket hangat, masker, air minum, dan patuhi arahan petugas kawasan.',
    imageUrl: 'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?auto=format&fit=crop&w=1200&q=85',
    color: Color(0xFF627F78),
    latitude: -8.0580,
    longitude: 114.2420,
  ),
  Destination(
    id: 'karimunjawa',
    name: 'Kepulauan Karimunjawa',
    region: 'Jepara, Jawa Tengah',
    category: 'Bahari',
    duration: '3 hari',
    description: 'Pulau-pulau kecil, air laut jernih, dan sore yang panjang menjadi alasan untuk memperlambat ritme. Sisakan waktu untuk menikmati suasana kampung, tidak hanya berpindah pantai.',
    bestTime: 'April–Oktober, setelah mengecek jadwal kapal',
    travelNote: 'Jadwal kapal dapat berubah mengikuti cuaca. Pesan transportasi dan penginapan lebih awal.',
    imageUrl: 'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=85',
    color: Color(0xFF628A8A),
    latitude: -5.8700,
    longitude: 110.4460,
  ),
  Destination(
    id: 'kota-lama',
    name: 'Kota Lama Semarang',
    region: 'Semarang, Jawa Tengah',
    category: 'Kota',
    duration: '1 hari',
    description: 'Berjalan kaki menyusuri bangunan bersejarah, mampir ke kedai kecil, lalu melihat kawasan berubah warna menjelang senja. Cara sederhana mengenal Semarang dari dekat.',
    bestTime: 'Sore menjelang senja',
    travelNote: 'Datang dengan transportasi umum atau parkir di area yang telah disediakan.',
    imageUrl: 'https://images.unsplash.com/photo-1518005020951-eccb494ad742?auto=format&fit=crop&w=1200&q=85',
    color: Color(0xFF8B7561),
    latitude: -6.9680,
    longitude: 110.4270,
  ),
  Destination(
    id: 'wae-rebo',
    name: 'Kampung Wae Rebo',
    region: 'Manggarai, Nusa Tenggara Timur',
    category: 'Budaya',
    duration: '2 hari',
    description: 'Perjalanan kaki melewati perbukitan berujung pada kampung adat di tengah pegunungan. Pengalaman menginap di sini mengajak kita menghargai adat dan kehidupan setempat.',
    bestTime: 'April–November',
    travelNote: 'Perjalanan membutuhkan persiapan fisik. Hubungi pengelola setempat dan ikuti tata krama kampung.',
    imageUrl: 'https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?auto=format&fit=crop&w=1200&q=85',
    color: Color(0xFF777B59),
    latitude: -8.7770,
    longitude: 120.2960,
  ),
  Destination(
    id: 'borobudur',
    name: 'Candi Borobudur',
    region: 'Magelang, Jawa Tengah',
    category: 'Sejarah',
    duration: '1 hari',
    description: 'Luangkan waktu untuk mengamati relief dan lanskap di sekitar candi, bukan sekadar mengejar foto. Pengalaman kunjungan terbaik dimulai dengan menghormati aturan kawasan.',
    bestTime: 'Pagi hari',
    travelNote: 'Periksa ketentuan tiket dan akses naik ke struktur candi sebelum kunjungan.',
    imageUrl: 'https://images.unsplash.com/photo-1584810359583-96fc3448beaa?auto=format&fit=crop&w=1200&q=85',
    color: Color(0xFF927B56),
    latitude: -7.6079,
    longitude: 110.2038,
  ),
];

const _categories = ['Semua', 'Alam', 'Budaya', 'Bahari', 'Kota', 'Sejarah'];

class SelaApp extends StatelessWidget {
  const SelaApp({super.key, this.weatherService});

  final WeatherService? weatherService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sela — Cerita Perjalanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _forest,
          primary: _forest,
          surface: _paper,
        ),
        fontFamily: 'Roboto',
      ),
      home: MainNavigation(
        weatherService: weatherService ?? const OpenMeteoWeatherService(),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({required this.weatherService, super.key});

  final WeatherService weatherService;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  final Set<String> _savedIds = {};

  List<Destination> get _searchResults {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _destinations;
    return _destinations
        .where(
          (place) =>
              place.name.toLowerCase().contains(query) ||
              place.region.toLowerCase().contains(query) ||
              place.category.toLowerCase().contains(query),
        )
        .toList();
  }

  void _openDestination(Destination destination) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DestinationDetailPage(
          destination: destination,
          weatherService: widget.weatherService,
          isSaved: _savedIds.contains(destination.id),
          onSaveChanged: () => _toggleSaved(destination),
        ),
      ),
    );
  }

  void _toggleSaved(Destination destination) {
    setState(() {
      if (!_savedIds.add(destination.id)) {
        _savedIds.remove(destination.id);
      }
    });
  }

  void _showExplore({String? category}) {
    setState(() {
      _selectedIndex = 1;
      if (category != null) _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        destinations: _searchResults,
        weatherService: widget.weatherService,
        onSearch: (query) => setState(() => _searchQuery = query),
        onExplore: () => _showExplore(),
        onCategoryTap: (category) => _showExplore(category: category),
        onDestinationTap: _openDestination,
        savedIds: _savedIds,
        onSaveTap: _toggleSaved,
      ),
      ExplorePage(
        destinations: _searchResults,
        selectedCategory: _selectedCategory,
        onCategorySelected: (category) =>
            setState(() => _selectedCategory = category),
        onDestinationTap: _openDestination,
        savedIds: _savedIds,
        onSaveTap: _toggleSaved,
      ),
      SavedPage(
        destinations: _destinations
            .where((place) => _savedIds.contains(place.id))
            .toList(),
        onDestinationTap: _openDestination,
        savedIds: _savedIds,
        onSaveTap: _toggleSaved,
        onExplore: () => _showExplore(),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: _surface,
          systemNavigationBarDividerColor: _surface,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: false,
        ),
        child: Material(
          color: _surface,
          child: SafeArea(
            top: false,
            child: Align(
              alignment: Alignment.center,
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: NavigationBar(
                  height: 68,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                  backgroundColor: _surface,
                  indicatorColor: _sand,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'Beranda',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.explore_outlined),
                      selectedIcon: Icon(Icons.explore_rounded),
                      label: 'Jelajah',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.bookmark_border_rounded),
                      selectedIcon: Icon(Icons.bookmark_rounded),
                      label: 'Disimpan',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    required this.destinations,
    required this.weatherService,
    required this.onSearch,
    required this.onExplore,
    required this.onCategoryTap,
    required this.onDestinationTap,
    required this.savedIds,
    required this.onSaveTap,
    super.key,
  });

  final List<Destination> destinations;
  final WeatherService weatherService;
  final ValueChanged<String> onSearch;
  final VoidCallback onExplore;
  final ValueChanged<String> onCategoryTap;
  final ValueChanged<Destination> onDestinationTap;
  final Set<String> savedIds;
  final ValueChanged<Destination> onSaveTap;

  @override
  Widget build(BuildContext context) {
    final featured = _destinations.first;
    final otherDestinations = destinations
        .where((place) => place.id != featured.id)
        .toList();
    return _PageFrame(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 15, 22, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  const _BrandMark(),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'sela',
                        style: TextStyle(
                          color: _forest,
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.2,
                        ),
                      ),
                      Text(
                        'CERITA PERJALANAN',
                        style: TextStyle(
                          color: _moss,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    tooltip: 'Lokasi: Indonesia',
                    icon: const Icon(
                      Icons.location_on_outlined,
                      color: _forest,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CATATAN PERJALANAN  /  01',
                    style: TextStyle(
                      color: _clay,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pergi sebentar,\npulang membawa cerita.',
                    style: TextStyle(
                      color: _forest,
                      fontFamily: 'serif',
                      fontSize: 30,
                      height: 1.08,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ide perjalanan lokal untuk akhir pekanmu.',
                    style: TextStyle(color: _moss, fontSize: 13),
                  ),
                  const SizedBox(height: 17),
                  TextField(
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      hintText: 'Cari tempat atau daerah...',
                      hintStyle: const TextStyle(color: _moss, fontSize: 13),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: _moss,
                        size: 21,
                      ),
                      filled: true,
                      fillColor: _surface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 23, 22, 12),
            sliver: SliverToBoxAdapter(
              child: _SectionHeading(
                eyebrow: 'PILIHAN REDAKSI',
                title: 'Satu tempat untuk disinggahi',
                action: 'Lihat semua',
                onAction: onExplore,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            sliver: SliverToBoxAdapter(
              child: _FeaturedCard(
                destination: featured,
                onTap: () => onDestinationTap(featured),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 15, 22, 0),
            sliver: SliverToBoxAdapter(
              child: WeatherCard(
                destination: featured,
                weatherService: weatherService,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 12),
            sliver: SliverToBoxAdapter(
              child: _SectionHeading(
                eyebrow: 'SESUAI SUASANA',
                title: 'Mau ke mana?',
                action: 'Semua',
                onAction: onExplore,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 81,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                itemCount: _categories.length - 1,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = _categories[index + 1];
                  return _CategoryTile(
                    category: category,
                    onTap: () => onCategoryTap(category),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 12),
            sliver: SliverToBoxAdapter(
              child: _SectionHeading(
                eyebrow: 'CATATAN KECIL',
                title: 'Tempat lain yang menarik',
                action: 'Jelajahi',
                onAction: onExplore,
              ),
            ),
          ),
          if (destinations.isEmpty || otherDestinations.isEmpty)
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(22, 0, 22, 25),
              sliver: SliverToBoxAdapter(
                child: _EmptyState(
                  icon: Icons.travel_explore_rounded,
                  title: 'Belum ada tempat lain',
                  message: 'Coba kata pencarian yang berbeda.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
              sliver: SliverList.separated(
                itemCount: otherDestinations.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final destination = otherDestinations[index];
                  return _DestinationListTile(
                    destination: destination,
                    isSaved: savedIds.contains(destination.id),
                    onTap: () => onDestinationTap(destination),
                    onSaveTap: () => onSaveTap(destination),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({
    required this.destinations,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onDestinationTap,
    required this.savedIds,
    required this.onSaveTap,
    super.key,
  });

  final List<Destination> destinations;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<Destination> onDestinationTap;
  final Set<String> savedIds;
  final ValueChanged<Destination> onSaveTap;

  @override
  Widget build(BuildContext context) {
    final visiblePlaces = destinations
        .where(
          (place) =>
              selectedCategory == 'Semua' || place.category == selectedCategory,
        )
        .toList();

    return _PageFrame(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 5),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Jelajahi',
                style: const TextStyle(
                  color: _forest,
                  fontFamily: 'serif',
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
            sliver: const SliverToBoxAdapter(
              child: Text(
                'Sudut-sudut Indonesia, dipilih untuk dinikmati pelan-pelan.',
                style: TextStyle(color: _moss, fontSize: 13, height: 1.4),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final selected = category == selectedCategory;
                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) => onCategorySelected(category),
                    showCheckmark: false,
                    backgroundColor: _surface,
                    selectedColor: _forest,
                    side: BorderSide.none,
                    labelStyle: TextStyle(
                      color: selected ? _surface : _forest,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
            sliver: SliverToBoxAdapter(
              child: Text(
                '${visiblePlaces.length} TEMPAT',
                style: const TextStyle(
                  color: _moss,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          if (visiblePlaces.isEmpty)
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(22, 5, 22, 22),
              sliver: SliverToBoxAdapter(
                child: _EmptyState(
                  icon: Icons.travel_explore_rounded,
                  title: 'Belum ada tempat di sini',
                  message: 'Coba kategori atau kata pencarian yang berbeda.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
              sliver: SliverList.separated(
                itemCount: visiblePlaces.length,
                separatorBuilder: (_, _) => const SizedBox(height: 11),
                itemBuilder: (context, index) {
                  final destination = visiblePlaces[index];
                  return _DestinationListTile(
                    destination: destination,
                    isSaved: savedIds.contains(destination.id),
                    onTap: () => onDestinationTap(destination),
                    onSaveTap: () => onSaveTap(destination),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class SavedPage extends StatelessWidget {
  const SavedPage({
    required this.destinations,
    required this.onDestinationTap,
    required this.savedIds,
    required this.onSaveTap,
    required this.onExplore,
    super.key,
  });

  final List<Destination> destinations;
  final ValueChanged<Destination> onDestinationTap;
  final Set<String> savedIds;
  final ValueChanged<Destination> onSaveTap;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return _PageFrame(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 5),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Tempat tersimpan',
                style: const TextStyle(
                  color: _forest,
                  fontFamily: 'serif',
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 19),
            sliver: const SliverToBoxAdapter(
              child: Text(
                'Rencana kecil untuk perjalanan berikutnya.',
                style: TextStyle(color: _moss, fontSize: 13),
              ),
            ),
          ),
          if (destinations.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
              sliver: SliverToBoxAdapter(
                child: _EmptyState(
                  icon: Icons.bookmark_border_rounded,
                  title: 'Belum ada yang disimpan',
                  message: 'Simpan tempat yang menarik, supaya mudah ditemukan lagi nanti.',
                  actionLabel: 'Cari inspirasi',
                  onAction: onExplore,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
              sliver: SliverList.separated(
                itemCount: destinations.length,
                separatorBuilder: (_, _) => const SizedBox(height: 11),
                itemBuilder: (context, index) {
                  final destination = destinations[index];
                  return _DestinationListTile(
                    destination: destination,
                    isSaved: savedIds.contains(destination.id),
                    onTap: () => onDestinationTap(destination),
                    onSaveTap: () => onSaveTap(destination),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class DestinationDetailPage extends StatefulWidget {
  const DestinationDetailPage({
    required this.destination,
    required this.weatherService,
    required this.isSaved,
    required this.onSaveChanged,
    super.key,
  });

  final Destination destination;
  final WeatherService weatherService;
  final bool isSaved;
  final VoidCallback onSaveChanged;

  @override
  State<DestinationDetailPage> createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  late bool _isSaved = widget.isSaved;

  void _toggleSaved() {
    setState(() => _isSaved = !_isSaved);
    widget.onSaveChanged();
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.destination;
    return Scaffold(
      body: _PageFrame(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 330,
              pinned: true,
              backgroundColor: place.color,
              foregroundColor: Colors.white,
              leading: IconButton.filledTonal(
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              actions: [
                IconButton.filledTonal(
                  onPressed: _toggleSaved,
                  tooltip: _isSaved ? 'Hapus dari simpanan' : 'Simpan tempat',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.3),
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(
                    _isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    _DestinationImage(destination: place),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x00000000), Color(0xB8000000)],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 22,
                      right: 22,
                      bottom: 25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Pill(label: place.category, dark: true),
                          const SizedBox(height: 9),
                          Text(
                            place.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'serif',
                              fontSize: 29,
                              height: 1.05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                place.region,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          color: _clay,
                          size: 17,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'Waktu yang disarankan: ${place.duration}',
                          style: const TextStyle(
                            color: _forest,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const _DetailHeading('Tentang tempat ini'),
                    const SizedBox(height: 8),
                    Text(
                      place.description,
                      style: const TextStyle(
                        color: _moss,
                        fontSize: 14,
                        height: 1.65,
                      ),
                    ),
                    const SizedBox(height: 20),
                    WeatherCard(
                      destination: place,
                      weatherService: widget.weatherService,
                      title: 'Cuaca di ${place.region}',
                    ),
                    const SizedBox(height: 23),
                    const _DetailHeading('Sebelum berangkat'),
                    const SizedBox(height: 11),
                    _InfoRow(
                      icon: Icons.wb_sunny_outlined,
                      label: 'Waktu yang pas',
                      value: place.bestTime,
                    ),
                    const SizedBox(height: 9),
                    _InfoRow(
                      icon: Icons.lightbulb_outline_rounded,
                      label: 'Catatan',
                      value: place.travelNote,
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _toggleSaved,
                        style: FilledButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _surface,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        icon: Icon(
                          _isSaved
                              ? Icons.bookmark_remove_rounded
                              : Icons.bookmark_add_outlined,
                        ),
                        label: Text(
                          _isSaved
                              ? 'Hapus dari simpanan'
                              : 'Simpan untuk nanti',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageFrame extends StatelessWidget {
  const _PageFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth > 760
              ? 760.0
              : constraints.maxWidth;
          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: width,
              height: constraints.maxHeight,
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 41,
      height: 41,
      decoration: BoxDecoration(
        color: _forest,
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Icon(Icons.near_me_outlined, color: _paper, size: 23),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.destination, required this.onTap});

  final Destination destination;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: destination.color,
      borderRadius: BorderRadius.circular(17),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 240,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _DestinationImage(destination: destination),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00000000), Color(0xB8000000)],
                  ),
                ),
              ),
              Positioned(
                top: 13,
                left: 13,
                child: _Pill(label: 'BALI  /  CATATAN 01'),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.region.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      destination.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'serif',
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Sebuah jeda di antara teduhnya bambu',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 13,
                bottom: 16,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: _paper,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    color: _forest,
                    size: 17,
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

class _DestinationListTile extends StatelessWidget {
  const _DestinationListTile({
    required this.destination,
    required this.isSaved,
    required this.onTap,
    required this.onSaveTap,
  });

  final Destination destination;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onSaveTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 74,
                  height: 74,
                  child: _DestinationImage(destination: destination),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.category.toUpperCase(),
                      style: const TextStyle(
                        color: _clay,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      destination.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _forest,
                        fontFamily: 'serif',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: _moss,
                          size: 13,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            destination.region,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: _moss, fontSize: 11),
                          ),
                        ),
                        Text(
                          destination.duration,
                          style: const TextStyle(
                            color: _moss,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onSaveTap,
                tooltip: isSaved ? 'Hapus dari simpanan' : 'Simpan tempat',
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isSaved ? _clay : _moss,
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DestinationImage extends StatelessWidget {
  const _DestinationImage({required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      destination.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _ImageFallback(destination: destination),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _ImageFallback(destination: destination);
      },
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: destination.color,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [destination.color, _forest],
              ),
            ),
          ),
          Positioned(
            right: -12,
            bottom: -28,
            child: Icon(
              Icons.landscape_outlined,
              size: 140,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          Center(
            child: Icon(
              _categoryIcon(destination.category),
              size: 32,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.action,
    required this.onAction,
  });

  final String eyebrow;
  final String title;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: const TextStyle(
                  color: _clay,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: _forest,
                  fontFamily: 'serif',
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: _moss,
            padding: const EdgeInsets.only(left: 8, right: 0),
            visualDensity: VisualDensity.compact,
          ),
          child: Text(
            action,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final String category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _surface,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: SizedBox(
          width: 78,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_categoryIcon(category), color: _forest, size: 21),
              const SizedBox(height: 6),
              Text(
                category,
                style: const TextStyle(
                  color: _forest,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, this.dark = false});

  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: dark ? Colors.black.withValues(alpha: 0.35) : _paper,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: dark ? Colors.white : _forest,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _DetailHeading extends StatelessWidget {
  const _DetailHeading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: _forest,
        fontFamily: 'serif',
        fontSize: 21,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _clay, size: 18),
          const SizedBox(width: 10),
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                color: _moss,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: _forest,
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 27),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, size: 31, color: _moss),
          const SizedBox(height: 9),
          Text(
            title,
            style: const TextStyle(
              color: _forest,
              fontFamily: 'serif',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _moss, fontSize: 12, height: 1.4),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

IconData _categoryIcon(String category) {
  return switch (category) {
    'Alam' => Icons.park_outlined,
    'Budaya' => Icons.temple_buddhist_outlined,
    'Bahari' => Icons.waves_rounded,
    'Kota' => Icons.location_city_outlined,
    'Sejarah' => Icons.account_balance_outlined,
    _ => Icons.explore_outlined,
  };
}
