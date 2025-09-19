import { PlatformAdapter, PlatformResult, SearchParams, PlatformKey } from '../types.js';

export function makeUnavailableAdapter(key: PlatformKey): PlatformAdapter {
  return {
    key: key as any,
    async search(_params: SearchParams): Promise<PlatformResult> {
      return { platform: key as any, items: [], notAvailable: true };
    },
  };
}
