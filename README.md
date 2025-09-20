# 🛒 Shoply

**One search, all stores, best price.**

Shoply is a comprehensive price comparison platform that helps users find the best deals across multiple online stores with a single search. Built with Flutter for mobile and a robust Node.js backend, Shoply aggregates product data from various e-commerce platforms to help users make informed purchasing decisions.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-43853D?style=flat&logo=node.js&logoColor=white)](https://nodejs.org)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=flat&logo=typescript&logoColor=white)](https://www.typescriptlang.org)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)](https://www.docker.com)

## ✨ Features

### For Users
- **🔍 Universal Search**: Search once across multiple platforms
- **💰 Price Comparison**: Compare prices from different stores instantly
- **📱 Cross-Platform**: Works on Android and iOS devices
- **🛒 Comparison Cart**: Add products from different stores to compare locally
- **📍 Location-Aware**: Get location-specific availability and pricing
- **⚡ Real-time Results**: Fast aggregated search results with caching
- **🎨 Clean UI**: Modern, intuitive interface with consistent design

### For Developers
- **🔌 Pluggable Architecture**: Easy to add new platform integrations
- **🐳 Docker Ready**: Complete containerization support
- **📊 REST API**: Well-documented backend API
- **🔒 Legal Compliance**: Only uses official APIs and mock data
- **⚙️ Configurable**: Environment-based configuration
- **📖 Comprehensive Documentation**: Detailed setup and usage guides

## 🏗️ Architecture

This monorepo contains two main components:

```
shoply/
├── app/          # Flutter mobile application
├── backend/      # Node.js + TypeScript API aggregator
├── scripts/      # Build and development scripts
└── docker-compose.yml
```

### Tech Stack

**Frontend (Flutter App)**
- Flutter 3.4+
- Riverpod for state management
- HTTP client for API communication
- Geolocator for location services

**Backend (API Aggregator)**
- Node.js + TypeScript
- Express.js web framework
- Zod for data validation
- In-memory caching with TTL
- Pluggable adapter system

## 🚀 Quick Start

### Prerequisites

- **Docker & Docker Compose** (recommended)
- **Flutter SDK 3.4+** (for app development)
- **Node.js 18+** (for backend development)

### Option 1: Docker (Recommended)

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/shoply.git
   cd shoply
   ```

2. **Start the backend**
   ```bash
   docker compose up --build -d
   ```
   The API will be available at `http://localhost:8080`

3. **Run the Flutter app**
   ```bash
   cd app
   flutter create .  # Initialize platform files (first time only)
   flutter pub get
   flutter run --dart-define=SHOPLY_API_BASE=http://localhost:8080
   ```

### Option 2: Local Development

1. **Backend Setup**
   ```bash
   cd backend
   cp .env.example .env
   npm install
   npm run build
   npm start
   ```

2. **Frontend Setup**
   ```bash
   cd app
   flutter pub get
   flutter run --dart-define=SHOPLY_API_BASE=http://localhost:8080
   ```

## 📱 How to Use Shoply

1. **Search Products**: Enter any product name in the search bar
2. **Compare Prices**: View results from multiple platforms side-by-side
3. **Check Availability**: See which stores have the product in stock
4. **Add to Cart**: Build a comparison cart with items from different stores
5. **Visit Store**: Tap any product to go directly to the store's website
6. **Filter Results**: Toggle specific platforms on/off

### Sample Search Flow
```
User searches "iPhone 15" → Shoply queries all platforms → 
Results show prices from FakeStore, MockBlinkit, etc. → 
User compares and clicks to purchase from preferred store
```

## 🛠️ API Documentation

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Service health check |
| GET | `/platforms` | List of enabled platforms |
| GET | `/search` | Search products across platforms |

### Search API Example

```bash
# Basic search
curl "http://localhost:8080/search?q=milk"

# Search with location
curl "http://localhost:8080/search?q=milk&lat=12.9716&lon=77.5946"

# Search specific platforms
curl "http://localhost:8080/search?q=milk&platforms=FakeStore,MockBlinkit"
```

**Response Format:**
```json
{
  "results": [
    {
      "platform": "FakeStore",
      "items": [
        {
          "id": "1",
          "title": "Product Name",
          "price": 299.99,
          "currency": "USD",
          "imageUrl": "https://...",
          "productUrl": "https://...",
          "inStock": true,
          "store": "FakeStore"
        }
      ]
    }
  ]
}
```

## 🎨 Design System

Shoply follows a consistent 60/30/10 color rule:

| Usage | Color | Hex Code | Purpose |
|-------|-------|----------|----------|
| Background (60%) | Light Gray | `#F9F9F9` | Main background |
| Primary (30%) | Mint Green | `#A8E6CF` | Primary actions, headers |
| Accent (10%) | Peach | `#FFD5C2` | Secondary elements |
| Highlight | Orange | `#FFB347` | Special offers, deals |

## 🔌 Extending Platform Support

### Adding New Platforms

1. **Create Adapter**
   ```typescript
   // backend/src/platforms/YourPlatform.ts
   export class YourPlatformAdapter implements PlatformAdapter {
     key: PlatformKey = 'YourPlatform';
     
     async search(params: SearchParams): Promise<PlatformResult> {
       // Implementation
     }
   }
   ```

2. **Register Adapter**
   ```typescript
   // backend/src/platforms/registry.ts
   import { YourPlatformAdapter } from './YourPlatform.js';
   
   registry.set('YourPlatform', new YourPlatformAdapter());
   ```

3. **Update Types**
   ```typescript
   // backend/src/types.ts
   export type PlatformKey = 'FakeStore' | 'YourPlatform' | ...;
   ```

### Current Platform Support

- ✅ **FakeStore** - Demo API integration
- ✅ **MockBlinkit** - Mock grocery delivery
- 🚧 Ready for: Flipkart, Amazon, BigBasket, Zepto, DMart, JioMart

## 📦 Building for Production

### Android APK
```bash
# Using the provided script
./scripts/build_apk.sh

# Or manually
cd app
flutter build apk --release --dart-define=SHOPLY_API_BASE=https://your-production-backend
```

### Backend Deployment
```bash
# Docker
docker build -t shoply-backend ./backend
docker run -p 8080:8080 --env-file .env shoply-backend

# Or use docker-compose for full stack
docker compose up --build
```

## 🔧 Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | 8080 | Backend server port |
| `CACHE_TTL_SECONDS` | 120 | Cache timeout in seconds |
| `ENABLED_PLATFORMS` | FakeStore,MockBlinkit | Comma-separated platform list |
| `AFFILIATE_MODE` | disabled | Affiliate link handling |

### Flutter Configuration

| Build Argument | Default | Description |
|----------------|---------|-------------|
| `SHOPLY_API_BASE` | http://localhost:8080 | Backend API URL |

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Scripts

```bash
# Backend development
./scripts/dev_backend.sh

# Flutter app development  
./scripts/dev_app.sh

# Build APK
./scripts/build_apk.sh
```

## ⚖️ Legal & Compliance

**Important**: Shoply respects platform terms of service and only uses:
- ✅ Official public APIs
- ✅ Mock/demo data for development
- ❌ No web scraping or man-in-the-middle techniques

Before adding real platform integrations, ensure you have proper API access and comply with their terms of service.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙋‍♀️ Support

- 📧 **Email**: support@shoply.com
- 🐛 **Issues**: [GitHub Issues](https://github.com/yourusername/shoply/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/yourusername/shoply/discussions)

## 🗺️ Roadmap

- [ ] iOS App Store deployment
- [ ] Push notifications for price drops
- [ ] User accounts and wishlists
- [ ] More platform integrations
- [ ] Price history tracking
- [ ] Advanced filtering options
- [ ] API rate limiting and authentication

---

**Made with ❤️ by the Shoply Team**

*"One search, all stores, best price."*
