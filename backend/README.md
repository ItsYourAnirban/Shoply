# Shoply Backend (Aggregator)

Node + TypeScript Express service that aggregates product search across platforms using adapters.

Endpoints
- GET /health — service health
- GET /platforms — enabled platforms
- GET /search?q=milk&lat=12.9&lon=77.6&platforms=FakeStore,MockBlinkit — search with optional location and platform filter

Features
- Short-term in-memory caching (TTL 120s)
- Toggle platforms via ENABLED_PLATFORMS
- Redirect/affiliate hooks placeholder (disabled by default)

Legal note
Only one real connector is included (FakeStore public API). Mock connectors show how to extend. Do not use scraping or MITM on third-party services without explicit permission and legal review.

Setup
1. cp .env.example .env
2. npm install
3. npm run build
4. npm start

Docker
- docker build -t shoply-backend .
- docker run -p 8080:8080 --env-file .env shoply-backend
