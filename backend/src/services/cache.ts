const CACHE_TTL_SECONDS = Number(process.env.CACHE_TTL_SECONDS || 120);

export interface CacheEntry<T> {
  data: T;
  timestamp: number;
}

const cache = new Map<string, CacheEntry<any>>();

export function cacheGet<T>(key: string): T | null {
  const entry = cache.get(key);
  if (!entry) return null;
  const now = Date.now();
  if (now - entry.timestamp > CACHE_TTL_SECONDS * 1000) {
    cache.delete(key);
    return null;
  }
  return entry.data;
}

export function cacheSet<T>(key: string, data: T): void {
  cache.set(key, { data, timestamp: Date.now() });
}

export function getCacheStats() {
  const now = Date.now();
  const active = Array.from(cache.values()).filter(
    entry => now - entry.timestamp <= CACHE_TTL_SECONDS * 1000
  ).length;
  return { totalKeys: cache.size, activeKeys: active, ttlSeconds: CACHE_TTL_SECONDS };
}