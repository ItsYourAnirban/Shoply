import axios from 'axios';
import { PlatformAdapter, SearchParams, PlatformResult } from '../types.js';

interface FakeStoreProduct {
  id: number;
  title: string;
  price: number;
  description: string;
  category: string;
  image: string;
  rating: {
    rate: number;
    count: number;
  };
}

export const fakeStoreAdapter: PlatformAdapter = {
  key: 'FakeStore',

  async search({ query }: SearchParams): Promise<PlatformResult> {
    try {
      // Real API call to FakeStore (public, no auth needed)
      const response = await axios.get<FakeStoreProduct[]>('https://fakestoreapi.com/products');
      const allProducts = response.data;

      // Basic text search
      const filtered = allProducts.filter(p =>
        p.title.toLowerCase().includes(query.toLowerCase()) ||
        p.description.toLowerCase().includes(query.toLowerCase()) ||
        p.category.toLowerCase().includes(query.toLowerCase())
      );

      const items = filtered.slice(0, 10).map(product => ({
        id: `fakestore-${product.id}`,
        title: product.title,
        price: product.price,
        currency: 'USD',
        imageUrl: product.image,
        productUrl: `https://fakestoreapi.com/products/${product.id}`,
        inStock: true,
        store: 'FakeStore' as const,
        offerText: product.rating.count > 100 ? 'Popular' : undefined,
      }));

      return { platform: 'FakeStore', items };
    } catch (error) {
      console.error('FakeStore API error:', error);
      return { platform: 'FakeStore', items: [], notAvailable: true };
    }
  },
};