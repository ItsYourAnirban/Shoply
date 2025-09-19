import { PlatformAdapter, SearchParams, PlatformResult } from '../types.js';
import { fakeStoreAdapter } from './fake-store.js';
import { mockBlinkitAdapter } from './mock-blinkit.js';
import { makeUnavailableAdapter } from './stubs.js';
import { cacheGet, cacheSet } from '../services/cache.js';

// All known adapters
const allAdapters: PlatformAdapter[] = [
  fakeStoreAdapter,
  mockBlinkitAdapter,
  makeUnavailableAdapter('Blinkit'),
  makeUnavailableAdapter('Instamart'),
  makeUnavailableAdapter('Flipkart'),
  makeUnavailableAdapter('Amazon'),
  makeUnavailableAdapter('BigBasket'),
  makeUnavailableAdapter('Zepto'),
  makeUnavailableAdapter('DMart'),
  makeUnavailableAdapter('JioMart'),
  // Future: real adapters would go here
];

// Environment-based filtering
const ENABLED_PLATFORMS = (process.env.ENABLED_PLATFORMS || 'FakeStore,MockBlinkit')
  .split(',')
  .map(s => s.trim())
  .filter(Boolean);

export type PlatformKey = typeof ENABLED_PLATFORMS[0] extends string
  ? Extract<'FakeStore' | 'MockBlinkit' | 'Blinkit' | 'Instamart' | 'Flipkart' | 'Amazon' | 'BigBasket' | 'Zepto' | 'DMart' | 'JioMart', string>
  : never;

export function getEnabledPlatforms() {
  return allAdapters
    .filter(adapter => ENABLED_PLATFORMS.includes(adapter.key))
    .map(adapter => ({ key: adapter.key }));
}

function withAffiliate(url: string): string {
  try {
    const u = new URL(url);
    // Example affiliate parameter; replace with real program params when enabled
    if (!u.searchParams.has('affid')) {
      u.searchParams.set('affid', 'shoply');
    }
    return u.toString();
  } catch {
    return url;
  }
}

export async function searchAllPlatforms(params: SearchParams): Promise<PlatformResult[]> {
  const cacheKey = JSON.stringify({
    query: params.query,
    location: params.location,
    platforms: params.platforms,
  });

  const cached = cacheGet<PlatformResult[]>(cacheKey);
  if (cached) {
    return cached;
  }

  // Filter adapters by enabled platforms and requested platforms
  const enabledAdapters = allAdapters.filter(adapter =>
    ENABLED_PLATFORMS.includes(adapter.key) &&
    (!params.platforms || params.platforms.includes(adapter.key as any))
  );

  // Run searches in parallel
  const promises = enabledAdapters.map(async (adapter) => {
    try {
      return await adapter.search(params);
    } catch (error) {
      console.error(`Platform ${adapter.key} failed:`, error);
      return {
        platform: adapter.key,
        items: [],
        notAvailable: true,
      } as PlatformResult;
    }
  });

  const results = await Promise.allSettled(promises);
  const validResults = results
    .filter((result): result is PromiseFulfilledResult<PlatformResult> => result.status === 'fulfilled')
    .map(result => result.value);

  // Affiliate hook (disabled by default)
  const affiliateMode = (process.env.AFFILIATE_MODE || 'disabled').toLowerCase();
  const processed = validResults.map(r => ({
    ...r,
    items: r.items.map(item => ({
      ...item,
      productUrl: affiliateMode === 'enabled' && item.productUrl
        ? withAffiliate(item.productUrl)
        : item.productUrl,
    })),
  }));

  cacheSet(cacheKey, processed);
  return processed;
}