import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'api.dart';
import 'model/place.dart';
import 'detail.dart';
import 'add.dart';
import 'profile.dart';
import 'my_order.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Place>> _placesFuture;
  final PageController _bannerController = PageController();

  String _searchQuery = '';
  String _selectedCategory = '';

  final List<Map<String, dynamic>> _quickMenus = const [
    {'icon': Icons.terrain, 'label': 'Gunung', 'category': 'mountain'},
    {'icon': Icons.landscape, 'label': 'Bukit', 'category': 'hill'},
    {'icon': Icons.cabin, 'label': 'Camping', 'category': 'camp'},
    {'icon': Icons.waves, 'label': 'Pantai', 'category': 'beach'},
  ];

  final List<String> _promoBanners = const [
    'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
    'https://images.unsplash.com/photo-1491553895911-0055eca6402d',
  ];

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  void _loadPlaces() {
    setState(() {
      _placesFuture = ApiService.getAllPlaces();
    });
  }

  List<Place> _filterPlaces(final List<Place> places) {
    final String q = _searchQuery.toLowerCase();
    return places.where((final p) {
      final bool matchSearch = p.name.toLowerCase().contains(q) ||
          p.location.toLowerCase().contains(q);
      final bool matchCategory =
          _selectedCategory.isEmpty || p.category == _selectedCategory;
      return matchSearch && matchCategory;
    }).toList();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF00AAFF),
        title: const Text('Lombok Adventure',
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, color: Colors.white),
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (final _) => const MyOrderPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (final _) => const ProfilePage()),
              );
              // Reload in case logged out or something (though logged out usually goes to login page)
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah',
        onPressed: () async {
          final bool? added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (final _) => const AddPage()),
          );
          if (added == true) {
            _loadPlaces();
          }
        },
        backgroundColor: const Color(0xFF00AAFF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadPlaces();
        },
        child: CustomScrollView(
          slivers: [
            // Search Field
            SliverToBoxAdapter(
              child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (final String v) =>
                    setState(() => _searchQuery = v.trim()),
                decoration: InputDecoration(
                  hintText: 'Mau ke mana di Lombok?',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF00AAFF)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          // Quick Menu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _quickMenus.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (final BuildContext context, final int i) {
                  final Map<String, dynamic> menu = _quickMenus[i];
                  final bool selected = _selectedCategory == menu['category'];
                  return GestureDetector(
                    onTap: () => setState(() =>
                        _selectedCategory = selected ? '' : menu['category']),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.blue.withAlpha(64)
                                : Colors.blue.withAlpha(38),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(menu['icon'], color: Colors.blue),
                        ),
                        const SizedBox(height: 4),
                        Text(menu['label'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Promo Banner
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _bannerController,
                itemCount: _promoBanners.length,
                itemBuilder: (final BuildContext context, final int i) =>
                    Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: _promoBanners[i],
                      fit: BoxFit.cover,
                      placeholder: (final c, final _) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (final c, final _, final __) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Section Title
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Rekomendasi Trip Lombok',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          // Places Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: FutureBuilder<List<Place>>(
              future: _placesFuture,
              builder: (final BuildContext context,
                  final AsyncSnapshot<List<Place>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasError) {
                   return SliverToBoxAdapter(
                      child: Center(child: Text('Error: ${snapshot.error}')));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SliverToBoxAdapter(
                      child: Center(child: Text('Data tidak ditemukan')));
                }
                final List<Place> places = _filterPlaces(snapshot.data!);
                if (places.isEmpty) {
                   return const SliverToBoxAdapter(
                      child: Center(child: Text('Tidak ada yang cocok')));
                }
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75),
                  delegate: SliverChildBuilderDelegate(
                    (final BuildContext context, final int i) {
                      final Place place = places[i];
                      return GestureDetector(
                        onTap: () async {
                           await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (final _) => DetailPage(place: place)),
                          );
                          _loadPlaces(); // Reload to reflect any updates/deletes
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: CachedNetworkImage(
                                    imageUrl: place.safeImageUrl,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(place.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(place.location,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: places.length,
                  ),
                );
              },
            ),
          ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
          ],
        ),
      ),
    );
  }
}
