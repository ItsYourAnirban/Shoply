import { PlatformAdapter, SearchParams, PlatformResult } from '../types.js';

export const mockBlinkitAdapter: PlatformAdapter = {
  key: 'MockBlinkit',

  async search({ query, location }: SearchParams): Promise<PlatformResult> {
    // Simulate location-scoped availability: only available if within a "service area"
    const available = location ? (Math.abs(location.lat) + Math.abs(location.lon)) % 2 < 1 : false;

    if (!available) {
      return { platform: 'MockBlinkit', items: [], notAvailable: true };
    }

    // Very simple mock data demonstrating schema
    const canonical = query.trim().toLowerCase();
    const items = [
      {
        id: 'mock-blinkit-1',
        title: `${canonical} — 1 kg`,
        price: 119,
        currency: 'INR',
        imageUrl: 'https://placehold.co/200x200?text=Blinkit',
        productUrl: 'https://blinkit.com/',
        inStock: true,
        store: 'MockBlinkit' as const,
        originalPrice: 139,
        offerText: 'Save ₹20',
      },
      {
        id: 'mock-blinkit-2',
        title: `${canonical} — 500 g`,
        price: 69,
        currency: 'INR',
        imageUrl: 'https://placehold.co/200x200?text=Blinkit',
        productUrl: 'https://blinkit.com/',
        inStock: true,
        store: 'MockBlinkit' as const,
      },
    ];

    return { platform: 'MockBlinkit', items } as PlatformResult;
  },
};
