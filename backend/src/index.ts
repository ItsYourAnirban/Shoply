import express, { Request, Response } from 'express';
import cors from 'cors';
import morgan from 'morgan';
import { z } from 'zod';
import { searchAllPlatforms, getEnabledPlatforms, type PlatformKey } from './platforms/registry.js';
import { getCacheStats } from './services/cache.js';

const app = express();
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

const PORT = process.env.PORT ? Number(process.env.PORT) : 8080;

const searchQuerySchema = z.object({
  q: z.string().min(1),
  lat: z.string().optional(),
  lon: z.string().optional(),
  platforms: z.string().optional()
});

app.get('/health', (_req: Request, res: Response) => {
  res.json({ ok: true, uptime: process.uptime(), cache: getCacheStats() });
});

app.get('/platforms', (_req: Request, res: Response) => {
  const platforms = getEnabledPlatforms();
  res.json({ platforms });
});

app.get('/search', async (req: Request, res: Response) => {
  const parse = searchQuerySchema.safeParse(req.query);
  if (!parse.success) {
    return res.status(400).json({ error: 'Invalid query params', details: parse.error.flatten() });
  }
  const { q, lat, lon, platforms } = parse.data;
  const selected: PlatformKey[] | undefined = platforms
    ? (platforms.split(',').map(s => s.trim()).filter(Boolean) as PlatformKey[])
    : undefined;
  const location = lat && lon ? { lat: Number(lat), lon: Number(lon) } : undefined;

  try {
    const results = await searchAllPlatforms({ query: q, location, platforms: selected });
    res.json({ query: q, location, results });
  } catch (err: any) {
    res.status(500).json({ error: 'SEARCH_FAILED', message: err?.message ?? 'Unknown error' });
  }
});

app.listen(PORT, () => {
  // eslint-disable-next-line no-console
  console.log(`Shoply backend running on :${PORT}`);
});
