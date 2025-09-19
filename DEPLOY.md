# Shoply Cloud Deployment Guide

Follow these steps to get Shoply running in the cloud and viewable in your browser:

## 1. Push to GitHub

```bash
cd /Users/ani/shoply
git init
git add .
git commit -m "Initial Shoply implementation"

# Create GitHub repo and push (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/shoply.git
git branch -M main
git push -u origin main
```

## 2. Deploy Backend to Render (Free)

1. Go to https://render.com and sign up with GitHub
2. Click "New" → "Blueprint" 
3. Connect your GitHub repo
4. Render will auto-detect the `render.yaml` and deploy the backend
5. Copy the backend URL (e.g., `https://shoply-backend-abc123.onrender.com`)

## 3. Deploy Flutter Web App

1. In your GitHub repo settings:
   - Go to Settings → Pages
   - Enable Pages with "GitHub Actions" source
   - Go to Settings → Secrets and variables → Actions
   - Add secret: `SHOPLY_API_BASE` = your Render backend URL

2. Push any change to trigger the build:
   ```bash
   git commit --allow-empty -m "Trigger deployment"
   git push
   ```

3. Your app will be live at: `https://YOUR_USERNAME.github.io/shoply/`

## 4. Add CodeRabbit (Optional)

1. Go to https://coderabbit.ai
2. Install the GitHub App on your repo
3. CodeRabbit will automatically review all PRs using the `.coderabbit.yaml` config

## 5. Test the Full Flow

1. Open `https://YOUR_USERNAME.github.io/shoply/`
2. Search for "electronics" or "clothing" 
3. Click the location button to enable location (mock data varies by location)
4. Add items to cart and test "Go to store" redirects
5. Try platform filters

## Alternative: Local Testing

If you want to test locally first:

1. Install Flutter: https://flutter.dev/docs/get-started/install
2. Install Node.js: https://nodejs.org
3. Run backend: `cd backend && npm install && npm run dev`
4. Run Flutter web: `cd app && flutter pub get && flutter run -d web-server --web-port 3000`

## Emulator Access

- **Web "emulator"**: Your GitHub Pages URL works on any device with a browser
- **Android Studio**: Install AS, create a virtual device, then `flutter run` targets it
- **iOS Simulator**: On Mac with Xcode, `flutter run` will launch iOS simulator

The web version acts as a universal "cloud emulator" accessible from anywhere!