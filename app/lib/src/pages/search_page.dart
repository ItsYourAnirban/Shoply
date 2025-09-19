import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api.dart';
import '../state/providers.dart';
import '../widgets/platform_result_card.dart';
import '../utils/iterable_ext.dart';
import '../../theme.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSearching = false;
  List<String> _selectedPlatforms = [];

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final appState = ref.read(appStateProvider);
      final location = appState.locationState.position;
      
      final response = await BackendApi.search(
        query: query,
        lat: location?.latitude,
        lon: location?.longitude,
        platforms: _selectedPlatforms.isNotEmpty ? _selectedPlatforms : null,
      );
      
      ref.read(appStateProvider.notifier).setLastSearch(query, response);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: ${e.toString()}'),
            backgroundColor: ShoplyColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  Widget _buildLocationButton() {
    final locationState = ref.watch(appStateProvider.select((s) => s.locationState));
    
    return IconButton(
      onPressed: locationState.isLoading 
        ? null 
        : () => ref.read(appStateProvider.notifier).requestLocation(),
      icon: locationState.isLoading
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(
            locationState.hasPermission ? Icons.location_on : Icons.location_off,
            color: locationState.hasPermission ? ShoplyColors.primary : ShoplyColors.textSecondary,
          ),
    );
  }

  Widget _buildPlatformFilter() {
    return ref.watch(availablePlatformsProvider).when(
      data: (platforms) => SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(width: 16),
            ...platforms.map((platform) {
              final isSelected = _selectedPlatforms.contains(platform);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(platform),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPlatforms.add(platform);
                      } else {
                        _selectedPlatforms.remove(platform);
                      }
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: ShoplyColors.primary,
                ),
              );
            }).toList(),
            const SizedBox(width: 16),
          ],
        ),
      ),
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildSearchResults() {
    final searchResponse = ref.watch(appStateProvider.select((s) => s.lastSearchResponse));
    
    if (searchResponse == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: ShoplyColors.textSecondary),
            SizedBox(height: 16),
            Text(
              'Search for products to compare prices',
              style: TextStyle(color: ShoplyColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (searchResponse.results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: ShoplyColors.error),
            SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(color: ShoplyColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: searchResponse.results.length,
      itemBuilder: (context, index) {
        final platformResult = searchResponse.results[index];
        return PlatformResultCard(
          platformResult: platformResult,
          onAddToCart: (offer) {
            ref.read(appStateProvider.notifier).addToCart(offer);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${offer.title} added to cart'),
                backgroundColor: ShoplyColors.primary,
                duration: const Duration(seconds: 1),
              ),
            );
          },
          onGoToStore: (offer) async {
            if (offer.productUrl != null) {
              final url = Uri.parse(offer.productUrl!);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItemCount = ref.watch(appStateProvider.select((s) => s.cartItems.length));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoply'),
        actions: [
          if (cartItemCount > 0)
            Stack(
              children: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                  icon: const Icon(Icons.shopping_cart),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: ShoplyColors.highlight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                _buildLocationButton(),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isSearching ? null : _performSearch,
                  child: _isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Search'),
                ),
              ],
            ),
          ),
          _buildPlatformFilter(),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }
}