export type PlatformKey =
  | 'FakeStore'
  | 'MockBlinkit'
  | 'Blinkit'
  | 'Instamart'
  | 'Flipkart'
  | 'Amazon'
  | 'BigBasket'
  | 'Zepto'
  | 'DMart'
  | 'JioMart';

export type Location = { lat: number; lon: number };

export type ProductOffer = {
  id: string;
  title: string;
  price: number;
  currency: string;
  imageUrl?: string;
  productUrl?: string;
  inStock: boolean;
  store: PlatformKey;
  originalPrice?: number;
  offerText?: string; // use highlight color if present
};

export type PlatformResult = {
  platform: PlatformKey;
  items: ProductOffer[];
  notAvailable?: boolean;
};

export interface SearchParams {
  query: string;
  location?: Location;
  platforms?: PlatformKey[];
}

export interface PlatformAdapter {
  key: PlatformKey;
  search(params: SearchParams): Promise<PlatformResult>;
}
