# Aura Mood - Bipolar Tracking App

A self-hosted, privacy-first mood and medication tracking application designed for individuals with bipolar disorder. Features a cyberpunk-inspired UI with glassmorphism effects.

## Why Aura Mood?

Unlike cloud-based mood trackers that monetize your sensitive mental health data, Aura Mood puts you in control:

- **100% Self-Hosted**: Your mood entries, medication logs, and personal notes never leave your server
- **No Subscriptions**: Free and open source - no premium tiers, no artificial limitations
- **Designed for Bipolar**: Tracks the specific metrics that matter for mood cycling (anxiety, irritability, sleep)
- **Environmental Correlation**: Automatically captures weather data to identify patterns between mood and environmental factors
- **Twice-Daily Tracking**: AM/PM system optimized for catching mood fluctuations throughout the day
- **Medication Adherence**: Built-in checklist prevents missed doses and tracks patterns

Perfect for anyone who wants detailed mood tracking without sacrificing privacy or paying monthly fees.

## Features

### Core Tracking
- **Mood Tracking**: Track mood, anxiety, irritability, and sleep with intuitive circular sliders (mz-react-round-slider)
- **AM/PM Entry System**: Dual daily entries (morning and evening) with automatic period validation
- **Notes & Context**: Add detailed notes to each mood entry for journaling

### Medication Management
- **Medication CRUD**: Full create, read, update, delete functionality for medications
- **Daily Checklist**: Track medication adherence with visual checkboxes
- **Scheduling**: Set medication times with hover-reveal edit/delete buttons
- **Adherence Logs**: Historical medication tracking with status (taken/missed/late)

### Data Visualization
- **3-Month Historical Charts**: View up to 180 entries (90 days × 2 entries/day)
- **Dual-Axis Display**: Mood lines (left axis) + sleep bars (right axis)
- **AM/PM Differentiation**: Sleep bars color-coded by time period (cyan for AM, indigo for PM)
- **Multiple Metrics**: Overlay mood, anxiety, irritability trends on a single chart
- **Interactive Tooltips**: Hover to see detailed data including weather context

### Weather Integration
- **Automatic Capture**: Optional weather data capture during mood entry via geolocation
- **Environmental Factors**: Temperature (°F), rainfall (mm), cloud cover (%), moon phase
- **Manual Sync**: Standalone weather widget for on-demand environmental data
- **Correlation Analysis**: Weather context displayed in chart tooltips for pattern recognition

### Privacy & Self-Hosting
- **Self-Hosted**: All data stored locally on your server (SQLite)
- **No Analytics**: Zero tracking, telemetry, or external data sharing
- **Docker Ready**: Containerized deployment with docker-compose
- **Push Notifications**: ntfy.sh integration for medication reminders (with test notification)

### User Experience
- **Cyberpunk UI**: Glassmorphism effects with clipped corners and neon accents
- **Mobile-First**: Responsive design optimized for all devices (touch-friendly)
- **Toast Notifications**: Real-time feedback for all actions
- **Dark Mode**: Eye-friendly dark theme optimized for evening use

## Screenshots

> 📸 Screenshots coming soon! The app features a cyberpunk-inspired dark theme with glassmorphism effects, circular mood sliders, and interactive data visualization.

## Tech Stack

- **Frontend**: Next.js 16 (App Router), React 19, TypeScript
- **Styling**: Tailwind CSS 4, Glassmorphism effects, Custom cyberpunk CSS
- **Database**: SQLite with Prisma ORM v6
- **Charts**: Recharts (ComposedChart with dual Y-axes)
- **UI Components**: Lucide React icons, mz-react-round-slider v1.0.3
- **Weather API**: Open-Meteo (free, no API key required)
- **Notifications**: ntfy.sh
- **Deployment**: Docker & Docker Compose

## Quick Start

### Prerequisites

- Node.js 20+ (with npm)
- Docker & Docker Compose (for containerized deployment)

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/Womackv3/AuraMood_.git
   cd AuraMood_
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Initialize database**
   ```bash
   npm run db:push
   ```

5. **Start development server**
   ```bash
   npm run dev
   ```

6. **Open browser**
   Navigate to `http://localhost:3000`

### Docker Deployment

1. **Build and run with Docker Compose**
   ```bash
   docker-compose up -d
   ```

   This will start:
   - Aura Mood app on `http://localhost:3000`
   - ntfy notification server on `http://localhost:8080`

2. **View logs**
   ```bash
   docker-compose logs -f
   ```

3. **Stop services**
   ```bash
   docker-compose down
   ```

## Database Management

- **Open Prisma Studio** (database GUI):
  ```bash
  npm run db:studio
  ```

- **Push schema changes**:
  ```bash
  npm run db:push
  ```

- **Generate Prisma Client**:
  ```bash
  npm run db:generate
  ```

## API Endpoints

### Mood Entries
- `POST /api/mood` - Create mood entry (with AM/PM validation and optional weather data)
- `GET /api/mood?limit=180` - Get mood history (default: 30, max tested: 180 for 3 months)

### Medications
- `GET /api/medications` - List all medications
- `POST /api/medications` - Create medication
- `GET /api/medications/:id` - Get medication
- `PUT /api/medications/:id` - Update medication
- `DELETE /api/medications/:id` - Delete medication

### Medication Logs
- `GET /api/med-logs` - Get medication logs
- `POST /api/med-logs` - Log medication adherence

### Weather
- `GET /api/weather?lat={lat}&lon={lon}` - Fetch weather data

## Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
DATABASE_URL="file:./data/aura.db"
NODE_ENV="development"
```

### Notification Setup (ntfy)

1. Install the ntfy app on your phone ([iOS](https://apps.apple.com/us/app/ntfy/id1625396347) / [Android](https://play.google.com/store/apps/details?id=io.heckel.ntfy))
2. Subscribe to a unique topic (e.g., `my_secure_mood_topic_12345`)
3. Navigate to Settings page in Aura Mood
4. Enter your ntfy server URL (default: `http://localhost:8080` for self-hosted)
5. Enter your topic name
6. Click "Test Notification" to verify setup
7. Save settings
8. Notifications will be sent for medication reminders (future enhancement)

## Implementation Details

### AM/PM Entry System
The app enforces twice-daily mood tracking:
- **Morning period**: 12:00 AM - 11:59 AM
- **Evening period**: 12:00 PM - 11:59 PM
- Server-side validation prevents duplicate entries per period (HTTP 429 if already logged)
- Chart differentiates AM vs PM sleep entries with color coding

### Weather Data Flow
1. User enables "Capture Weather Data" toggle on mood entry form
2. App requests geolocation permission from browser
3. Coordinates sent to `/api/weather` endpoint
4. Open-Meteo API fetched server-side (no API key required)
5. Weather data saved as `WeatherSnapshot` relation to mood entry
6. Displayed in chart tooltips and WeatherSync component

### Chart Architecture
- **ComposedChart** from Recharts allows overlaying Line + Bar components
- **Dual Y-axes**: Left axis (1-10 scale) for mood/anxiety/irritability, right axis (0-12 hrs) for sleep
- **Data transformation**: API returns entries in reverse chronological order, transformed to include `sleepAM` and `sleepPM` fields
- **Label management**: `interval="preserveStartEnd"` prevents X-axis crowding with 180 data points
- **Mobile optimization**: Reduced height (300px) and angled labels for small screens

### Medication Edit/Delete UI
- Hover-reveal buttons using CSS `opacity-0 group-hover:opacity-100` transition
- Edit opens modal with pre-populated fields using `useEffect` on medication prop change
- Delete requires confirmation via browser `confirm()` dialog
- Optimistic UI updates using React state before server confirmation

## Project Structure

```
├── app/
│   ├── api/              # API routes
│   │   ├── mood/         # Mood entry endpoints
│   │   ├── medications/  # Medication CRUD
│   │   ├── med-logs/     # Adherence logging
│   │   └── weather/      # Weather data
│   ├── settings/         # Settings page
│   └── page.tsx          # Dashboard
├── components/           # React components
│   ├── MoodEntryCard.tsx
│   ├── MoodRing.tsx
│   ├── MoodChart.tsx
│   ├── MedicationList.tsx
│   ├── AddMedicationModal.tsx
│   ├── WeatherSync.tsx
│   └── ToastContainer.tsx
├── lib/                  # Utilities
│   ├── prisma.ts         # Database client
│   ├── weather.ts        # Weather API
│   └── useToast.ts       # Toast notifications
├── prisma/
│   └── schema.prisma     # Database schema
└── public/               # Static assets
```

## Database Schema

### MoodEntry
- Mood level (1-10)
- Anxiety level (1-10)
- Irritability level (1-10)
- Sleep hours
- Notes
- Timestamp
- Weather snapshot (optional)

### Medication
- Name
- Dosage
- Schedule time

### MedLog
- Medication reference
- Status (taken/missed/late)
- Timestamp

### WeatherSnapshot
- Temperature (°F)
- Cloud cover (%)
- Rainfall (mm)
- Moon phase

## Customization

### Theme Colors

Edit `app/globals.css` to customize the color palette:

```css
--color-aura-purple: #7c3aed;
--color-aura-purple-dark: #6d28d9;
--color-aura-slate-900: #0f172a;
```

### Cyberpunk Effects

The app includes custom cyberpunk styling in `app/cyberpunk-2077.css` with:
- Glitch animations
- Clipped corners
- Neon glows

## Backup & Restore

### Backup SQLite Database

```bash
cp ./data/aura.db ./backups/aura-$(date +%Y%m%d).db
```

### Restore from Backup

```bash
cp ./backups/aura-20260127.db ./data/aura.db
```

## Development Scripts

```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run start        # Start production server
npm run lint         # Run ESLint
npm run db:push      # Push schema to database
npm run db:studio    # Open Prisma Studio
npm run db:generate  # Generate Prisma Client
npm run docker:build # Build Docker image
npm run docker:up    # Start Docker containers
```

## Privacy & Security

- **Self-hosted**: All data stored locally on your server
- **No analytics**: Zero tracking or telemetry
- **SQLite**: Simple file-based database
- **Local-first**: Works offline after initial load
- **No external dependencies**: Weather API is the only external call (Open-Meteo)

## Roadmap / Future Enhancements

- [ ] Automated medication reminders via ntfy (scheduled notifications)
- [ ] Export data to CSV/JSON for external analysis
- [ ] Correlation analysis between weather and mood
- [ ] Multi-user support with authentication
- [ ] Weekly/monthly mood summaries
- [ ] Customizable mood tracking metrics
- [ ] Progressive Web App (PWA) for offline-first functionality
- [ ] Backup/restore UI within settings
- [ ] Medication refill reminders

## Known Issues

- Prisma v7 compatibility: Currently locked to Prisma v6 due to client generation issues
- Chart performance: With 180+ entries, initial render may be slow on low-end devices
- Weather API: Requires browser geolocation permission (no manual location input yet)

## License

MIT

## Contributing

Contributions welcome! Please open an issue first to discuss proposed changes.

## Troubleshooting

### Database Issues
- **"Prisma Client not generated"**: Run `npm run db:generate`
- **"Table doesn't exist"**: Run `npm run db:push` to sync schema
- **Lock file errors**: Delete `data/aura.db-journal` and restart

### Weather Not Capturing
- Check browser console for geolocation permission errors
- Ensure HTTPS or localhost (geolocation requires secure context)
- Verify `/api/weather` endpoint is accessible

### Chart Not Displaying
- Verify mood entries exist: `npm run db:studio` → open MoodEntry table
- Check browser console for Recharts errors
- Ensure at least 1 mood entry exists in database

### Docker Issues
- **Port 3000 already in use**: Change port in `docker-compose.yml`
- **Database not persisting**: Check volume mount in docker-compose
- **Build fails**: Try `docker-compose build --no-cache`

## Support

For issues and questions, please open a [GitHub issue](https://github.com/Womackv3/AuraMood_/issues).
