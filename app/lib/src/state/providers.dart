import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api.dart';
import '../utils/iterable_ext.dart';

class CartItem {
  final ProductOffer offer;
  final int quantity;

  CartItem({required this.offer, this.quantity = 1});

  CartItem copyWith({int? quantity}) {
    return CartItem(offer: offer, quantity: quantity ?? this.quantity);
  }
}

class LocationState {
  final bool hasPermission;
  final Position? position;
  final bool isLoading;

  LocationState({
    required this.hasPermission,
    required this.position,
    required this.isLoading,
  });
}

class AppState {
  final List<CartItem> cartItems;
  final String lastQuery;
  final SearchResponse? lastSearchResponse;
  final LocationState locationState;

  AppState({
    required this.cartItems,
    required this.lastQuery,
    required this.lastSearchResponse,
    required this.locationState,
  });

  AppState copyWith({
    List<CartItem>? cartItems,
    String? lastQuery,
    SearchResponse? lastSearchResponse,
    LocationState? locationState,
  }) {
    return AppState(
      cartItems: cartItems ?? this.cartItems,
      lastQuery: lastQuery ?? this.lastQuery,
      lastSearchResponse: lastSearchResponse ?? this.lastSearchResponse,
      locationState: locationState ?? this.locationState,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier()
      : super(AppState(
          cartItems: [],
          lastQuery: '',
          lastSearchResponse: null,
          locationState: LocationState(
            hasPermission: false,
            position: null,
            isLoading: false,
          ),
        ));

  void addToCart(ProductOffer offer) {
    final existing = state.cartItems.where((item) => item.offer.id == offer.id).firstOrNull;
    if (existing != null) {
      final newItems = state.cartItems.map((item) {
        if (item.offer.id == offer.id) {
          return item.copyWith(quantity: item.quantity + 1);
        }
        return item;
      }).toList();
      state = state.copyWith(cartItems: newItems);
    } else {
      state = state.copyWith(cartItems: [...state.cartItems, CartItem(offer: offer)]);
    }
  }

  void removeFromCart(String offerId) {
    final newItems = state.cartItems.where((item) => item.offer.id != offerId).toList();
    state = state.copyWith(cartItems: newItems);
  }

  void clearCart() {
    state = state.copyWith(cartItems: []);
  }

  void setLastSearch(String query, SearchResponse response) {
    state = state.copyWith(lastQuery: query, lastSearchResponse: response);
  }

  Future<void> requestLocation() async {
    state = state.copyWith(
      locationState: LocationState(
        hasPermission: false,
        position: null,
        isLoading: true,
      ),
    );

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          locationState: LocationState(
            hasPermission: false,
            position: null,
            isLoading: false,
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        state = state.copyWith(
          locationState: LocationState(
            hasPermission: false,
            position: null,
            isLoading: false,
          ),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      state = state.copyWith(
        locationState: LocationState(
          hasPermission: true,
          position: position,
          isLoading: false,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        locationState: LocationState(
          hasPermission: false,
          position: null,
          isLoading: false,
        ),
      );
    }
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

final availablePlatformsProvider = FutureProvider<List<String>>((ref) async {
  return BackendApi.getPlatforms();
});